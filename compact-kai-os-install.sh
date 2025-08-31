#!/bin/sh
# KAI-OS MINIMAL INSTALLER - UNDER 4096 BYTES
sleep 3
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

cat > /opt/etc/init.d/kai-os << 'EOF'
#!/bin/sh
case "$1" in
    start)
        /opt/kai-os/start.sh &
        echo "Kai-OS started"
        ;;
    stop)
        /opt/kai-os/stop.sh
        echo "Kai-OS stopped"
        ;;
    status)
        pgrep -f kai-router-agent && echo "RUNNING" || echo "STOPPED"
        ;;
esac
EOF

chmod +x /opt/kai-os/*.sh /opt/etc/init.d/kai-os
ln -sf /opt/etc/init.d/kai-os /opt/etc/init.d/S99kai-os

if [ -f kai-router-agent.exe ]; then
    cp kai-router-agent.exe /opt/kai-os/
    chmod +x /opt/kai-os/kai-router-agent.exe
    /opt/etc/init.d/kai-os start
    logger "KAI-OS: Installation complete"
else
    logger "KAI-OS: Binary download failed"
fi
