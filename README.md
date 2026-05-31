# T6sys

ศูนย์รวมสรุประบบ T-6C แบบ Static HTML สำหรับรวมหน้า HTML หลาย ๆ หน้าไว้ในเว็บเดียว

## โครงสร้างไฟล์

```text
T6sys/
├─ index.html
├─ data/
│  └─ pages.json
├─ pages/
│  └─ t6c_gear_indicators_summary.html
└─ .nojekyll
```

## หน้าแรกที่ใส่แล้ว

- `pages/t6c_gear_indicators_summary.html` — T-6C Landing Gear Indicators & Gear Handle Light

## วิธีเพิ่มหน้า HTML ใหม่

1. วางไฟล์ HTML ใหม่ไว้ในโฟลเดอร์ `pages/`
2. เปิด `data/pages.json`
3. เพิ่ม object ใหม่ เช่น

```json
{
  "title": "T-6C Electrical System Summary",
  "description": "สรุประบบไฟฟ้า T-6C",
  "path": "pages/t6c_electrical_system_summary.html",
  "category": "Electrical",
  "status": "Ready",
  "updated": "2026-05-31",
  "tags": ["Electrical", "Bus", "Generator"]
}
```

4. เปิด `index.html` จะเห็นการ์ดหน้าใหม่อัตโนมัติ

## วิธี Deploy ด้วย GitHub Pages

1. เข้า repository `DyukeDook/T6sys`
2. อัปโหลดไฟล์ทั้งหมดใน ZIP นี้ขึ้น branch `main`
3. ไปที่ **Settings → Pages**
4. เลือก **Deploy from a branch**
5. Branch: `main`, Folder: `/root`
6. กด Save

> Study aid only. เวลาบินจริงให้ยึด official T-6C manual/checklist/PCL, SOP และ instructor guidance เป็นหลัก
