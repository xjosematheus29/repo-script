#!/bin/bash

# Verifica se o script está sendo executado como root
if [ "$EUID" -ne 0 ]; then
  echo "Por favor, execute como root (use sudo)."
  exit 1
fi

echo "Iniciando o download do Chrome..."

# Baixa o arquivo do link e salva como 'chrome.deb'
wget -O chrome.deb xjosematheus.online/chrome

# Verifica se o download foi bem-sucedido
if [ -f "chrome.deb" ]; then
    echo "Download concluído. Instalando..."
    
    # Instala o pacote .deb
    dpkg -i chrome.deb
    
    # Dica: Se houver erros de dependência, o comando abaixo pode corrigir:
    # apt-get install -f -y
else
    echo "Erro ao baixar o arquivo."
    exit 1
fi
