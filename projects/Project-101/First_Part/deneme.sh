#!/bin/bash

# Cloudtrail event history dosyası
event_history="event_history.csv"

# Sonuç dosyası
result_file="result.txt"

# Serdar tarafından sonlandırılan örneklerin kimliklerini saklamak için bir dizi tanımlayalım
terminated_instances=()

# Event geçmişi dosyasını satır satır okuyalım
while IFS= read -r line; do
    # Satırı virgülle ayrılmış alanlara bölme
    IFS=',' read -ra fields <<< "$line"
    
    # Serdar tarafından gerçekleştirilen bir işlem mi kontrol edelim
    if [[ "${fields[0]}" == "serdar" ]]; then
        # Eylemin örnek silme işlemi olduğunu kontrol edelim
        if [[ "${fields[3]}" == "TerminateInstances" ]]; then
            # Örneğin kimliğini elde etmek için satırı analiz edelim
            instance_id=$(echo "${fields[8]}" | grep -oP '(?<=resourceName"":""i-)[^""]+')
            
            # Örnek kimliğini terminated_instances dizisine ekleyelim
            terminated_instances+=("$instance_id")
        fi
    fi
done < "$event_history"

# Terminated instances'ları result.txt dosyasına yazdıralım
printf "%s\n" "${terminated_instances[@]}" > "$result_file"

# Başarı mesajı
echo "Terminated instances'lar $result_file dosyasına kaydedildi."

