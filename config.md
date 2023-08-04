# Config

> ## Upload ke Server
> 1. build ke web code `flutter build web` 
> 2. hasil compile ada di build/web 
> 3. buka filezilla masuk sftp
> 4. copy semua file dan folder yg ada di `build/web` ke `/var/www/balcom/html`
> 5. jika sudah, login ssh server (`ssh root@103.82.241.80 -p 8288`)
> 6. lalu restart nginx dengan code `systemctl restart nginx`