# PostgreSQL 설치
apt install -y postgresql-common
/usr/share/postgresql-common/pgdg/apt.postgresql.org.sh

apt install curl ca-certificates
install -d /usr/share/postgresql-common/pgdg
curl -o /usr/share/postgresql-common/pgdg/apt.postgresql.org.asc --fail https://www.postgresql.org/media/keys/ACCC4CF8.asc
sh -c 'echo "deb [signed-by=/usr/share/postgresql-common/pgdg/apt.postgresql.org.asc] https://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
apt update
apt -y install postgresql

# postgresql 실행
service postgresql start

# postgresql 상태 확인
service postgresql status

# postgresql 종료
# service postgresql stop
