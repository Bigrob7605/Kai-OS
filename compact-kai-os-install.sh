#!/bin/sh
# KAI-OS ULTRA-MINIMAL - UNDER 4096 BYTES
sleep 2
logger "KAI-OS: Installing..."
mkdir -p /opt/kai-os /opt/etc/init.d /tmp/kai-download
cd /tmp/kai-download
wget -O kai-router-agent.exe "https://raw.githubusercontent.com/Bigrob7605/Kai-OS/main/kai-router-agent.exe" 2>/dev/null || \
curl -o kai-router-agent.exe "https://raw.githubusercontent.com/Bigrob7605/Kai-OS/main/kai-router-agent.exe" 2>/dev/null

cat > /opt/kai-os/start.sh << 'EOF'
#!/bin/sh
cd /opt/kai-os
[ -f kai-router-agent.exe ] && ./kai-router-agent.exe &
EOF

cat > /opt/kai-os/stop.sh << 'EOF'
#!/bin/sh
pkill -f kai-router-agent
EOF

chmod +x /opt/kai-os/*.sh
ln -sf /opt/kai-os/start.sh /opt/etc/init.d/S99kai-os

if [ -f kai-router-agent.exe ]; then
    cp kai-router-agent.exe /opt/kai-os/
    chmod +x /opt/kai-os/kai-router-agent.exe
    /opt/kai-os/start.sh
    logger "KAI-OS: Complete"
else
    logger "KAI-OS: Failed"
fi
