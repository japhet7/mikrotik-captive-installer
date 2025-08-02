
# Mikrotik Captive Portal Auto-Installer

This script sets up a complete captive portal solution using:

- Ubuntu 20.04.6 LTS
- RadiusDesk (Admin GUI for managing users and vouchers)
- CoovaChilli (Captive portal engine)
- FreeRADIUS
- A modern responsive login page with M-Pesa and WhatsApp placeholders

## 🌐 Features

- Bandwidth and user control via RadiusDesk
- Voucher-based login
- Modern login UI with mobile responsiveness
- Placeholder buttons for M-Pesa payments and WhatsApp support
- Auto-start on boot services

## 📦 Services Installed

- Apache2
- PHP
- MariaDB (MySQL)
- FreeRADIUS
- CoovaChilli

## 🚀 How to Use

1. **Upload the script to your VPS** (Ubuntu 20.04.6 LTS recommended):
   ```bash
   scp mikrotik-captive-setup.sh root@your-vps-ip:/root/
   ```

2. **Connect to your VPS**:
   ```bash
   ssh root@your-vps-ip
   ```

3. **Make the script executable and run it**:
   ```bash
   chmod +x mikrotik-captive-setup.sh
   ./mikrotik-captive-setup.sh
   ```

4. **After Installation**:
   - Visit `http://<your-vps-ip>/radiusdesk` for the admin panel
   - Visit `http://<your-vps-ip>/hotspotlogin` for the user login portal

## ⚠️ What You Still Need to Do

- Configure MikroTik to use your VPS as the external RADIUS server
- Integrate payment gateways:
  - M-Pesa (Daraja API)
  - PayPal
  - Selcom
  - PesaPal
- Set up SMS/WhatsApp APIs for auto voucher delivery

## 📞 Support

If you need help customizing this script, reach out on [WhatsApp](https://wa.me/yourwhatsappnumber) or fork the repo and open a pull request.
