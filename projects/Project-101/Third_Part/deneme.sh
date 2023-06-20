#!/bin/bash

# Root yetkisiyle çalıştığımızı kontrol edelim
if [[ $EUID -ne 0 ]]; then
  echo "Bu betik root yetkisiyle çalıştırılmalıdır." >&2
  exit 1
fi

# Yedekleme dizinini tanımlayalım
yedek_dizini="/mnt/backup"

# Yedeklenmesi gereken dizinleri tanımlayalım
dizinler=("/home/ec2-user/data" "/etc" "/boot" "/usr")

# Sunucunun adını alalım
sunucu_adi=$(hostname)

# Geçerli tarih ve saat bilgisini alalım
tarih_saat=$(date +%Y-%m-%d-%H-%M)

# Başlangıç durumu mesajını yazdıralım
echo "Yedekleme başlatılıyor..."

# Yedekleme dizinini oluşturalım (varsa zaten oluşturulmasına gerek yok)
mkdir -p "$yedek_dizini"

# Yedeklenecek dizinleri döngü ile yedekleyelim
for dizin in "${dizinler[@]}"; do
  # Yedek dosya adını oluşturalım
  yedek_dosya_adi="${yedek_dizini}/${sunucu_adi}-${tarih_saat}-$(basename "$dizin").tgz"

  # tar ve gzip kullanarak yedekleme oluşturalım
  tar -czf "$yedek_dosya_adi" "$dizin"
  
  # Yedek dosya adını yazdıralım
  echo "Yedek oluşturuldu: $yedek_dosya_adi"
done

# Bitiş durumu mesajını yazdıralım
echo "Yedekleme tamamlandı."
