#!/bin/bash

family_users=()
number_of_inbound=1
count=$(jq ".inbounds[$number_of_inbound].settings.clients | length" /usr/local/x-ui/bin/config.json)
json=$(jq ".inbounds[$number_of_inbound].settings.clients" /usr/local/x-ui/bin/config.json)

last_index=$(($count - 1));

for email_row in $(seq 0 $last_index) ;do
		uuid=$(echo $json | jq ".[$email_row].id");
		email$(echo $json | jq ".[$email_row].email");
done