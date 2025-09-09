#!/bin/bash

family_users=()
blocked_sites=('.phncdn.com' 'xnxx.com' 'pornhub.com' 'xhamster.com' 'xvideos.com')
number_of_inbound=1
config_json_address="/usr/local/x-ui/bin/config.json"
userslogs="/usr/local/x-ui/access.log"

count=$(jq ".inbounds[$number_of_inbound].settings.clients | length" $config_json_address)
json=$(jq ".inbounds[$number_of_inbound].settings.clients" /usr/local/x-ui/bin/config.json)

last_index=$(($count - 1));

for email_row in $(seq 0 $last_index) ;do
		itsuuid=$(echo "$json" | jq -r ".[$email_row].id"); # using -r switch for result that have not quotation (') or double quotation (")
		itsemail=$(echo "$json" | jq -r ".[$email_row].email"); # using -r switch for result that have not quotation (') or double quotation (")
		data+=("$itsuuid|$itsemail")
		emails+=("$itsemail")
done

# for email in "${emails[@]}" ; do
	# echo $email;

# done

# printf 'emails array: %s\n' "${emails[@]}"



# Build a regex pattern from the emails array, joining them with "|"
pattern=$(IFS='|'; echo "${emails[*]}")
# Search the log file ($userslogs) for lines that contain
# EXACT matches of any of those emails (word boundaries \< \>)
# and save the matching lines into returnofgrep
returnofgrep=$(grep -E "\<($pattern)\>" $userslogs);

# echo "$returnofgrep" | awk '{print $1,$2,$3}'

first_line=$(echo "$returnofgrep" | head -n 1 | awk '{print $1,$2}')
last_line=$(echo "$returnofgrep" | tail -n 1 | awk '{print $1,$2}')
first_line_unixtime=$(date -d "$first_line" +"%s")
last_line_unixtime=$(date -d "$last_line" +"%s")

# echo $first_line_unixtime
# echo $last_line_unixtime
# echo $(($last_line_unixtime - $first_line_unixtime))

while IFS='' read -r line; do
	# for blocked_site in $(seq 0 $((${#blocked_sites[@]} - 1 ))) ;do
	for blocked_site in "${blocked_sites[@]}" ;do
		echo "$line" | awk '{print $6}' | grep "$blocked_site" && awk '{print "Users :$11 - sites: $6"}'
	done
done < $userslogs

# IFS='|'
# for e in "${data[@]}" ; do
	# echo $e
# done
# grep "email: ${data[@]}" "$userslogs"