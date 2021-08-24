```bash

#instead of human date format with awk epoch can be better, in case there is different date formatting
#replace:
#exp1_date=$(date -d "`date +%Y%m01` +18 month -1 day" +%Y-%m-%d)
#exp2_date=$(date -d "`date +%Y%m01` +12 month -1 day" +%Y-%m-%d)
#exp3_date=$(date -d "`date +%Y%m01` +6 month -1 day" +%Y-%m-%d)
#exp_date=$(date -d "`date +%Y%m01` +1 month" +%Y-%m-%d)

#with

exp_date=$(date -d 'September 1 2021' +%s)
exp1_date=$(date -d 'March 1 2022' +%s)
exp2_date=$(date -d 'September 1 2022' +%s)
exp3_date=$(date -d 'March 1 2023' +%s)

cp $path_file/file $path_file/file_epoch ;
for use_date in $(cat $path_file/file | awk -F',' '{print $4}' | sort | uniq | grep ^[2]) ;
        do      epoch_date=$(date -d $use_date +%s) ;
                echo $use_date $epoch_date > /dev/null 2>&1;
                sed -i "s|"$use_date"|"$epoch_date"|g" $path_file/file_epoch
        done
for exp_date in $(cat $path_file/file | awk -F',' '{print $3}' | sort | uniq | grep ^[2]) ;
        do epoch_u_date=$(date -d $exp_date +%s) ;
                sed -i "s|"$exp_date"|"$epoch_u_date"|g" $path_file/trm_file
        done
        
#complete dates validation same way only using epoch time instead
cat $path_file/file | 
awk -F';'  -v exp_1_date="$exp_1_date" -v exp_2_date="$exp_2_date" -v exp_3_date="$exp_3_date" -v exp_date="$exp_date" 'BEGIN{OFS=";"}
        {
        if ($3 <= exp_date && $2 ~/^'Exc'/){$2="Exception (expired)";print $0;}
        else if($3 <= exp_date){$2="Expired";print $0}
        else if($3 <= exp_3_date && $3 > exp_date && $2 ~/^'Exc'/){$2="Exception (expiring 3)";print $0;}
        else if($3 <= exp_3_date && $3 > exp_date){$2="Expiring 3";print $0;}
        else if($3 <= exp_2_date && $3 > exp_3_date && $2 ~/^'Exc'/){$2="Exception (expiring 2)";print $0;}
        else if($3 <= exp_2_date && $3 > exp_3_date){$2="Expiring 2";print $0;}
        else if($3 <= exp_1_date && $3 > exp_2_date && $2 ~/^'Exc'/){$2="Exception (expiring 1)";print $0;}
        else if($3 <= exp_1_date && $3 > exp_2_date){$2="Exiring 1";print $0;}
        else if($3 > exp_1_date && $2 ~/^'Exc'/){$2="Exception (selling)";print $0;}
        else if($3 > exp1_date){$2="Selling";print $0;}
        else if($3 == "Not available"){print $0}
        }' |
#many items don't have the replacement dates defined and it needs to be checked with suppliers
awk -F';' 'BEGIN{OFS=";"}
        {
        if ($3 == "Not available"){$7="Replacement date to be confirmed";print $0;}
        else{print $0}
        }' | awk -F';' 'BEGIN{OFS=";"}{print $5,$6,$1,$2,$3,$4,$7}'> $path_file/updated_dates
        
rm $path_file/file_hum
cp $path_file/updated_dates $path_file/file_hum
cat $path_file/file_hum |  awk -F',' 'BEGIN {OFS=","}{
        if($3 == "Not available" && $4 ~ /^'[0-9]'/){$4=strftime("%F",$4); print $0;}
        else if($3 == "Not available" && $4 == "Not available"){print $0;}
        else if($3 ~/^'[0-9]'/ && $4 == "Not available"){$3=strftime("%F",$3); print $0;}
        else if($3 ~/^'[0-9]'/ && $4 ~ /^'[0-9]'/){$3=strftime("%F",$3);$4=strftime("%F",$4); print $0;}
        }' > $path_file/file_report
#dates in column 3 and 4 are converted form epoch back to human
        
```
