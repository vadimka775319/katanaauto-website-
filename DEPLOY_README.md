# Загрузка через терминал

## Быстрый старт

**PowerShell** (откройте в папке katanaauto-website):
```powershell
.\deploy.ps1
```

**Командная строка:**
```cmd
deploy.bat
```

При запросе введите пароль root.

---

## Если порт 22 не подключается

Узнайте порт SSH в панели хостинга, затем:

```powershell
.\deploy.ps1 -Port 2222
```

или

```cmd
deploy.bat 2222
```

---

## Откуда запускать

Перейдите в папку сайта перед запуском:

```powershell
cd C:\Users\user\katanaauto-website
.\deploy.ps1
```

---

## Разрешение выполнения скриптов PowerShell

Если появится ошибка «выполнение скриптов отключено»:

```powershell
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned
```
