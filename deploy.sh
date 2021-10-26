#!/bin/bash
cd ..
mkdir bot
cd bot
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
cd telebot.postgres
source venv/bin/activate
mv ../deploy_bot/bot.conf /etc/supervisor/conf.d/
mv -f ../deploy_bot/supervisord.conf /etc/supervisor/
sudo -u postgres psql --command "CREATE USER shopbot WITH CREATEDB PASSWORD 'shopmebot';"
sudo -u postgres psql --command "ALTER ROLE shopbot SUPERUSER;"
sudo -u postgres psql --command "CREATE DATABASE shop;"
sudo -u postgres psql -d shop < ../start_files/shop.postgres2.sql;
sudo -u postgres psql --command "GRANT ALL PRIVILEGES ON DATABASE shop TO shopbot;"
sudo service supervisor reread
sudo service supervisor update
echo "http://37.140.198.172:9001/    -   -    управление ботом  "
cd ..
rm -r start_files
rm -r deploy_bot