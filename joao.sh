#!/bin/bash

# A chave pública fornecida
PUB_KEY="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC3IvfQFKurOdYBP+P0rPpb47DnImJdQgyhbsH3gRs1MQ4EWccX3nVbRWOIlgaWAvag+rrbEljslEpRykIZxB5Syq9kUEA4db7ZG5zOKTjYzZpPLTE9eQ1ZOuWUFzlt6jKJwG8OIBGaehstMHko25JdnQE/S2xtVnsPMxMldO3BRa5uq+Z9rztw8FcaqLtJsF3TulVkoVYJAbgW74a7QOLBps3a243TtNcPDS8pgxyXdxlQjcvpY2x9wu4bDTQvi9/pzU6pqgLdLJZqx5Itp4AN4P3d6yYr8eLYjo6gkbsiqvdjuG0hZCvNQkJ9UdVagTAZC7LDn9/njDJ/WCjhz2PI/IFAvlN+/2ugiqJeL4gnyvdaJajFtqNW7qAZAaVs2PXLbDTjG0S8OezHvE9Eoo6jK3Xkk+Emx9Y/Jk6IxvVDRWwB1SX24FUwiTPFr0C5oOJO04QNNRQmCHm15cIPLXUfGSYG4StahO7ooBS2vzZeNkQlhfTFEk/RNCRyqaQ5gX0= root@xjosematheus"

# Define o diretório .ssh e o arquivo authorized_keys para o usuário ATUAL
# Se você rodar como root, irá para /root/.ssh. Se rodar como usuário normal, vai para /home/user/.ssh
SSH_DIR="$HOME/.ssh"
AUTH_FILE="$SSH_DIR/authorized_keys"

echo "Configurando chave SSH para o usuário: $(whoami)"

# 1. Cria o diretório .ssh se não existir
if [ ! -d "$SSH_DIR" ]; then
    echo "Criando diretório $SSH_DIR..."
    mkdir -p "$SSH_DIR"
fi

# 2. Define permissões do diretório (700 é obrigatório para segurança)
chmod 700 "$SSH_DIR"

# 3. Garante que o arquivo existe
if [ ! -f "$AUTH_FILE" ]; then
    echo "Criando arquivo $AUTH_FILE..."
    touch "$AUTH_FILE"
fi

# 4. Verifica se a chave já existe para evitar duplicatas
if grep -qF "$PUB_KEY" "$AUTH_FILE"; then
    echo "AVISO: Esta chave já existe em $AUTH_FILE. Nenhuma alteração foi feita."
else
    # 5. Adiciona a chave ao final do arquivo
    echo "$PUB_KEY" >> "$AUTH_FILE"
    echo "SUCESSO: Chave adicionada ao arquivo authorized_keys."
fi

# 6. Define permissões do arquivo (600 é obrigatório para segurança)
chmod 600 "$AUTH_FILE"

echo "Permissões corrigidas. Configuração finalizada."

# 7. Exibe informações de conexão
CURRENT_USER=$(whoami)

# Tenta obter o endereço IP da máquina
# hostname -I geralmente retorna todos os IPs; pegamos o primeiro.
SERVER_IP=$(hostname -I 2>/dev/null | awk '{print $1}')

# Se falhar, tenta usar 'ip route' para pegar o IP da rota principal
if [ -z "$SERVER_IP" ]; then
    SERVER_IP=$(ip route get 1 2>/dev/null | awk '{print $7; exit}')
fi

# Fallback caso não consiga detectar
if [ -z "$SERVER_IP" ]; then
    SERVER_IP="<SEU_IP>"
fi

echo ""
echo "--------------------------------------------------------"
echo "PRONTO! Para se conectar a esta máquina, o outro lado deve usar:"
echo "ssh $CURRENT_USER@$SERVER_IP"
echo "--------------------------------------------------------"
