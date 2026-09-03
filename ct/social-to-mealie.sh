#!/usr/bin/env bash
source <(curl -s https://raw.githubusercontent.com/community-scripts/ProxmoxVE/main/misc/build.func)
# App Default Settings
APP="Social Media to Mealie"
var_tags="recipe;media;ai"
var_cpu="2"
var_ram="2048"
var_disk="8"
var_os="debian"
var_version="12"
var_unprivileged="1"

# Header Information
header_info "$APP"

# Proxmox Builder Functions
base_settings
build_container
description

msg_ok "Completed Successfully!\n"
echo -e "⚠  ${APP} requiere configuración adicional antes de iniciar."
echo -e "Edita el archivo de entorno en la consola del contenedor usando:"
echo -e "  nano /opt/social-to-mealie/.env"
echo -e "Luego reinicia el servicio con: systemctl restart social-to-mealie"
