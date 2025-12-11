#!/bin/bash

# Terminale giriş ekranını güzelleştirmek için renkli ASCII sanatı ve metinler
clear

# ASCII Art Header Scanner
echo -e "\033[1;32m"
echo "██████╗ ███████╗████████╗███████╗██╗     ██╗██████╗ ███████╗████████╗"
echo "██╔══██╗██╔════╝╚══██╔══╝██╔════╝██║     ██║██╔══██╗██╔════╝╚══██╔══╝"
echo "██████╔╝████╗     ██║   █████╗  ██║     ██║██║  ██║███████╗   ██║"
echo "██╔═══╝ ██╔══╝     ██║   ██╔══╝  ██║     ██║██║  ██║╚════██╗  ██║"
echo "██║     ███████╗   ██║   ███████╗██████╗ ██║██████╔╝███████╗   ██║"
echo "╚═╝     ╚══════╝   ╚═╝   ╚══════╝╚═════╝ ╚═╝╚═════╝ ╚══════╝   ╚═╝"
echo -e "\033[0m"

echo -e "\033[1;33m"
echo "---------------------------------------------------------------------------------"
echo "  Header, SSL/TLS & Port Scanner by Feyzullah Demir"
echo "---------------------------------------------------------------------------------"
echo "This tool allows you to perform header, SSL/TLS, and port scans on a specified host."
echo "---------------------------------------------------------------------------------"
echo -e "\033[0m"

echo -e "\033[1;36mStarting the scanner...\033[0m"

# Küçük bir gecikme ekleyerek görsel etkisi yaratabiliriz
sleep 1

# Menü başlatma
main_menu() {
  echo -e "\033[1;32m"
  echo "████████╗███████╗██╗     ███████╗██████╗ ███████╗████████╗███████╗"
  echo "╚══██╔══╝██╔════╝██║     ██╔════╝██╔══██╗██╔════╝╚══██╔══╝██╔════╝"
  echo "   ██║   █████╗  ██║     █████╗  ██║  ██║███████╗   ██║   █████╗  "
  echo "   ██║   ██╔══╝  ██║     ██╔══╝  ██║  ██║╚════██╗   ██║   ██╔══╝  "
  echo "   ██║   ███████╗██████╗ ███████╗██████╔╝███████╗   ██║   ███████╗"
  echo -e "\033[0m"
  
  echo -e "\033[1;33mChoose an option:\033[0m"
  echo "1) Header Scanner (Header Control)"
  echo "2) SSL/TLS Checker (SSL/TLS Security Check)"
  echo "3) Port Scanner (Port Scan)"
  echo "4) Perform All Checks (Header, SSL/TLS, Port Scanner)"
  echo "5) Exit"

  read -p "Select an option (1/2/3/4/5): " choice
  case $choice in
    1) header_scanner ;;
    2) ssl_tls_checker ;;
    3) port_scanner ;;
    4) all_checks ;;
    5) exit 0 ;;
    *) echo -e "\033[1;31mInvalid option. Please choose between 1, 2, 3, 4, or 5.\033[0m" && main_menu ;;
  esac
}

# Header kontrol fonksiyonu
header_scanner() {
  echo -e "\033[1;32mStarting Header Scanner...\033[0m"
  read -p "Enter domain or IP: " host
  host=$(echo $host | awk -F/ '{print $1}')  # URL'yi temizle, sadece domain ya da IP'yi al
  check_https_headers $host
}

# SSL/TLS kontrol fonksiyonu
ssl_tls_checker() {
  echo -e "\033[1;32mStarting SSL/TLS Security Check...\033[0m"
  read -p "Enter domain or IP: " host
  host=$(echo $host | awk -F/ '{print $1}')  # URL'yi temizle, sadece domain ya da IP'yi al
  ssl_cert_check $host
  tls_version_check $host
}

# SSL Sertifikası kontrol fonksiyonu
ssl_cert_check() {
  local host=$1
  echo -e "\033[1;32mChecking SSL certificate for $host...\033[0m"
  
  # OpenSSL ile SSL sertifikasını kontrol et
  cert=$(echo | openssl s_client -connect $host:443 -servername $host 2>/dev/null | openssl x509 -noout -dates)
  
  if [[ -z "$cert" ]]; then
    echo -e "\033[1;31m❌ SSL Sertifikası mevcut değil.\033[0m"
  else
    echo -e "\033[1;32m✔ SSL Sertifikası mevcut.\033[0m"
    echo -e "\033[1;34mCert Start Date: $(echo "$cert" | grep 'notBefore' | sed 's/notBefore=//')\033[0m"
    echo -e "\033[1;34mCert Expiry Date: $(echo "$cert" | grep 'notAfter' | sed 's/notAfter=//')\033[0m"
  fi
}

# TLS sürümünü kontrol etme fonksiyonu
tls_version_check() {
  local host=$1
  # TLS sürümünü kontrol etmek için nmap kullanıyoruz
  tls_check=$(nmap -p 443 --script ssl-enum-ciphers $1 2>/dev/null)
  if echo "$tls_check" | grep -q "TLSv1.2"; then
    echo -e "\033[1;32m✔ TLS 1.2 desteği mevcut.\033[0m"
  else
    echo -e "\033[1;31m❌ TLS 1.2 desteği yok.\033[0m"
  fi
  if echo "$tls_check" | grep -q "TLSv1.3"; then
    echo -e "\033[1;32m✔ TLS 1.3 desteği mevcut.\033[0m"
  else
    echo -e "\033[1;31m❌ TLS 1.3 desteği yok.\033[0m"
  fi
}

# Header kontrol fonksiyonu
check_https_headers() {
  local host=$1
  echo -e "\033[1;34mChecking headers for $host...\033[0m"

  # Header bilgilerini almak için curl komutu kullanıyoruz
  headers_response=$(curl -s -D - $host -o /dev/null)

  # Başlıkların varlığını kontrol et
  headers=("Strict-Transport-Security" "X-Content-Type-Options" "X-Frame-Options" "X-XSS-Protection" "Referrer-Policy" "Permissions-Policy")

  for header in "${headers[@]}"; do
    if echo "$headers_response" | grep -iq "$header"; then
      echo -e "✔ $header: Header mevcut."
    else
      echo -e "❌ $header: Header eksik (Zafiyet var)."
    fi
  done

  # Sunucu Bilgisi (Server)
  server_info=$(echo "$headers_response" | grep -i "Server:" | sed 's/Server: //')
  if [ -z "$server_info" ]; then
    echo -e "❌ Server bilgisi bulunamadı."
  else
    echo -e "✔ Server: $server_info"
  fi

  # Yazılım Bilgisi (X-Powered-By)
  powered_by=$(echo "$headers_response" | grep -i "X-Powered-By:" | sed 's/X-Powered-By: //')
  if [ -z "$powered_by" ]; then
    echo -e "❌ X-Powered-By bilgisi bulunamadı."
  else
    echo -e "✔ X-Powered-By: $powered_by"
  fi
}

# Port tarama fonksiyonu
port_scanner() {
  echo -e "\033[1;32mStarting Port Scanner...\033[0m"
  read -p "Enter domain or IP: " host
  host=$(echo $host | awk -F/ '{print $1}')  # URL'yi temizle, sadece domain ya da IP'yi al
  nmap -p- $host
}

# Tüm kontrolleri başlatma fonksiyonu
all_checks() {
  echo -e "\033[1;32mStarting All Checks...\033[0m"
  read -p "Enter domain or IP: " host
  host=$(echo $host | awk -F/ '{print $1}')  # URL'yi temizle, sadece domain ya da IP'yi al
  
  echo -e "\033[1;34mPerforming header scan...\033[0m"
  check_https_headers $host
  
  echo -e "\033[1;34mPerforming SSL/TLS check...\033[0m"
  ssl_cert_check $host
  tls_version_check $host
  
  echo -e "\033[1;34mPerforming port scan...\033[0m"
  port_scanner $host
}

# Menü başlatma
main_menu
