# วิธีอัปเดต Data และ Push ขึ้น GitHub

ไฟล์นี้ใช้เป็นคู่มือเวลามีไฟล์ `.html` ใหม่ในโฟลเดอร์ `Data` แล้วต้องการอัปเดตรายการในหน้าอ่านบทเรียน และ push ขึ้น GitHub repo:

`https://github.com/DyukeDook/T6sys.git`

## สรุปสั้นที่สุด

1. วางไฟล์ `.html` ใหม่ไว้ใน `Data`
2. รันสคริปต์สร้างรายการไฟล์ใหม่:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\Update-Reader.ps1
```

3. เปิด `index.html` หรือดับเบิลคลิก `Open-Reader.cmd` เพื่อตรวจว่าไฟล์ใหม่ขึ้นในรายการแล้ว
4. commit และ push:

```powershell
git status
git add Data library-data.js
git commit -m "Update study library data"
git push origin main
```

## ใช้กับเครื่องใหม่

ถ้ายังไม่มี repo ในเครื่อง ให้ clone ก่อน:

```powershell
git clone https://github.com/DyukeDook/T6sys.git
cd T6sys
```

ถ้ายังไม่เคย login GitHub ในเครื่องนั้น ให้ login ด้วยวิธีที่สะดวก เช่น GitHub Desktop, Git Credential Manager, หรือ GitHub CLI:

```powershell
gh auth login
```

หลังจากนั้นใช้ขั้นตอนในหัวข้อ "สรุปสั้นที่สุด" ได้เลย

## รายละเอียด Workflow

### 1. เพิ่มไฟล์บทเรียน

วางไฟล์ `.html` ลงใน:

```text
Data/
```

แนะนำให้ตั้งชื่อไฟล์เป็นภาษาอังกฤษ ตัวพิมพ์เล็ก และใช้ `_` แทนช่องว่าง เช่น:

```text
Data/t6c_new_system_courseware.html
```

### 2. อัปเดต `library-data.js`

รัน:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\Update-Reader.ps1
```

สคริปต์นี้จะอ่านไฟล์ `.html` ทั้งหมดใน `Data` แล้วสร้าง/อัปเดต `library-data.js` ให้หน้า `index.html` แสดงรายการค้นหาได้ครบ

### 3. ตรวจในหน้า Reader

เปิดด้วยวิธีใดวิธีหนึ่ง:

```powershell
.\Open-Reader.cmd
```

หรือเปิด `index.html` เองใน browser แล้วเช็กว่า:

- จำนวนไฟล์ถูกต้อง
- ชื่อบทเรียนใหม่ขึ้นในรายการ
- กดเปิดบทเรียนได้
- ค้นหาบทเรียนใหม่เจอ

### 4. Push ขึ้น GitHub

ใช้คำสั่ง:

```powershell
git status
git add Data library-data.js
git commit -m "Update study library data"
git push origin main
```

ถ้าแก้ `README.md`, `index.html`, หรือไฟล์อื่นด้วย ให้เพิ่มไฟล์เหล่านั้นเข้า commit ด้วย เช่น:

```powershell
git add Data library-data.js README.md index.html
```

## Checklist ก่อน Push

- ไฟล์ `.html` ใหม่อยู่ใน `Data`
- รัน `Update-Reader.ps1` แล้ว
- `library-data.js` เปลี่ยนตามข้อมูลล่าสุด
- เปิด `index.html` แล้วเห็นบทเรียนใหม่
- `git status` มีเฉพาะไฟล์ที่ตั้งใจอัปเดต

## Note สำหรับ Codex / AI

ถ้าผู้ใช้บอกว่า "เพิ่ม html เข้า Data แล้ว ช่วย push ขึ้น GitHub" ให้ทำตามนี้:

1. อ่านไฟล์นี้ก่อน
2. ตรวจไฟล์ใน `Data`
3. รัน `Update-Reader.ps1`
4. ตรวจว่า `library-data.js` ถูกสร้างใหม่
5. ใช้ workflow ปกติของ Git:

```powershell
git status
git add Data library-data.js
git commit -m "Update study library data"
git push origin main
```

ถ้าเครื่องไม่มี `git` แต่มี GitHub auth ให้ใช้ GitHub CLI หรือ GitHub connector เพื่อสร้าง commit บน `main` โดยอัปโหลดเฉพาะไฟล์ที่เพิ่ม/เปลี่ยน และ `library-data.js`

ห้าม push ไฟล์ชั่วคราว, log, cache, หรือไฟล์นอก scope ของโปรเจกต์
