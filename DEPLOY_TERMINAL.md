# Загрузка через терминал

## Вариант 1: Ваш терминал (когда SSH работает)

Откройте PowerShell в папке сайта и выполните:

```powershell
cd C:\Users\user\katanaauto-website
.\deploy.ps1
```

Или одной строкой из любой папки:

```powershell
scp -r "C:\Users\user\katanaauto-website\*" root@95.81.124.28:/var/www/html/
```

Введите пароль при запросе.

---

## Вариант 2: Терминал в панели хостинга (когда SSH не подключается)

Используйте **веб-терминал** в панели хостинга — он работает из браузера.

### Шаг 1: Залейте архив на файлообменник

1. Запустите `create-zip.bat` — создастся `C:\Users\user\katanaauto-website.zip`
2. Загрузите архив на:
   - [tmpfiles.org](https://tmpfiles.org) — получите ссылку
   - или [file.io](https://www.file.io)
   - или создайте репозиторий на GitHub и залейте файлы

### Шаг 2: В панели хостинга откройте терминал

Найдите раздел **«Терминал»**, **«Консоль»**, **«SSH»** или **«VNC»**.

### Шаг 3: Выполните в терминале на сервере

Если есть прямая ссылка на zip:

```bash
cd /var/www/html
wget -O site.zip "ВАША_ССЫЛКА_НА_ЗИП"
unzip -o site.zip
rm site.zip
```

Если используете GitHub (сначала загрузите проект в репозиторий):

```bash
cd /var/www
rm -rf html.old
mv html html.old 2>/dev/null || mkdir -p html
git clone https://github.com/VASH_LOGIN/katanaauto-website.git html
```

---

## Проверка

После загрузки откройте https://katanaauto38.ru
