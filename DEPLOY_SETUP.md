# Деплой через терминал (один раз настроили — дальше только git push)

## Как это работает

Вы делаете `git push` с вашего ПК → GitHub → GitHub подключается к серверу и загружает файлы.

Подключение к серверу идёт с серверов GitHub, а не с вашего ПК, поэтому деплой не упирается в ваш firewall.

---

## Однократная настройка

### 1. Аккаунт GitHub

Если ещё нет: https://github.com → Sign up.

### 2. Новый репозиторий

- https://github.com/new
- Repository name: `katanaauto-website`
- Public
- Не добавлять README, .gitignore
- Create repository

### 3. Секреты репозитория

- В репозитории: **Settings** → **Secrets and variables** → **Actions**
- **New repository secret**, добавить:
  - `SERVER_HOST` = `95.81.124.2`
  - `SERVER_USER` = `root`
  - `SERVER_PASSWORD` = ваш пароль root
  - `SERVER_PORT` = `22`

### 4. Первый push с вашего ПК

В PowerShell:

```powershell
cd C:\Users\user\katanaauto-website

git init
git add index.html styles.css script.js data.js admin.html README.md images
git commit -m "init"
git branch -M main
git remote add origin https://github.com/VASH_LOGIN/katanaauto-website.git
git push -u origin main
```

`VASH_LOGIN` замените на ваш логин GitHub.

Git может запросить логин и пароль (или Personal Access Token).  
При необходимости: GitHub → Settings → Developer settings → Personal access tokens → создать токен.

---

## Деплой после изменений

```powershell
cd C:\Users\user\katanaauto-website
git add .
git commit -m "update"
git push
```

После каждого `git push` сайт будет автоматически загружаться на сервер.
