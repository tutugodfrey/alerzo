#! /bin/bash

# Intended for use in connecting to database with secret provided. 
# If a secret is password, assume it database credential and connect to the database. 
# Otherwise the getsecretvalue function could just be source and use to get any secret value

getsecretvalue () {
  aws secretsmanager get-secret-value --secret-id $1 | jq .SecretString | jq fromjson
}

if [ ! -z "$1" ]; then
  secret=`getsecretvalue $1`
  user=$(echo $secret | jq -r .username)
  password=$(echo $secret | jq -r .password)
  port=$(echo $secret | jq -r .port)
  host=$(echo $secret | jq -r .host)

  export PGPASSWORD=$password
  psql -U $user -h $host -p $port -d postgres
fi
