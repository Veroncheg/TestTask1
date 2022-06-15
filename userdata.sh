#!/usr/bin/env bash
git clone https://github.com/Veroncheg/TestTask1.git 
cd TestTask1
cp testlog.service /etc/systemd/system/
cp testlog.sh /usr/bin/
cp testlog /var/log/
systemctl daemon-reload
systemctl enable testlog.service
systemctl start testlog.service
