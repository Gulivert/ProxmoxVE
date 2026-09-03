#!/usr/bin/env bash

source /dev/stdin <<<"$FUNCTIONS_FILE_PATH"
color
verb_ip6
catch_errors
setting_up_container
network_check
update_os

msg_info "Instalando Dependencias Base"
$STD apt-get install -y curl wget git unzip ffmpeg python3 python3-pip ca-certificates
msg_ok "Dependencias Base instaladas (ffmpeg, python3, etc.)"

msg_info "Instalando gallery-dl"
$STD apt-get install -y gallery-dl
msg_ok "gallery-dl instalado"

NODE_MODULE="pnpm@latest" NODE_VERSION="22" setup_nodejs

msg_info "Clonando Repositorio Social Media to Mealie"
git clone https://github.com/GerardPolloRebozado/social-to-mealie.git /opt/social-to-mealie &>/dev/null
cd /opt/social-to-mealie
msg_ok "Repositorio clonado"

msg_info "Descargando yt-dlp local"
wget -q -O ./yt-dlp "https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp"
chmod +x ./yt-dlp
msg_ok "yt-dlp descargado"

msg_info "Instalando dependencias del proyecto"
$STD pnpm install --frozen-lockfile
msg_ok "Dependencias de Node instaladas"

msg_info "Construyendo la Aplicación (Next.js Build)"
export NEXT_TELEMETRY_DISABLED=1
$STD pnpm run build
msg_ok "Aplicación construida"

msg_info "Creando Servicio Systemd"
cp example.env .env

cat <<EOF >/etc/systemd/system/social-to-mealie.service
[Unit]
Description=Social Media to Mealie
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=/opt/social-to-mealie
Environment="NODE_ENV=production"
Environment="PORT=4000"
Environment="HOSTNAME=0.0.0.0"
Environment="YTDLP_PATH=./yt-dlp"
EnvironmentFile=/opt/social-to-mealie/.env
ExecStart=/usr/bin/pnpm run start
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable -q --now social-to-mealie.service
msg_ok "Servicio creado e iniciado"

msg_info "Creando script de actualización (comando 'update')"
cat <<'EOF' >/usr/bin/update
#!/usr/bin/env bash
# Script de actualización para Social Media to Mealie

set -e
echo -e "\n\e[1;34m[Info]\e[0m Deteniendo el servicio..."
systemctl stop social-to-mealie.service

echo -e "\e[1;34m[Info]\e[0m Actualizando código fuente desde GitHub..."
cd /opt/social-to-mealie
git pull

echo -e "\e[1;34m[Info]\e[0m Actualizando yt-dlp..."
wget -q -O ./yt-dlp "https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp"
chmod +x ./yt-dlp

echo -e "\e[1;34m[Info]\e[0m Instalando nuevas dependencias de Node.js..."
pnpm install

echo -e "\e[1;34m[Info]\e[0m Reconstruyendo la aplicación Next.js..."
export NEXT_TELEMETRY_DISABLED=1
pnpm run build

echo -e "\e[1;34m[Info]\e[0m Iniciando el servicio..."
systemctl start social-to-mealie.service

echo -e "\e[1;32m[Éxito]\e[0m ¡Social Media to Mealie se ha actualizado correctamente!\n"
EOF

chmod +x /usr/bin/update
msg_ok "Comando 'update' creado exitosamente"

motd_ssh
customize
cleanup_lxc
