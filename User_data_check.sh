```bash
path_cbp=/home/anna/id_check
for mail in $( cat $path_cbp/contacts | grep \@ | sed 's/ /\n/g' | sed 's/,/\n/g' | sort | uniq )
        do      data=$(copy_table.pl *table.ID* -Q "email like '$mail'" --dataonly)
                if [ ! -z "$data" ];
                        then
                        u_id=$(echo "$data" | awk -F':' '{print $1}')
                        full_name=$(echo "$data" | awk -F':' '{print $3}')
                        first_name=$(echo "$full_name" | awk '{print $2}')
                        last_name=$(echo "$full_name" | awk '{print $1}' | sed 's",""g')
                        wget "http://link"$(echo $full_name | sed 's/,//g' | awk '{print $2"+"$1}')"&searchtype=link" -O $path_cbp/id 2>/dev/null
                        group_id=$(cat $path_cbp/id | egrep -i $last_name | egrep -i $first_name | grep 'photo?id=' --color | awk -F'id=' '{print $2}' | awk -F'&' '{print $1}')
                        email=$(cat $path_cbp/id | egrep -i $last_name | egrep -i $first_name  | grep \@***.com |  grep 'E-mail Address' | awk -F'mailto:' '{print $2}'  | awk -F'"' '{print $1}')
                        facility=$(echo "$data" | awk -F':' '{print $7}')
                        personal_number=$(echo "$data" | awk -F':' '{print $6}')
                        while [ -z "$group_id" ];
                                do     rm $path_cbp/id;
                                       wget "http://link"$(echo $full_name | sed 's/,//g' | awk '{print $2"+"$1}')"&searchtype=link" -O $path_cbp/id 2>/dev/null;
                                       group_id=$(cat $path_cbp/id  |  egrep -i $last_name | egrep -i $first_name |  grep 'photo?id=' --color | awk -F'id
                                       =' '{print $2}' | awk -F'&' '{print $1}');
                                        email=$(cat $path_cbp/id | egrep -i $last_name | egrep -i $first_name | grep \@***.com | grep 'E-mail Address' | awk -F'mailto:' '{print $2}'  | awk -F'"' '{print $1}')
                                        facility=$(echo "$data" | awk -F':' '{print $7}')
                                        personal_number=$(echo "$data" | awk -F':' '{print $6}')
                                done
                        echo $u_id $full_name $group_id $email $facility $personal_number
                        cat $path_cbp/*table.ID* | sed "s/u_id = \"\"/u_id = \"$u_id\"/g" | sed "s/full_name = \"\"/full_name = \"$full_name\"/g" | sed "s/group_id = \"\"/group_id = \"$group_id\"/g" | sed "s/email_address = \"\"/email_address = \"$email\"/g" | sed "s/facility = \"\"/facility = \"$facility\"/g" | sed "s/personal_number = \"\"/personal_number = \"$personal_number\"/g"
                fi
        unset date u_id full_name group_id email facility presonal_number
        done


```
