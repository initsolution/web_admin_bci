# Changelog
> 30/07/2023 (MIP)
> 1. Menambahkan Provider Employee (Create, Read, Update)
> 30/07/2023 
> 1. Login to Home

> 04/08/2023
> 1. Read all Employee
> 2. Add config

> 07/08/2023
> 1. add error 401 (unnauthorized)
> 2. create employee

> 14/08/2023
> 1. add jwt decoder
> 2. remove some settings

> 15/08/2023
> 1. experiment pdf

> 20/08/2023
> 1. add site, getall site

> 26/08/2023
> 1. master report reguler torque
> 2. master asset
> 3. master tenant
> 4. master category checklist preventive

> 29/08/2023
> 1. province and kabupaten on progress

> 30/08/2023
> 1. Master Poin Checklist Preventive
> 2. Add id (int) on master
> 3. Add Checkbox tenant on DialogAdd Site

> 02/09/2023
> 1. Add refresh after add
> 2. add @Queries in repo

> 01/11/2023
> 1. Verifikator change image and accept

> 10/11/2023
> 1. create date pada task yyyy-mm-dd
> 2. initstate pada setiap screen

> 03/11/2023
> 1. Add delete task

> 11/11/2023
> 1. add report preventive
> 2. add report reguler
> 3. search for verifikator by site name

> 13/11/2023
> 1. Modif tampilan tabel semua screen

> 20/11/2023
> 1. Update UI header, dan tabel 

> 15/11/2023
> 1. Generate PDF untuk verticality

> 13/11/2023
> 1. fiter site
> 2. filter asset
> 3. filter task

> 19/11/2023
> 1. update asset for pdf -> not solve

> 20/11/2023
> 1. 2 column pdf

> 22/11/2023
> 1. trial make 1 pdf

> 27/11/2023
> Add Search setiap Screen
> Login by role (SuperAdmin, Admin dan Verify)
> Block Maker supaya tidak bisa login di Web 
> Remove unused import

> 28/11/2023
> update ui/ux verificator

> 28/11/2023 (mip)
> 1. Update all master
> 2. Delete all master (jangan lupa drop dulu tabel master category dan tabel point category)

> 30/11/2023 (mip)
> 1. optimasi employee(update and filter)

> 30/11/2023
> update ui/ux verificator : add checklist, torque, verticality report

> 01/12/2023
> Add Validasi form Add and form Edit 
> 30/11/2023 (deddy)
> update ui/ux verificator : add checklist, torque, verticality report

> 01/12/2023
> ganti dashboard menjadi total task

> 01/12/2023 (deddy)
> update dialog and screen ui/ux
> update point checklist menambahkan sub category berdasarkan isChecklist
> koreksi label Apakah dalam bentuk Checklist?

> 02/12/2023 (mip)
> solve dashboard by verifikator
> add ProgressiveImage in dialog choose
> ganti placeholder 

> 03/12/2023 (mip)
> mengganti progresive image saat melihat asset dan ganti gambar. Untuk ganti gambar masih belum mau ke load gambar nya
> login admin bisa master
> solving gambar belum ke load ketika ganti gambar

> 04/12/2023 (mip)
> Task menambahkan due date dan created_at

> 05/12/2023 (deddy)
> add due date
> add site of task : menambahkan task berdasarkan site
> menambahkan fitur pencarian di task screen

> 06/12/2023 (mip)
> pencarian task ditambahkan bedasarkan maker dan verifikator
> menambahkan due date di result asset
> menambahkan filter pencarian site Type or Fabricator
> optimize filter search dan on submit semua screen

> 07/12/2023 (mip)
> menambahkan obscure text di password ketika edit dan tambah employee

> 14/12/2023 (mip)
> menambahkan bearer untuk authorized
> menambahkan exception jika belum upload e-sign

> 23/12/2023 (mip)
> membuat filter not before
> icon untuk web

> 28/12/2023 (Yossi)
> add reset password
> edit task (if datenow < not before )
> change reset password message
> (mip)
> add change image from local

> 29/12/2023
> change task verified to accepted

> 02/01/2024
> add constant variable

> 05/01/2024 (deddy)
> ui/ux replace, reupload, show detail asset

> 06/01/2024
> add note task for verifikator
> solving bug saat get token in portalmasterlayout
> solving bug statusTask

> 09/01/2024 (deddy)
> scroll table and layout table

> 11/01/2024 (mip)
> edit employee not show superadmin

> 16/01/2024 (ong)
> hide button Detail saat status task todo, expired, dan rejected
> ganti icon rumah sakit 

> 17/01/2024 (mip)
> employee change e sign save memory image
> solve bug if note null

> 17/01/2024 (dedddy)
> change esign container dialog profile

> 22/01/2024
> Add PJU option in Site
> Add Site ID, Region coloum in Task
> Searching Task by Region, Site ID
> Searching Site by Region, Site ID
> Bug Update Site

> 23/01/2024 (mip)
> edit verifikator
> search site id in verifikator

> 25/01/2024((yossi & mip))
> Tambah fungsi Edit Tenant
> solve bug result asset (add note)

> 01/02/2024(mip)
> solve bug employee

> 01/02/2024 (yossi, deddy)
> Tenant Boleh Kosong
> solve icon button splash radius
> responsive action menu

> 04/03/2024 (mip)
> solve filter search task
> solve width task id

> 16/03/2024 (mip)
> change created at to submit date in result screen
> solve detail image, asset name not show

> 01/04/2024 (mip)
> change server backend to live

> 30/04/2024 (mip)
> fix bug change image from local
> change status rejected to accepted

> 04/06/2024 (mip)
> add task id on task screen
> add versions