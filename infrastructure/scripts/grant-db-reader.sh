#! /bin/bash

# unset PASS_LIST
ENV_PREFIX=${ENV_PREFIX:-'DEV'}
eval DB_USER=\$"${ENV_PREFIX}_DATABASE_USERNAME"
eval DB_PASSWORD=\$"${ENV_PREFIX}_DATABASE_PASSWORD"
# eval DB_HOST=\$(eval echo $"${ENV_PREFIX}_DATABASE_HOST")
# NAME=$(eval echo $"${ENV_PREFIX}_DATABASE_USERNAME")
# NAME2=$"${ENV_PREFIX}_DATABASE_USERNAME"
eval DB_HOST=\$"${ENV_PREFIX}_DATABASE_HOST"
DB=${DB:-'postgres'}

echo ENV_PREFIX ${ENV_PREFIX} DB_USER ${DB_USER} DB_HOST $DB_HOST DB ${DB}

ROLE_NAME=${ROLE_NAME:-'reader'}
USERS_LIST=(TomiwaAdewole AndrewAdejoh);
PASS_LIST=(${PASS_LIST});
TARGET_DB_LIST=('wallet' 'cable');
if [[ -z $PASS_LIST ]]; then
  echo Please provide the list of users password
  exit 1
fi

export PGPASSWORD=${DB_PASSWORD}
# Create role
cat > create_reader_role.sql <<EOF
CREATE ROLE ${ROLE_NAME} INHERIT LOGIN;
EOF
psql -U ${DB_USER} -h ${DB_HOST} -d ${DB} < create_reader_role.sql

# Create USERk
echo $USERS_LIST
for i in ${!USERS_LIST[@]}; do
echo $i ${USERS_LIST[$i]}
cat > create_user.sql <<EOF
CREATE USER "${USERS_LIST[$i]}" WITH PASSWORD '${PASS_LIST[$i]}';
EOF
psql -U ${DB_USER} -h ${DB_HOST} -d ${DB} < create_user.sql 
done;

# Grant ROLE role to users
for i in ${!USERS_LIST[@]}; do
cat > assign_reader_role.sql <<EOF
GRANT "${ROLE_NAME}" TO "${USERS_LIST[$i]}";
EOF
psql -U ${DB_USER} -h ${DB_HOST} -d ${DB} < assign_reader_role.sql
done;

# GRANT PRIVILEGES TO ROLE
cat > db_access_query.sql <<EOF
GRANT USAGE ON SCHEMA public TO "${ROLE_NAME}";
GRANT SELECT ON ALL TABLES IN SCHEMA public TO "${ROLE_NAME}";
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO "${ROLE_NAME}";
EOF

for i in ${!TARGET_DB_LIST[@]}; do
  psql -U ${DB_USER} -h ${DB_HOST} -d ${TARGET_DB_LIST[$i]} < db_access_query.sql
done;
