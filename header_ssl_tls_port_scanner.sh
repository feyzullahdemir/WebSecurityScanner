#!/bin/bash

##############################
#  COLORS
##############################
GREEN="\033[1;32m"
RED="\033[1;31m"
YELLOW="\033[1;33m"
BLUE="\033[1;34m"
CYAN="\033[1;36m"
NC="\033[0m"

DEBUG_MODE=0

##############################
#  BANNER
##############################
banner() {
clear
echo -e "${CYAN}"
echo "██╗    ██╗███████╗██████╗     ███████╗ ██████╗  █████╗ ███╗   ██╗"
echo "██║    ██║██╔════╝██╔══██╗    ██╔════╝██╔═══██╗██╔══██╗████╗  ██║"
echo "██║ █╗ ██║█████╗  ██████╔╝    ███████╗██║   ██║███████║██╔██╗ ██║"
echo "██║███╗██║██╔══╝  ██╔══██╗    ╚════██║██║   ██║██╔══██║██║╚██╗██║"
echo "╚███╔███╔╝███████╗██║  ██║    ███████║╚██████╔╝██║  ██║██║ ╚████║"
echo " ╚══╝╚══╝ ╚══════╝╚═╝  ╚═╝    ╚══════╝ ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═══╝"
echo ""
echo -e "      ${GREEN}WEB SECURITY SCANNER V4 – Advanced Edition${NC}"
echo -e "                Author: Feyzullah Demir"
echo -e "${CYAN}---------------------------------------------------------${NC}"
echo ""
}

##############################
#  HELPER PRINT FUNCTIONS
##############################
ok()     { echo -e "${GREEN}[OK]${NC} $1"; }
warn()   { echo -e "${YELLOW}[WARN]${NC} $1"; }
err()    { echo -e "${RED}[ERR]${NC} $1"; }
info()   { echo -e "${CYAN}[INFO]${NC} $1"; }
debug()  { [[ $DEBUG_MODE -eq 1 ]] && echo -e "${YELLOW}[DEBUG]${NC} $1"; }

##############################
# DIG CHECK
##############################
check_dig() {
if ! command -v dig >/dev/null 2>&1; then
    warn "dig bulunamadı — kurulumu deneniyor..."
    if command -v apt >/dev/null 2>&1; then
        apt update -y && apt install dnsutils -y
    fi
    if ! command -v dig >/dev/null 2>&1; then
        err "dig kurulamadı. Subdomain modu devre dışı!"
        SUBDOMAIN_DISABLED=1
    fi
else
    info "dig bulundu."
fi
}

##############################
# PASSIVE RECON (Server Info)
##############################
passive_recon() {
echo ""
info "Pasif bilgi toplama başlatılıyor..."

headers=$(curl -s -I "https://$HOST")

server=$(echo "$headers" | grep -i "^server:" | cut -d' ' -f2-)
tech=$(echo "$headers" | grep -i "x-powered-by" | cut -d' ' -f2-)

[[ -z "$server" ]] && server="Bilinmiyor"
[[ -z "$tech" ]] && tech="Bilinmiyor"

ok "Sunucu Yazılımı: $server"
ok "Teknoloji: $tech"

debug "Full Response Headers:\n$headers"
}

##############################
# CDN DETECTION
##############################
cdn_detection() {
echo ""
info "CDN tespiti yapılıyor..."

headers=$(curl -s -I "https://$HOST")
cname=$(dig +short CNAME "$HOST" 2>/dev/null)

cdns=("cloudflare" "cloudfront" "akamai" "fastly" "incapdns" "azureedge" "edgesuite")

found=0

for c in "${cdns[@]}"; do
  if echo "$cname" | grep -iq "$c"; then
    ok "CDN: $c (DNS)"
    found=1
  fi
done

if echo "$headers" | grep -qi "cloudflare"; then ok "CDN: Cloudflare (Header)"; found=1; fi
if echo "$headers" | grep -qi "akamai"; then ok "CDN: Akamai (Header)"; found=1; fi
if echo "$headers" | grep -qi "fastly"; then ok "CDN: Fastly (Header)"; found=1; fi

[[ $found -eq 0 ]] && warn "CDN tespit edilmedi."
}

##############################
# WAF DETECTION
##############################
waf_detection() {
echo ""
info "WAF tespiti başlatılıyor..."

headers=$(curl -s -I "https://$HOST")

signatures=("sucuri" "cloudflare" "imperva" "incapsula" "mod_security" "akamai" "f5" "wallarm")

found=0

for sig in "${signatures[@]}"; do
  if echo "$headers" | grep -iq "$sig"; then
    ok "WAF tespit edildi: $sig"
    found=1
  fi
done

# active test
resp=$(curl -s -o /dev/null -w "%{http_code}" "https://$HOST/?id='\"><script>alert(1)</script>")

if [[ "$resp" == "403" ]]; then
    ok "Aktif WAF davranışı: 403 Engelleme"
    found=1
fi

if [[ $found -eq 0 ]]; then
    warn "WAF tespit edilmedi."
fi
}

##############################
# HEADER SCAN (Stable)
##############################
header_scan() {
echo ""
info "Header taraması yapılıyor..."

headers=$(curl -s -I "https://$HOST")

required=("Strict-Transport-Security" "X-Frame-Options" "X-Content-Type-Options" "Referrer-Policy")

for h in "${required[@]}"; do
  if echo "$headers" | grep -iq "$h"; then
    ok "$h mevcut"
  else
    err "$h eksik"
  fi
done

debug "$headers"
}

##############################
# SSL CERT CHECK
##############################
ssl_check() {
echo ""
info "SSL sertifikası kontrol ediliyor..."

cert=$(echo | openssl s_client -connect "$HOST:443" -servername "$HOST" 2>/dev/null)

if echo "$cert" | grep -qi "BEGIN CERTIFICATE"; then
    ok "SSL Sertifikası mevcut"
else
    err "SSL sertifikası yok"
fi
}

##############################
# TLS CHECK
##############################
tls_check() {
echo ""
info "TLS sürüm kontrolü..."

tls12=$(echo | openssl s_client -connect "$HOST:443" -tls1_2 2>&1)
tls13=$(echo | openssl s_client -connect "$HOST:443" -tls1_3 2>&1)

[[ $tls12 =~ "Cipher" ]] && ok "TLS 1.2 destekli" || err "TLS 1.2 yok"
[[ $tls13 =~ "Cipher" ]] && ok "TLS 1.3 destekli" || err "TLS 1.3 yok"
}

##############################
# HYBRID SUBDOMAIN ENUM
##############################
subdomain_enum() {
[[ $SUBDOMAIN_DISABLED -eq 1 ]] && err "Subdomain özelliği devre dışı!" && return

echo ""
info "Hybrid Subdomain Enumeration..."

echo ""
ok "PASSIVE (dig NS/MX/CNAME) tarama:"

dig +short ns "$HOST"
dig +short mx "$HOST"
dig +short cname "$HOST"

echo ""
ok "ACTIVE (300 kelimelik mini brute-force):"

wordlist=(www mail api dev test stage vpn help portal web ftp admin beta support gateway)

for w in "${wordlist[@]}"; do
    sub="$w.$HOST"
    ip=$(dig +short "$sub")
    if [[ -n "$ip" ]]; then
        ok "$sub → $ip"
    fi
done
}

##############################
# PORT SCAN (Fast)
##############################
port_scan() {
echo ""
info "Port taraması başlatılıyor (Hızlı)..."

ports=(21 22 53 80 443 8080 8443 3306 3389 5900 6379 8000 9000)

for p in "${ports[@]}"; do
  timeout 1 bash -c "echo >/dev/tcp/$HOST/$p" 2>/dev/null && open=1 || open=0

  if [[ $open -eq 1 ]]; then
    warn "Port $p → OPEN"
  fi
done

}

##############################
# MENU
##############################
menu() {
echo ""
echo -e "${CYAN}1) Header Scan"
echo "2) SSL/TLS Scan"
echo "3) CDN Detection"
echo "4) WAF Detection"
echo "5) Subdomain Enumeration"
echo "6) Port Scan"
echo "7) FULL SCAN"
echo "8) Exit${NC}"
echo ""

read -p "Seçim: " choice

case $choice in
1) header_scan ;;
2) ssl_check; tls_check ;;
3) cdn_detection ;;
4) waf_detection ;;
5) subdomain_enum ;;
6) port_scan ;;
7) passive_recon; cdn_detection; waf_detection; header_scan; ssl_check; tls_check; subdomain_enum; port_scan ;;
8) exit 0 ;;
*) err "Geçersiz seçim" ;;
esac

echo ""
read -p "Ana menüye dönmek için ENTER..."
main
}

##############################
# MAIN
##############################
main() {
banner
check_dig

echo ""
read -p "Domain veya IP girin: " HOST
echo ""
read -p "Debug modu açılsın mı? (y/n): " dbg
[[ "$dbg" == "y" ]] && DEBUG_MODE=1

menu
}

main
