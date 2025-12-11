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
  Header, SSL/TLS, Zafiyet ve Port Scanner by Feyzullah Demir
---------------------------------------------------------------------------------
This tool allows you to perform header, SSL/TLS, vulnerability scans, and port scans.
---------------------------------------------------------------------------------

Choose an option:
1) Header Scanner (Header Control)
2) SSL/TLS Checker (SSL/TLS Security Check)
3) Port Scanner (Port Scan)
4) Perform All Checks (Header, SSL/TLS, Port Scanner)
5) Vulnerability Scanning (CVSS, OWASP Top 10)
6) Exit

Select an option (1/2/3/4/5/6): 5

Starting Vulnerability Scanning...
Enter domain or IP: www.example.com

✔ Reflected XSS vulnerability detected!
❌ No SQL Injection detected.
✔ CSRF vulnerability detected!
✔ Clickjacking vulnerability detected!
✔ Open Redirect vulnerability detected!

Scan Results:
------------------------------------
- Reflected XSS: ✔ Vulnerability Detected
- SQL Injection: ❌ No Vulnerability Detected
- CSRF: ✔ Vulnerability Detected
- Clickjacking: ✔ Vulnerability Detected
- Open Redirect: ✔ Vulnerability Detected
------------------------------------
CVSS Score:
- Reflected XSS: 7.5 (High)
- SQL Injection: N/A
- CSRF: 5.0 (Medium)
- Clickjacking: 4.0 (Medium)
- Open Redirect: 4.5 (Medium)

Risk Level: **High** (Multiple critical vulnerabilities detected)

Would you like to:
1) Go Back to Main Menu
2) Exit
Select option (1/2): 1

Choose an option:
1) Header Scanner (Header Control)
2) SSL/TLS Checker (SSL/TLS Security Check)
3) Port Scanner (Port Scan)
4) Perform All Checks (Header, SSL/TLS, Port Scanner)
5) Vulnerability Scanning (CVSS, OWASP Top 10)
6) Exit

Select an option (1/2/3/4/5/6): 3

Starting Port Scanner...
Enter domain or IP: www.example.com

Starting Nmap 7.98 ( https://nmap.org ) at 2025-12-11 15:00 +0300
Stats: 0:00:14 elapsed; 0 hosts completed (1 up), 1 undergoing SYN Stealth Scan
SYN Stealth Scan Timing: About 1.82% done; ETC: 15:01 (0:00:35 remaining)
Stats: 0:00:25 elapsed; 1 host completed (1 up), 1 undergoing SYN Stealth Scan

Scan Results:
------------------------------------
- Open Ports: 
  - 443/tcp (HTTPS)
  - 80/tcp (HTTP)
- Services:
  - Apache HTTPD 2.4.41
  - Nginx 1.14.2
------------------------------------
- Recommendations:
  - Close unused ports (e.g., HTTP on port 80)
  - Ensure all services are updated and configured securely.
------------------------------------

Would you like to:
1) Go Back to Main Menu
2) Exit
Select option (1/2): 1

Choose an option:
1) Header Scanner (Header Control)
2) SSL/TLS Checker (SSL/TLS Security Check)
3) Port Scanner (Port Scan)
4) Perform All Checks (Header, SSL/TLS, Port Scanner)
5) Vulnerability Scanning (CVSS, OWASP Top 10)
6) Exit

Select an option (1/2/3/4/5/6): 6
Exiting... Goodbye!



 ```

