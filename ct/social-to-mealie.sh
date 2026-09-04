#!/usr/bin/env bash
_CS_DEFAULT_URL="https://raw.githubusercontent.com/Gulivert/ProxmoxVE/feat/social-to-mealie"
_cs_boot="${COMMUNITY_SCRIPTS_CORE_DIR:-$(dirname "${BASH_SOURCE[0]}")/../../core}/core/build.func"
source "$_cs_boot" 2>/dev/null || source <(curl -fsSL "${COMMUNITY_SCRIPTS_CORE_URL:-https://raw.githubusercontent.com/community-scripts/core/main}/core/build.func")

APP="Social Media to Mealie"
var_tags="recipe;media;ai"
var_cpu="2"
var_ram="2048"
var_disk="8"
var_os="debian"
var_version="12"
var_unprivileged="1"

function header_info {
clear
cat <<"EOF"
   ____             _       _   _____       __  __            _ _      
  / ___|  ___   ___(_) __ _| | |_   _|__   |  \/  | ___  __ _| (_) ___ 
  \___ \ / _ \ / __| |/ _` | |   | |/ _ \  | |\/| |/ _ \/ _` | | |/ _ \
   ___) | (_) | (__| | (_| | |   | | (_) | | |  | |  __/ (_| | | |  __/
  |____/ \___/ \___|_|\__,_|_|   |_|\___/  |_|  |_|\___|\__,_|_|_|\___|
EOF
}
header_info
echo -e "\n"
var_install="social-to-mealie-install"
color
catch_errors

start
build_container
description

msg_ok "Completed Successfully!\n"
echo -e "⚠  ${APP} requiere configuración adicional antes de iniciar."
echo -e "Edita el archivo de entorno en la consola del contenedor usando:"
echo -e "  nano /opt/social-to-mealie/.env"
echo -e "Luego reinicia el servicio con: systemctl restart social-to-mealie"
