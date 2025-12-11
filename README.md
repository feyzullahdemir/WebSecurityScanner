# WebSecurityScanner
**WebSecurityScanner** is a comprehensive tool designed to check the security headers, SSL/TLS configurations, and open ports for a given web host. It can be used for penetration testing, vulnerability scanning, and general security assessments.

## Features
- **Header Scanner**: Checks if the necessary HTTP security headers (e.g., `Strict-Transport-Security`, `X-Content-Type-Options`, etc.) are present and properly configured.
- **SSL/TLS Checker**: Verifies the presence of an SSL certificate and checks the supported versions of TLS (1.2, 1.3, etc.).
- **Port Scanner**: Scans all open ports on a given domain or IP address and suggests closing unnecessary ports based on the environment (Internal/DMZ).
- **All-in-One Check**: Runs all of the above checks with a single command.

## Requirements
- **curl**: Used to make HTTP requests and check headers.
- **nmap**: Used for port scanning and SSL/TLS checks.
- **openssl**: Used to verify the SSL certificate.
- **bash**: The script is written in bash and intended to be run on Linux or macOS systems.

## Usage

### Installation:
1. Clone this repository:
    ```bash
    git clone https://github.com/feyzullahdemir/WebSecurityScanner.git 
    cd WebSecurityScanner
    ```

2. Make the script executable:
    ```bash
    chmod +x header_ssl_tls_port_scanner.sh
    ```

### Running the Tool:
1. Launch the tool by running:
    ```bash
    ./header_ssl_tls_port_scanner.sh
    ```

2. You will be presented with the following options:
    - **Header Scanner**: Check for the presence and correct configuration of essential HTTP headers.
    - **SSL/TLS Checker**: Check SSL certificate and supported TLS versions.
    - **Port Scanner**: Scan all open ports on a given domain or IP.
    - **Perform All Checks**: Run all of the above checks at once.

3. After performing the checks, the results will be displayed directly in your terminal.

## Example Output:
 ```bash
██████╗ ███████╗████████╗███████╗██╗     ██╗██████╗ ███████╗████████╗
██╔══██╗██╔════╝╚══██╔══╝██╔════╝██║     ██║██╔══██╗██╔════╝╚══██╔══╝
██████╔╝████╗     ██║   █████╗  ██║     ██║██║  ██║███████╗   ██║
██╔═══╝ ██╔══╝     ██║   ██╔══╝  ██║     ██║██║  ██║╚════██╗  ██║
██║     ███████╗   ██║   ███████╗██████╗ ██║██████╔╝███████╗   ██║
╚═╝     ╚══════╝   ╚═╝   ╚══════╝╚═════╝ ╚═╝╚═════╝ ╚══════╝   ╚═╝

---------------------------------------------------------------------------------
  Header, SSL/TLS & Port Scanner by Feyzullah Demir
---------------------------------------------------------------------------------
This tool allows you to perform header, SSL/TLS, and port scans on a specified host.
---------------------------------------------------------------------------------

Choose an option:
1) Header Scanner (Header Control)
2) SSL/TLS Checker (SSL/TLS Security Check)
3) Port Scanner (Port Scan)
4) Perform All Checks (Header, SSL/TLS, Port Scanner)
5) Exit
Select an option (1/2/3/4/5):

---------------------------------------------------------------------------------
Starting All Checks...
Enter domain or IP: testphp.vulnweb.com

Performing header scan...
✔ Strict-Transport-Security: Header mevcut.
❌ X-Content-Type-Options: Header eksik (Zafiyet var).
✔ X-Frame-Options: Header mevcut.
❌ X-XSS-Protection: Header eksik (Zafiyet var).
❌ Referrer-Policy: Header eksik (Zafiyet var).
❌ Permissions-Policy: Header eksik (Zafiyet var).
✔ Server: nginx
❌ X-Powered-By bilgisi bulunamadı.

Performing SSL/TLS check...
✔ SSL Sertifikası mevcut.
Cert Start: Jan 25 00:00:00 2025 GMT
Cert End:   Apr 25 23:59:59 2025 GMT
✔ TLS 1.2 desteği mevcut.
✔ TLS 1.3 desteği mevcut.

Performing port scan...
PORT      STATE  SERVICE
22/tcp    open   ssh
80/tcp    open   http
443/tcp   open   https

Security Summary:
--------------------------
Headers Missing   : 4
SSL Status        : Secure
TLS Versions      : OK (1.2, 1.3)
Open Ports        : 22, 80, 443
Risky Ports Found : 22 (DMZ önerilmez)
--------------------------

Returning to main menu...

 ```

