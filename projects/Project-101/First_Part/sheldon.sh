#!/bin/bash

# CloudTrail etkinlik geçmişi dosyası
event_history_file="event_history.csv"

# Sonuçları kaydetmek için dosya
result_file="result.txt"

# Kullanıcı adı
username="Serdar"

# Örnek kimliklerini bulmak için grep komutu kullanarak kullanıcı adını ara
instance_ids=$(grep "$username" "$event_history_file" | awk -F ',"' '{print $6}' | awk -F '"' '{print $1}'|uniq > result.txt)

# Sonuçları result.txt dosyasına kaydet
echo "$instance_ids"

echo "Instances terminated by $username: "
cat "$result_file"

