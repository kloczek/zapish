# zapish - Zabbix API SHell bindins
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
	local result="\"$1\":\"$2\""
	shift 2
	while [ -n "$1" ]; do
		result+=",$1"
		shift 1
	done
	echo $result
}

json_num() {
	local result="\"$1\":$2"
	shift 2
	while [ -n "$1" ]; do
		result+=",$1"
		shift 1
	done
	echo $result
}

json_list() {
	local result="\"$1\":{$2"
	shift 2
	while [ -n "$1" ]; do
		result+=",$1"
		shift 1
	done
	result+="}"
	echo $result
}

json_array_num() {
	local result="\"$1\":[$2"
	shift 2
	while [ -n "$1" ]; do
		result+=",$1"
		shift 1
	done
	result+="]"
	echo $result
}

json_array_str() {
	local result="\"$1\":[\"$2\""
	shift 2
	while [ -n "$1" ]; do
		result+=",\"$1\""
		shift 1
	done
	result+="]"
	echo $result
}

#====================================
# Zabbix API caller
#====================================

zabbix_api() {
	zapish_request="{$(json_str jsonrpc "2.0" \
		$(json_str method "$1" \
		"$2" \
		$(json_str auth $zapish_auth \
		$(json_num id 0 \
		""))))}"

	curl --silent -X POST -H \
		'Content-Type: application/json' -d \
			"$zapish_request" $zapish_url
}

#====================================
# Chek and initialize authentication
#====================================

zapish_init() {
	read -p "Enter URL of the zabbix API gateway [http://localhost/api_jsonrpc.php]: " zapish_url
	if [ ! -n "$zapish_url" ]; then
		zapish_url="http://localhost/api_jsonrpc.php"
	fi

	read -p "Enter zabbix API accout name [admin]: " zapish_user
	if [ ! -n "$zapish_user" ]; then
		zapish_user="admin"
	fi

	read -p "Enter zabbix API account password [zabbix]: " zapish_pwd
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

	local result=$(curl --silent -X POST -H \
		'Content-Type: application/json' -d \
			"$request" $zapish_url)

	echo zapish_url=\"$zapish_url\"	> ~/.zapish.rc
	echo zapish_auth=\"${result:27:-9}\" >> ~/.zapish.rc
	chmod 600 ~/.zapish.rc
}

# initialization
if [ -f  ~/.zapish.rc ]; then
	. ~/.zapish.rc
else
	zapish_init
fi
