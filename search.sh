    #!/bin/bash

    #Execution plan
    #Run this in a screen at 6am on the insight server and monitor progress

    #Set Varibles
    USER='root'
    PASS=`openssl aes-256-cbc -d -a -in /home/akalaj/akalaj.pass`
    #ensure decryption works or else backout
        #if [ "$?" -ne 0 ]; then
        #        clear && echo -e "Decryption not successful. Exiting..." && exit 1;
        #fi

        LIST="rpt_paidPlanSheetAccess
rpt_paymentProfile
rpt_paidPlanInfo
hist_paymentProfile
rpt_paidPlanCurrentUsers
rpt_paidPlanCollabCount
output_RevenueSummaryMonthly
arc_haleyDomainMapped
arc_haleyDomainLookup
arc_haleyIndustryMapping
arc_lead411IndustryMapping
arc_sfdcIndustryMapping
rpt_paidDomains
rpt_userIPLocation
hist_currencyExchange
ref_ipAddressInfo
rpt_signupSource
ref_country
ref_region
rpt_userIPLocation
rpt_optimizelyExperiments
rpt_signupSource
rpt_userJobTitle
ref_inferredRoleCampaigns
rpt_userSourceIP
arc_sessionLog
googleAppsDomain
ref_months
rpt_monthEndCustomerProduct"

    #cont. vars
    AUTH='mysql -u'$USER' -p'$PASS''
    DAUTH='mysqldump -u'$USER' -p'$PASS''
    DATABASE=$1
    #TABLE=$2
    CHARSET='utf8mb4'
    COLLATION='utf8mb4_unicode_520_ci'



        for TABLES in $LIST; do
    CHKCHARSET=$($AUTH $DATABASE -Bse "SHOW CREATE TABLE $TABLES" 2>/dev/null | grep -o -P '.{0}CHARSET=[[:alnum:]]*.{0}' 2>/dev/null)
    CHKCOLL=$($AUTH information_schema -Bse"SELECT TABLE_COLLATION FROM TABLES WHERE TABLE_SCHEMA='$DATABASE' AND TABLE_NAME='$TABLES'" 2>/dev/null)
    echo "===$TABLES==="
    echo $CHKCHARSET
    echo "COLLATION=$CHKCOLL"
    echo "======="
        done;
