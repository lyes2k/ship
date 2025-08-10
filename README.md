# 🚀 Ship — Simple Static Site Deployment Tool

`ship` is a lightweight CLI tool to deploy static sites (React, Vue, etc.)  
to an Ubuntu server with **Nginx** and **Let's Encrypt** SSL automatically.

---

## ✨ Features
- Deploy static sites to any subdomain
- Automatic Let's Encrypt SSL
- Update existing deployments without reissuing certs
- Remove deployments easily
- Track deployments and last SSL renewal date
- Works with any domain (set default or pass `-d` each time)
- Fully portable — no hardcoded paths

---

## 📦 Installation

On your server:

```bash
curl -fsSL https://raw.githubusercontent.com/lyes2k/ship/main/ship-install.sh | bash
```

---

## ⚙️ Usage

### Deploy a site
```bash
ship -s demo -d example.com
```
If no `-s` is given, a random subdomain is generated.  
If no `-d` is given, the default domain from `~/.shiprc` is used.

### Build + Deploy
```bash
ship-build -s demo -d example.com
```

### Set default domain
```bash
ship --set-default-domain example.com
```

### Set email for SSL
```bash
ship --set-email you@example.com
```

### List deployments
```bash
ship --list
```

### Renew SSL manually
```bash
ship -s demo -d example.com -c
```

### Remove deployment
```bash
ship -s demo -d example.com -r
```

---

## 📂 File Locations
- Config: `~/.shiprc`
- Hosted sites: `/home/<user>/hosted`
- Nginx template: `/etc/nginx/sites-available/react-template`

---

## 🔒 SSL Renewal
Certbot automatically renews certificates before expiration.  
You can test with:
```bash
sudo certbot renew --dry-run
```

---

## 🛠 Requirements
- Ubuntu server
- Nginx
- Node.js (for `ship-build`)
- Certbot
- jq, rsync, curl

---

## 📜 License
MIT
