param(
  [switch]$Open
)

$ErrorActionPreference = "Stop"

$Root = Split-Path -Parent $MyInvocation.MyCommand.Path
$DataDir = Join-Path $Root "Data"
$OutFile = Join-Path $Root "library-data.js"
$IndexFile = Join-Path $Root "index.html"

if (-not (Test-Path -LiteralPath $DataDir -PathType Container)) {
  throw "Cannot find Data folder: $DataDir"
}

function Read-Utf8File {
  param([Parameter(Mandatory = $true)][string]$Path)

  $bytes = [System.IO.File]::ReadAllBytes($Path)
  if ($bytes.Length -ge 3 -and $bytes[0] -eq 0xEF -and $bytes[1] -eq 0xBB -and $bytes[2] -eq 0xBF) {
    return [System.Text.Encoding]::UTF8.GetString($bytes, 3, $bytes.Length - 3)
  }

  return [System.Text.Encoding]::UTF8.GetString($bytes)
}

function Convert-HtmlFragmentToText {
  param([string]$Html)

  if ([string]::IsNullOrWhiteSpace($Html)) {
    return ""
  }

  $text = [regex]::Replace($Html, "(?is)<br\s*/?>", " ")
  $text = [regex]::Replace($text, "(?is)</(p|div|li|tr|td|th|h[1-6]|section|article|details|summary)>", " ")
  $text = [regex]::Replace($text, "(?is)<[^>]+>", " ")
  $text = [System.Net.WebUtility]::HtmlDecode($text)
  $text = $text -replace [char]0x00A0, " "
  $text = [regex]::Replace($text, "\s+", " ").Trim()
  return $text
}

function Get-FirstHtmlText {
  param(
    [string]$Html,
    [string]$Pattern,
    [int]$Group = 1
  )

  $match = [regex]::Match($Html, $Pattern)
  if (-not $match.Success -or $match.Groups.Count -le $Group) {
    return ""
  }

  return Convert-HtmlFragmentToText $match.Groups[$Group].Value
}

function Get-AllHtmlText {
  param(
    [string]$Html,
    [string]$Pattern,
    [int]$Group = 1
  )

  $results = New-Object System.Collections.Generic.List[string]
  foreach ($match in [regex]::Matches($Html, $Pattern)) {
    if ($match.Success -and $match.Groups.Count -gt $Group) {
      $value = Convert-HtmlFragmentToText $match.Groups[$Group].Value
      if (-not [string]::IsNullOrWhiteSpace($value)) {
        $results.Add($value)
      }
    }
  }
  return $results.ToArray()
}

function Get-Excerpt {
  param(
    [string]$Text,
    [int]$MaxLength = 260
  )

  if ([string]::IsNullOrWhiteSpace($Text)) {
    return ""
  }

  $clean = [regex]::Replace($Text, "\s+", " ").Trim()
  if ($clean.Length -le $MaxLength) {
    return $clean
  }

  return $clean.Substring(0, $MaxLength).Trim() + "..."
}

$files = Get-ChildItem -LiteralPath $DataDir -Filter "*.html" -File | Sort-Object LastWriteTime -Descending
$items = @()
$seenIds = @{}

foreach ($file in $files) {
  $html = Read-Utf8File $file.FullName
  $title = Get-FirstHtmlText $html "(?is)<title\b[^>]*>(.*?)</title>"
  $heading = Get-FirstHtmlText $html "(?is)<h1\b[^>]*>(.*?)</h1>"
  $subtitle = Get-FirstHtmlText $html "(?is)<p\b[^>]*class\s*=\s*[""'][^""']*\b(subtitle|sub)\b[^""']*[""'][^>]*>(.*?)</p>" 2
  $sections = Get-AllHtmlText $html "(?is)<h2\b[^>]*>(.*?)</h2>"

  $body = Get-FirstHtmlText $html "(?is)<body\b[^>]*>(.*?)</body>"
  if ([string]::IsNullOrWhiteSpace($body)) {
    $body = Convert-HtmlFragmentToText $html
  }

  $displayTitle = $title
  if ([string]::IsNullOrWhiteSpace($displayTitle)) {
    $displayTitle = $heading
  }
  if ([string]::IsNullOrWhiteSpace($displayTitle)) {
    $displayTitle = [System.IO.Path]::GetFileNameWithoutExtension($file.Name)
  }

  $searchText = [regex]::Replace(($displayTitle, $heading, $subtitle, ($sections -join " "), $body -join " "), "\s+", " ").Trim()
  if ($searchText.Length -gt 60000) {
    $searchText = $searchText.Substring(0, 60000)
  }

  $idSource = [System.IO.Path]::GetFileNameWithoutExtension($file.Name).ToLowerInvariant()
  $id = [regex]::Replace($idSource, "[^a-z0-9ก-๙]+", "-").Trim("-")
  if ([string]::IsNullOrWhiteSpace($id)) {
    $id = [guid]::NewGuid().ToString("N")
  }
  $baseId = $id
  $suffix = 2
  while ($seenIds.ContainsKey($id)) {
    $id = "$baseId-$suffix"
    $suffix++
  }
  $seenIds[$id] = $true

  $excerptSource = $body
  if (-not [string]::IsNullOrWhiteSpace($subtitle)) {
    $excerptSource = $subtitle
  }

  $items += [pscustomobject]@{
    id = $id
    title = $displayTitle
    heading = $heading
    subtitle = $subtitle
    fileName = $file.Name
    path = "Data/$($file.Name)"
    modified = $file.LastWriteTime.ToString("yyyy-MM-dd HH:mm")
    modifiedIso = $file.LastWriteTime.ToString("o")
    sizeKb = [math]::Round($file.Length / 1KB, 1)
    sections = @($sections)
    excerpt = Get-Excerpt $excerptSource
    searchText = $searchText
  }
}

$manifest = [pscustomobject]@{
  generatedAt = (Get-Date).ToString("yyyy-MM-dd HH:mm")
  generatedAtIso = (Get-Date).ToString("o")
  dataFolder = "Data"
  totalFiles = $items.Count
  files = $items
}

$json = $manifest | ConvertTo-Json -Depth 8
$js = "window.T6SYS_LIBRARY = $json;`r`n"
$utf8NoBom = New-Object System.Text.UTF8Encoding $false
[System.IO.File]::WriteAllText($OutFile, $js, $utf8NoBom)

Write-Host "Updated $OutFile"
Write-Host "Found $($items.Count) HTML file(s) in $DataDir"

if ($Open) {
  if (-not (Test-Path -LiteralPath $IndexFile -PathType Leaf)) {
    throw "Cannot find index.html: $IndexFile"
  }
  Invoke-Item -LiteralPath $IndexFile
}
