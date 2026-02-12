#!/bin/bash

# اسکریپت نصب پکیج‌ها و برنامه‌های مورد نیاز در اوبونتو
# مناسب برای اوبونتو 20.04 و 22.04 و 24.04

# رنگ‌ها برای نمایش بهتر
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# تابع نمایش هدر
show_header() {
    clear
    echo -e "${CYAN}========================================${NC}"
    echo -e "${GREEN}    نصب پکیج‌ها و برنامه‌های مورد نیاز    ${NC}"
    echo -e "${CYAN}========================================${NC}"
    echo ""
}

# تابع بررسی خطا
check_error() {
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ موفقیت آمیز${NC}"
    else
        echo -e "${RED}✗ خطا در اجرا${NC}"
    fi
}

# تابع بررسی سیستم عامل
check_os() {
    echo -e "${YELLOW}بررسی سیستم عامل...${NC}"
    
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        OS=$NAME
        VER=$VERSION_ID
    else
        echo -e "${RED}سیستم عامل شناسایی نشد${NC}"
        exit 1
    fi
    
    echo -e "${GREEN}✓ سیستم عامل: $OS $VER${NC}"
    
    # بررسی اوبونتو بودن
    if [[ "$OS" != *"Ubuntu"* ]]; then
        echo -e "${RED}این اسکریپت فقط برای اوبونتو طراحی شده است${NC}"
        exit 1
    fi
}

# تابع به‌روزرسانی سیستم
update_system() {
    echo -e "${YELLOW}به‌روزرسانی سیستم...${NC}"
    sudo apt update
    check_error
    sudo apt upgrade -y
    check_error
}

# تابع نصب پکیج‌های پایه
install_basic_packages() {
    echo -e "${YELLOW}نصب پکیج‌های پایه...${NC}"
    
    BASIC_PACKAGES=(
        "curl"
        "wget"
        "git"
        "nano"
        "vim"
        "htop"
        "net-tools"
        "unzip"
        "zip"
        "software-properties-common"
        "apt-transport-https"
        "ca-certificates"
        "gnupg"
        "lsb-release"
        "build-essential"
        "make"
        "cmake"
        "pkg-config"
    )
    
    for package in "${BASIC_PACKAGES[@]}"; do
        echo -e "${BLUE}نصب $package...${NC}"
        sudo apt install -y $package
    done
    
    check_error
}

# تابع نصب ابزارهای شبکه و امنیت
install_network_tools() {
    echo -e "${YELLOW}نصب ابزارهای شبکه و امنیت...${NC}"
    
    NETWORK_PACKAGES=(
        "ufw"
        "iptables"
        "netfilter-persistent"
        "libpcap-dev"
        "nmap"
        "tcpdump"
        "wireshark-common"
        "openvpn"
        "network-manager"
        "dnsutils"
        "telnet"
        "traceroute"
        "whois"
        "nethogs"
        "iftop"
        "iperf3"
        "speedtest-cli"
    )
    
    for package in "${NETWORK_PACKAGES[@]}"; do
        echo -e "${BLUE}نصب $package...${NC}"
        sudo apt install -y $package
    done
    
    # نصب خودکار Wireshark بدون نیاز به تایید
    echo "wireshark-common wireshark-common/install-setuid boolean true" | sudo debconf-set-selections
    
    check_error
}

# تابع نصب ابزارهای توسعه و برنامه‌نویسی
install_dev_tools() {
    echo -e "${YELLOW}نصب ابزارهای توسعه و برنامه‌نویسی...${NC}"
    
    DEV_PACKAGES=(
        "python3"
        "python3-pip"
        "python3-venv"
        "python3-dev"
        "nodejs"
        "npm"
        "golang-go"
        "default-jdk"
        "default-jre"
        "gcc"
        "g++"
        "rustc"
        "cargo"
        "ruby"
        "ruby-dev"
        "php"
        "php-cli"
        "php-curl"
        "php-mbstring"
        "php-xml"
        "perl"
        "perl-modules"
        "sqlite3"
        "sqlitebrowser"
        "postgresql"
        "postgresql-contrib"
        "mysql-server"
        "mysql-client"
        "redis-server"
        "mongodb"
    )
    
    for package in "${DEV_PACKAGES[@]}"; do
        echo -e "${BLUE}نصب $package...${NC}"
        sudo apt install -y $package 2>/dev/null || echo -e "${RED}خطا در نصب $package${NC}"
    done
    
    check_error
}

# تابع نصب Docker
install_docker() {
    echo -e "${YELLOW}نصب Docker...${NC}"
    
    # حذف نسخه‌های قدیمی
    sudo apt remove -y docker docker-engine docker.io containerd runc 2>/dev/null
    
    # نصب پیش‌نیازها
    sudo apt update
    sudo apt install -y ca-certificates curl gnupg lsb-release
    
    # اضافه کردن کلید GPG
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    
    # اضافه کردن ریپازیتوری
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    
    # نصب Docker
    sudo apt update
    sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin docker-compose
    
    # اضافه کردن کاربر به گروه docker
    sudo usermod -aG docker $USER
    
    # فعال کردن سرویس
    sudo systemctl enable docker
    sudo systemctl start docker
    
    check_error
}

# تابع نصب ابزارهای مانیتورینگ
install_monitoring_tools() {
    echo -e "${YELLOW}نصب ابزارهای مانیتورینگ...${NC}"
    
    MONITORING_PACKAGES=(
        "glances"
        "nmon"
        "iotop"
        "iostat"
        "sysstat"
        "lm-sensors"
        "acpi"
        "cpufrequtils"
        "stress"
        "stress-ng"
        "hardinfo"
        "neofetch"
        "screenfetch"
        "bashtop"
        "bpytop"
    )
    
    for package in "${MONITORING_PACKAGES[@]}"; do
        echo -e "${BLUE}نصب $package...${NC}"
        sudo apt install -y $package 2>/dev/null || echo -e "${RED}خطا در نصب $package${NC}"
    done
    
    # نصب gotop با استفاده از گو
    if command -v go &> /dev/null; then
        go install github.com/xxxserxxx/gotop/v4/cmd/gotop@latest
        sudo cp ~/go/bin/gotop /usr/local/bin/
    fi
    
    check_error
}

# تابع نصب ابزارهای مدیریت فایل و آرشیو
install_file_tools() {
    echo -e "${YELLOW}نصب ابزارهای مدیریت فایل...${NC}"
    
    FILE_PACKAGES=(
        "ranger"
        "mc"
        "tree"
        "rsync"
        "ncdu"
        "duf"
        "fzf"
        "ripgrep"
        "fd-find"
        "bat"
        "exa"
        "tldr"
        "jq"
        "yq"
        "tmux"
        "screen"
        "tar"
        "gzip"
        "bzip2"
        "xz-utils"
        "p7zip-full"
        "p7zip-rar"
        "unrar"
    )
    
    for package in "${FILE_PACKAGES[@]}"; do
        echo -e "${BLUE}نصب $package...${NC}"
        sudo apt install -y $package
    done
    
    check_error
}

# تابع نصب مرورگرها و برنامه‌های گرافیکی
install_gui_apps() {
    echo -e "${YELLOW}نصب برنامه‌های گرافیکی...${NC}"
    
    GUI_PACKAGES=(
        "firefox"
        "chromium-browser"
        "keepassxc"
        "gimp"
        "inkscape"
        "vlc"
        "mpv"
        "gparted"
        "gnome-tweaks"
        "gnome-shell-extensions"
        "guake"
        "tilix"
        "visual-studio-code"
    )
    
    # نصب VS Code
    if ! command -v code &> /dev/null; then
        wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
        sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
        sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
        rm -f packages.microsoft.gpg
        sudo apt update
    fi
    
    for package in "${GUI_PACKAGES[@]}"; do
        echo -e "${BLUE}نصب $package...${NC}"
        sudo apt install -y $package 2>/dev/null || echo -e "${RED}خطا در نصب $package${NC}"
    done
    
    check_error
}

# تابع نصب ابزارهای امنیتی
install_security_tools() {
    echo -e "${YELLOW}نصب ابزارهای امنیتی...${NC}"
    
    SECURITY_PACKAGES=(
        "clamav"
        "clamav-daemon"
        "rkhunter"
        "chkrootkit"
        "lynis"
        "fail2ban"
        "aide"
        "tripwire"
        "apparmor"
        "apparmor-profiles"
        "auditd"
        "openssl"
    )
    
    for package in "${SECURITY_PACKAGES[@]}"; do
        echo -e "${BLUE}نصب $package...${NC}"
        sudo apt install -y $package
    done
    
    # به‌روزرسانی ClamAV
    sudo freshclam
    
    check_error
}

# تابع نصب دیتابیس‌ها
install_databases() {
    echo -e "${YELLOW}نصب دیتابیس‌ها...${NC}"
    
    DB_PACKAGES=(
        "mariadb-server"
        "mariadb-client"
        "mongodb-org"
        "couchdb"
        "elasticsearch"
        "influxdb"
        "sqlite3"
        "sqlitebrowser"
        "adminer"
    )
    
    for package in "${DB_PACKAGES[@]}"; do
        echo -e "${BLUE}نصب $package...${NC}"
        sudo apt install -y $package 2>/dev/null || echo -e "${RED}خطا در نصب $package${NC}"
    done
    
    check_error
}

# تابع نصب ابزارهای کلاد و کانتینر
install_cloud_tools() {
    echo -e "${YELLOW}نصب ابزارهای کلاد و کانتینر...${NC}"
    
    CLOUD_PACKAGES=(
        "kubectl"
        "helm"
        "awscli"
        "azure-cli"
        "google-cloud-sdk"
        "terraform"
        "ansible"
        "packer"
        "vagrant"
        "virtualbox"
    )
    
    # نصب kubectl
    if ! command -v kubectl &> /dev/null; then
        curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
        sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
        rm kubectl
    fi
    
    # نصب Helm
    if ! command -v helm &> /dev/null; then
        curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
        chmod 700 get_helm.sh
        ./get_helm.sh
        rm get_helm.sh
    fi
    
    for package in "${CLOUD_PACKAGES[@]}"; do
        echo -e "${BLUE}نصب $package...${NC}"
        sudo apt install -y $package 2>/dev/null || echo -e "${RED}خطا در نصب $package${NC}"
    done
    
    check_error
}

# تابع نصب ابزارهای ارتباطی
install_communication_tools() {
    echo -e "${YELLOW}نصب ابزارهای ارتباطی...${NC}"
    
    # نصب Discord
    if ! command -v discord &> /dev/null; then
        wget -O discord.deb "https://discord.com/api/download?platform=linux&format=deb"
        sudo dpkg -i discord.deb
        sudo apt install -f -y
        rm discord.deb
    fi
    
    # نصب Slack
    if ! command -v slack &> /dev/null; then
        wget -O slack.deb "https://downloads.slack-edge.com/releases/linux/4.33.90/prod/x64/slack-desktop-4.33.90-amd64.deb"
        sudo dpkg -i slack.deb
        sudo apt install -f -y
        rm slack.deb
    fi
    
    # نصب Telegram
    sudo snap install telegram-desktop 2>/dev/null || sudo apt install -y telegram-desktop
    
    check_error
}

# تابع نصب ابزارهای صوتی و تصویری
install_media_tools() {
    echo -e "${YELLOW}نصب ابزارهای صوتی و تصویری...${NC}"
    
    MEDIA_PACKAGES=(
        "audacity"
        "kdenlive"
        "obs-studio"
        "simplescreenrecorder"
        "flameshot"
        "shutter"
        "kazam"
        "rhythmbox"
        "clementine"
        "spotify-client"
    )
    
    # نصب Spotify
    if ! command -v spotify &> /dev/null; then
        curl -sS https://download.spotify.com/debian/pubkey_6224F9941A8AA6D1.gpg | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
        echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
        sudo apt update
    fi
    
    for package in "${MEDIA_PACKAGES[@]}"; do
        echo -e "${BLUE}نصب $package...${NC}"
        sudo apt install -y $package 2>/dev/null || echo -e "${RED}خطا در نصب $package${NC}"
    done
    
    check_error
}

# تابع نصب فونت‌ها
install_fonts() {
    echo -e "${YELLOW}نصب فونت‌ها...${NC}"
    
    FONT_PACKAGES=(
        "fonts-fira-code"
        "fonts-jetbrains-mono"
        "fonts-roboto"
        "fonts-ubuntu"
        "fonts-awesome"
        "fonts-font-awesome"
        "fonts-noto"
        "fonts-noto-cjk"
        "fonts-liberation"
        "fonts-dejavu"
    )
    
    for package in "${FONT_PACKAGES[@]}"; do
        echo -e "${BLUE}نصب $package...${NC}"
        sudo apt install -y $package
    done
    
    # نصب فونت Vazir
    if [ ! -d ~/.local/share/fonts/Vazir ]; then
        wget -O vazir.zip https://github.com/rastikerdar/vazir-font/releases/download/v30.1.0/vazir-font-v30.1.0.zip
        mkdir -p ~/.local/share/fonts/Vazir
        unzip -o vazir.zip -d ~/.local/share/fonts/Vazir/
        rm vazir.zip
        fc-cache -fv
    fi
    
    check_error
}

# تابع تنظیمات نهایی
final_setup() {
    echo -e "${YELLOW}تنظیمات نهایی...${NC}"
    
    # ایجاد لینک‌های سمبلیک برای ابزارها
    if command -v batcat &> /dev/null; then
        mkdir -p ~/.local/bin
        ln -sf /usr/bin/batcat ~/.local/bin/bat
    fi
    
    if command -v fdfind &> /dev/null; then
        mkdir -p ~/.local/bin
        ln -sf /usr/bin/fdfind ~/.local/bin/fd
    fi
    
    # اضافه کردن ~/.local/bin به PATH
    if ! grep -q 'export PATH="$HOME/.local/bin:$PATH"' ~/.bashrc; then
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
    fi
    
    # تنظیمات فایروال (UFW)
    sudo ufw --force enable
    sudo ufw default deny incoming
    sudo ufw default allow outgoing
    
    # نمایش اطلاعات سیستم
    echo -e "${GREEN}"
    neofetch --off 2>/dev/null || screenfetch 2>/dev/null || echo "سیستم آماده است!"
    echo -e "${NC}"
    
    check_error
}

# تابع نمایش منو
show_menu() {
    echo -e "${CYAN}========================================${NC}"
    echo -e "${YELLOW}لطفاً گروه مورد نظر برای نصب را انتخاب کنید:${NC}"
    echo -e "${CYAN}========================================${NC}"
    echo -e "${GREEN}1)${NC} پکیج‌های پایه"
    echo -e "${GREEN}2)${NC} ابزارهای شبکه و امنیت"
    echo -e "${GREEN}3)${NC} ابزارهای توسعه و برنامه‌نویسی"
    echo -e "${GREEN}4)${NC} Docker"
    echo -e "${GREEN}5)${NC} ابزارهای مانیتورینگ"
    echo -e "${GREEN}6)${NC} ابزارهای مدیریت فایل"
    echo -e "${GREEN}7)${NC} برنامه‌های گرافیکی"
    echo -e "${GREEN}8)${NC} ابزارهای امنیتی"
    echo -e "${GREEN}9)${NC} دیتابیس‌ها"
    echo -e "${GREEN}10)${NC} ابزارهای کلاد و کانتینر"
    echo -e "${GREEN}11)${NC} ابزارهای ارتباطی"
    echo -e "${GREEN}12)${NC} ابزارهای صوتی و تصویری"
    echo -e "${GREEN}13)${NC} فونت‌ها"
    echo -e "${GREEN}14)${NC} نصب همه موارد"
    echo -e "${GREEN}0)${NC} خروج"
    echo -e "${CYAN}========================================${NC}"
    echo -n "لطفاً انتخاب کنید (0-14): "
}

# اجرای اصلی
main() {
    # بررسی اجرا با روت
    if [[ $EUID -ne 0 ]]; then
        echo -e "${YELLOW}توجه: برخی عملیات نیاز به دسترسی روت دارند${NC}"
        echo -e "${YELLOW}لطفاً رمز عبور را وارد کنید${NC}"
    fi
    
    show_header
    check_os
    update_system
    
    while true; do
        show_menu
        read -r choice
        
        case $choice in
            1) install_basic_packages ;;
            2) install_network_tools ;;
            3) install_dev_tools ;;
            4) install_docker ;;
            5) install_monitoring_tools ;;
            6) install_file_tools ;;
            7) install_gui_apps ;;
            8) install_security_tools ;;
            9) install_databases ;;
            10) install_cloud_tools ;;
            11) install_communication_tools ;;
            12) install_media_tools ;;
            13) install_fonts ;;
            14)
                install_basic_packages
                install_network_tools
                install_dev_tools
                install_docker
                install_monitoring_tools
                install_file_tools
                install_gui_apps
                install_security_tools
                install_databases
                install_cloud_tools
                install_communication_tools
                install_media_tools
                install_fonts
                ;;
            0) 
                final_setup
                echo -e "${GREEN}نصب با موفقیت کامل شد!${NC}"
                echo -e "${YELLOW}توصیه می‌شود سیستم را یک بار راه‌اندازی مجدد کنید:${NC} sudo reboot"
                exit 0
                ;;
            *)
                echo -e "${RED}گزینه نامعتبر${NC}"
                ;;
        esac
        
        echo -e "${GREEN}عملیات با موفقیت انجام شد!${NC}"
        echo -e "${YELLOW}در حال بازگشت به منو...${NC}"
        sleep 2
    done
}

# اجرای تابع اصلی
main "$@"
