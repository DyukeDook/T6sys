Link Open = https://dyukedook.github.io/T6sys/

# T6Sys / T6Emer Study Library

หน้านี้ใช้รวมไฟล์บทเรียน `.html` และแยกเป็น 2 หมวดใหญ่:

- `T6Sys` อ่านไฟล์จากโฟลเดอร์ `Data`
- `T6Emer` อ่านไฟล์จากโฟลเดอร์ `DataEmer`

## วิธีเปิดอ่าน

ดับเบิลคลิก `Open-Reader.cmd`

คำสั่งนี้จะรัน `Update-Reader.ps1` เพื่ออัปเดตรายการไฟล์จากทั้ง `Data` และ `DataEmer` แล้วเปิด `index.html`

## วิธีเพิ่มไฟล์ใหม่

1. วางไฟล์ `.html` ระบบทั่วไปลงใน `Data`
2. วางไฟล์ `.html` emergency/abnormal ลงใน `DataEmer`
3. ดับเบิลคลิก `Open-Reader.cmd`
4. หน้า reader จะอัปเดตจำนวนไฟล์ หมวด และรายการค้นหาให้อัตโนมัติ

ถ้าต้องการอัปเดตรายการอย่างเดียว ให้รัน:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\Update-Reader.ps1
```

## วิธี push ขึ้น GitHub

```powershell
git status
git add Data DataEmer library-data.js index.html Update-Reader.ps1 README.md
git commit -m "Update study library"
git push origin main
```
