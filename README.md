# Ubuntu-Package-Installer-Script

یک اسکریپت کامل و جامع برای نصب خودکار پکیج‌ها و برنامه‌های مورد نیاز در اوبونتو

![Ubuntu](https://img.shields.io/badge/Ubuntu-20.04%20|%2022.04%20|%2024.04-orange)
![Bash](https://img.shields.io/badge/Bash-5.0%2B-green)
![License](https://img.shields.io/badge/License-MIT-blue)

## 📋 ویژگی‌ها

- ✅ نصب بیش از ۲۰۰ پکیج و برنامه
- ✅ منوی تعاملی و کاربرپسند
- ✅ پشتیبانی از اوبونتو 20.04، 22.04 و 24.04
- ✅ نصب گروهی یا تکی برنامه‌ها
- ✅ مدیریت خطا و ادامه نصب در صورت بروز مشکل
- ✅ نمایش رنگ‌بندی شده برای خوانایی بهتر
- ✅ تنظیمات نهایی خودکار

## 📦 گروه‌های نرم‌افزاری

| گروه | توضیحات |
|------|---------|
| **پکیج‌های پایه** | curl, wget, git, nano, vim, htop و... |
| **ابزارهای شبکه** | ufw, iptables, nmap, wireshark, openvpn و... |
| **برنامه‌نویسی** | python, nodejs, golang, java, php, rust و... |
| **Docker** | docker, docker-compose, containerd |
| **مانیتورینگ** | glances, nmon, htop, bpytop, gotop و... |
| **مدیریت فایل** | ranger, mc, rsync, tmux, jq و... |
| **برنامه‌های گرافیکی** | vscode, firefox, gimp, vlc و... |
| **امنیت** | clamav, rkhunter, fail2ban, lynis و... |
| **دیتابیس** | mysql, postgresql, mongodb, redis و... |
| **کلاد** | kubectl, helm, awscli, terraform و... |
| **ارتباطی** | discord, slack, telegram |
| **صوتی و تصویری** | audacity, obs-studio, spotify و... |
| **فونت‌ها** | fira-code, vazir, roboto و... |

## 🚀 روش نصب سریع

```bash
bash <(curl -s https://raw.githubusercontent.com/[username]/[repo-name]/main/install-packages.sh)


روش استفاده

    دانلود اسکریپت:

bash

git clone https://github.com/[username]/[repo-name].git
cd [repo-name]
chmod +x install-packages.sh

    اجرای اسکریپت:

bash

sudo ./install-packages.sh

📸 اسکرین‌شات

https://screenshot.png
🤝 مشارکت

مشارکت شما در بهبود این پروژه بسیار خوش‌آیند است!

    Fork کنید

    Branch جدید بسازید (git checkout -b feature/amazing-feature)

    Commit کنید (git commit -m 'Add some amazing feature')

    Push کنید (git push origin feature/amazing-feature)

    Pull Request بزنید

📝 نکات مهم

    اسکریپت نیاز به دسترسی روت دارد

    پیشنهاد می‌شود قبل از اجرا، از سیستم Backup بگیرید

    برای نصب همه موارد، گزینه 14 را انتخاب کنید

⚠️ عیب‌یابی
مشکل	راه‌حل
خطای GPG	sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys [KEY]
نصب Docker	مطمئن شوید سیستم‌عامل 64 بیتی است
نصب MongoDB	فقط در اوبونتو 20.04 پشتیبانی می‌شود
📜 لایسنس

این پروژه تحت لایسنس MIT منتشر شده است.

❤️ با عشق برای جامعه اوبونتو
text


### 3️⃣ **اضافه کردن فایل‌های دیگر**

**فایل `.gitignore`:**

*.deb
*.tar.gz
*.zip
*.log
.vscode/
.idea/
*.swp
*.swo
*~
.DS_Store
text


**فایل `install.sh` برای نصب سریع:**
```bash
#!/bin/bash
bash <(curl -s https://raw.githubusercontent.com/[username]/[repo-name]/main/install-packages.sh)
