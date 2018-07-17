#/bin/bash

set -e

APP_BACKEND_SECRET=$1 || "secret"
FILE_CONFIG="/var/run/secrets/$APP_BACKEND_SECRET/env_vars"
KEY_FILTER=$2 || echo "all"

do_check_file_mounted () {
	while [ ! -f /run/secrets/boostport.com/vault-token ]; do
		echo "Waiting mout vault path..."
		sleep 2;
	done
}

do_check_jq () {
	if [ -z $(which jq) ]; then
		apk update && apk add jq;
	fi
}

do_set_to_env_file (){
	echo "$1" >> $FILE_CONFIG
}
do_check_file_mounted
do_check_jq

rm -rf $FILE_CONFIG || echo "File Config doesn't exists...moving on"
touch $FILE_CONFIG

TOKEN_APP=$(cat /var/run/secrets/boostport.com/vault-token |jq ".clientToken|tostring"|tr "\"" " ")


if [ "$KEY_FILTER" == "all" ]; then
	KEYS=$(curl --header "X-Vault-Token: $TOKEN_APP" --header "Content-Type: application/json" -X LIST http://vault:8200/v1/$APP_BACKEND_SECRET/ |jq -c '.data.keys[]|tostring ')
else
	KEYS=$KEY_FILTER
fi

for key in $KEYS; do
	key=$(echo "$key" |cut -d "\"" -f 2)
	env_var=$(curl --header "X-Vault-Token: $TOKEN_APP" --header "Content-Type: application/json" -X GET http://vault:8200/v1/$APP_BACKEND_SECRET/$key |jq -r '.data|to_entries[]|"export \(.key|ascii_upcase)=\"\(.value)\""')
	do_set_to_env_file "$env_var"
done

source $FILE_CONFIG
