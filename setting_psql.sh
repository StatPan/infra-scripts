#!/bin/bash

# 환경 변수 설정
DB_USER="new_user"
DB_PASSWORD="new_password"
DB_NAME="new_database"

# PostgreSQL 접속 정보
PGHOST="localhost"
PGPORT="8888"
PGADMIN_USER="postgres"
PGADMIN_PASSWORD="admin_password"

# PostgreSQL 접속
export PGPASSWORD=$PGADMIN_PASSWORD

# 사용자 생성 및 비밀번호 설정
psql -h $PGHOST -p $PGPORT -U $PGADMIN_USER -d postgres -c "CREATE USER $DB_USER WITH PASSWORD '$DB_PASSWORD';"

# 데이터베이스 생성 (필요한 경우)
psql -h $PGHOST -p $PGPORT -U $PGADMIN_USER -d postgres -c "CREATE DATABASE $DB_NAME OWNER $DB_USER;"

# 권한 부여
psql -h $PGHOST -p $PGPORT -U $PGADMIN_USER -d postgres -c "GRANT ALL PRIVILEGES ON DATABASE $DB_NAME TO $DB_USER;"

# 설정 파일 변경 (pg_hba.conf)
PG_HBA_CONF="/etc/postgresql/16/main/pg_hba.conf"

echo "host    all             all             0.0.0.0/0               md5" >> $PG_HBA_CONF

# PostgreSQL 재시작
sudo service postgresql restart

echo "User $DB_USER and database $DB_NAME created successfully."
