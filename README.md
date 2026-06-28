Link Open = https://dyukedook.github.io/T6sys/

# T6Sys / T6Emer / Airwork / 11-248 Trick Study Library

หน้านี้ใช้รวมไฟล์บทเรียน `.html` และแยกเป็น 4 หมวดใหญ่:

- `T6Sys` อ่านไฟล์จากโฟลเดอร์ `Data`
- `T6Emer` อ่านไฟล์จากโฟลเดอร์ `DataEmer`
- `Airwork` อ่านไฟล์จากโฟลเดอร์ `Airwork`
- `11-248 Trick` อ่านไฟล์จากโฟลเดอร์ `11-248 trick`

## วิธีเปิดอ่าน

ดับเบิลคลิก `Open-Reader.cmd`

คำสั่งนี้จะรัน `Update-Reader.ps1` เพื่ออัปเดตรายการไฟล์จาก `Data`, `DataEmer`, `Airwork` และ `11-248 trick` แล้วเปิด `index.html`

## วิธีเพิ่มไฟล์ใหม่

1. วางไฟล์ `.html` ระบบทั่วไปลงใน `Data`
2. วางไฟล์ `.html` emergency/abnormal ลงใน `DataEmer`
3. วางไฟล์ `.html` บทเรียนการบินลงใน `Airwork`
4. วางไฟล์ `.html` 11-248 trick ลงใน `11-248 trick`
5. ดับเบิลคลิก `Open-Reader.cmd`
6. หน้า reader จะอัปเดตจำนวนไฟล์ หมวด และรายการค้นหาให้อัตโนมัติ

ถ้าต้องการอัปเดตรายการอย่างเดียว ให้รัน:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\Update-Reader.ps1
```

## วิธี push ขึ้น GitHub

```powershell
git status
git add Data DataEmer Airwork "11-248 trick" library-data.js index.html Update-Reader.ps1 README.md
git commit -m "Update study library"
git push origin main
```
