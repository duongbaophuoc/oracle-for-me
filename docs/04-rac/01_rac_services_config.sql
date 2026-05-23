-- Run as 'oracle' user on OS level to create RAC services

-- 1. Create OLTP Service (Prefer Node 1)
srvctl add service -db PRODDB -service srv_oltp -preferred PRODDB1 -available PRODDB2 -tafpolicy BASIC -failovertype SELECT -failovermethod BASIC

-- 2. Create Reporting Service (Load Balanced)
srvctl add service -db PRODDB -service srv_report -preferred PRODDB1,PRODDB2 -clbgoal LONG -rlbgoal SERVICE_TIME

-- 3. Start services
srvctl start service -db PRODDB -service srv_oltp
srvctl start service -db PRODDB -service srv_report