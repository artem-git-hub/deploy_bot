#!/bin/bash
cd ~
mkdir bot
cd ~/bot
echo "----------Start deploy!----------"
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
sudo apt-get update
sudo apt-get -y install postgresql
echo "----------Postgres is installed!----------"
sudo apt-get install supervisor
echo "----------Supervisor is installed!----------"
git clone https://github.com/artem-git-hub/start_files
git clone https://github.com/artem-git-hub/telebot.postgres
mv start_files/photo/ telebot.postgres/
mv start_files/venv/ telebot.postgres/
source ~/telebot.postgres/venv/bin/activate
mv -f ~/deploy_bot/bot.conf /etc/supervisor/conf.d/
mv -f ~/deploy_bot/supervisord.conf /etc/supervisor/
sudo -u postgres psql --command "CREATE USER shopbot WITH CREATEDB PASSWORD 'shopmebot';"
sudo -u postgres psql --command "ALTER ROLE shopbot SUPERUSER;"
sudo -u postgres psql --command "CREATE DATABASE shop;"
sudo -u postgres psql -d shop < ../start_files/shop.postgres2.sql;
sudo -u postgres psql --command "GRANT ALL PRIVILEGES ON DATABASE shop TO shopbot;"
cd ..
rm -r ~/bot/start_files
cd ..
cd bot/
cd telebot.postgres/
source venv/bin/activate
sudo apt install pip
pip install telebot
pip install psycopg2-binary
pip install PyTelegramBotAPI
sudo supervisorctl reread
sudo supervisorctl update
sudo systemctl stop supervisor
sudo systemctl start supervisor
cd ~