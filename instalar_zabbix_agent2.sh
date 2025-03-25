#!/bin/bash

# Variáveis
ZBX_SERVER="10.7.53.142"
HOSTNAME=$(hostname)
ARQUIVO_DEB="zabbix-release_latest_7.0+debian12_all.deb"

echo "🔧 Atualizando sistema..."
apt update -y

echo "📦 Removendo .deb antigo (se existir)..."
rm -f zabbix-release_*.deb

echo "🌐 Baixando repositório do Zabbix..."
wget https://repo.zabbix.com/zabbix/7.0/debian/pool/main/z/zabbix-release/${ARQUIVO_DEB}

echo "📦 Instalando pacote de repositório..."
dpkg -i ${ARQUIVO_DEB}

echo "🔄 Atualizando repositórios..."
apt update -y

echo "📥 Instalando o Zabbix Agent 2..."
apt install zabbix-agent2 -y

echo "📝 Configurando o zabbix_agent2.conf..."
sed -i "s|^Server=.*|Server=${ZBX_SERVER}|" /etc/zabbix/zabbix_agent2.conf
sed -i "s|^ServerActive=.*|ServerActive=${ZBX_SERVER}|" /etc/zabbix/zabbix_agent2.conf
sed -i "s|^Hostname=.*|Hostname=${HOSTNAME}|" /etc/zabbix/zabbix_agent2.conf

echo "🔥 Liberando porta no UFW (caso esteja ativo)..."
ufw allow 10050/tcp 2>/dev/null || echo "⚠️ UFW não está ativo ou instalado."

echo "🚀 Iniciando e habilitando o serviço..."
systemctl enable zabbix-agent2
systemctl restart zabbix-agent2

echo "✅ Zabbix Agent 2 instalado e configurado com sucesso!"
