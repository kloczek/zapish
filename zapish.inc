# zapish - Zabbix API SHell binding
# 
# This program is free software, distributed under the terms of
# the GNU General Public License Version 2.
#
# Copyright (C) 2017 Tomasz Kłoczko <kloczek@fedoraproject.org>
#

zapish_url=""
zapish_auth=""

zapish_request=""

json_str() {
	echo -n "\"$1\":\"$2\""
	shift 2
	while [ -n "$1" ]; do
		echo -n ",$1"
		shift 1
	done
}

json_num() {
	echo -n "\"$1\":$2"
	shift 2
	while [ -n "$1" ]; do
		echo -n ",$1"
		shift 1
	done
}

json_list() {
	echo -n "\"$1\":{$2"
	shift 2
	while [ -n "$1" ]; do
		echo -n ",$1"
		shift 1
	done
	echo -n "}"
}

json_array_num() {
	echo -n "\"$1\":[$2"
	shift 2
	while [ -n "$1" ]; do
		echo -n ",$1"
		shift 1
	done
	echo -n "]"
}

json_array_str() {
	echo -n "\"$1\":[\"$2\""
	shift 2
	while [ -n "$1" ]; do
		echo -n ",\"$1\""
		shift 1
	done
	echo -n "]"
}

#====================================
# Zabbix result processor
#====================================
 
json_get() {
#	for i in $(eval "echo {1..${#1}}"); do
#		echo -n "${1:$((i-1)):1} "
#	done
	echo "$1" | jq "$2"
}

json_error() {
	if [ "$(json_get "${1}" .error.code)" != "null" ]; then
		json_get "${1}" .error
		exit 4
	else
		echo "$1"
	fi
}

#====================================
# Zabbix API caller
#====================================

zabbix_api() {
	if [ -z "$1" ]; then
		echo "zabbix_api() function expects a list of parameters describing API call"
		exit 3
	fi

	zapish_request="{$(json_str jsonrpc "2.0" \
		"$(json_str method "$1" \
			"$2" \
			"$(json_str auth $zapish_auth "")" \
			"$(json_num id 0 "")" \
		"")" \
	)}"

	json_error "$(curl --silent -X POST -H \
		'Content-Type: application/json' -d \
			"$zapish_request" $zapish_url)"
}

#====================================
# Check and initialize authentication
#====================================

zapish_init() {
	read -p "Enter URL of the Zabbix API gateway [http://localhost/api_jsonrpc.php]: " zapish_url
	if [ ! -n "$zapish_url" ]; then
		zapish_url="http://localhost/api_jsonrpc.php"
	fi

	read -p "Enter Zabbix API account name [Admin]: " zapish_user
	if [ ! -n "$zapish_user" ]; then
		zapish_user="Admin"
	fi

	read -p "Enter Zabbix API account password [zabbix]: " zapish_pwd
	if [ ! -n "$zapish_pwd" ]; then
		zapish_pwd="zabbix"
	fi

	local request="{"
	request+="$(json_str jsonrpc "2.0" \
		$(json_str method user.login \
		$(json_list params \
			$(json_str user "$zapish_user" \
			$(json_str password "$zapish_pwd" \
			"")) \
		"") \
		$(json_num id 0 \
		"") \
		))"
	request+="}"

	local result="$(curl --silent -X POST -H \
		'Content-Type: application/json' -d "$request" $zapish_url)"

	if [ "$(json_get "${result}" .error )" != "null" ]; then
		echo "Zabbix API authentication error."
		exit 1
	fi

	echo zapish_url=\"$zapish_url\"	> ~/.zapish.rc
	echo zapish_auth=$(json_get "${result}" .result) >> ~/.zapish.rc
	chmod 600 ~/.zapish.rc
	echo "Zabbix API authentication successful. No Zabbix API call."
	echo "zapish authentication token has been stored in ~/.zapish.rc"
	exit 2
}

# initialization
if [ -f  ~/.zapish.rc ]; then
	. ~/.zapish.rc
else
	zapish_init
fi
