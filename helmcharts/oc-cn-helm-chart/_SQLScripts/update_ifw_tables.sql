-- -*-SQL-*-
-- ============================================================================
-- Script to Clean the IFW tables for mastering in PDC
-- ============================================================================
-- Version 1.00 - 08/27/2012
-- Kevin Lussie
-- ============================================================================
set echo on;
delete from IFW_APN_MAP;
delete from IFW_HOLIDAY;
delete from IFW_DISCOUNTDETAIL;
delete from IFW_DSCBALIMPACT;
delete from IFW_DSCCONDITION;
delete from IFW_DSCMDL_CNF;
delete from IFW_DSCMDL_VER;
delete from IFW_DSCTRIGGER;
delete from IFW_GEO_MODEL;
delete from IFW_GEO_ZONE;
delete from IFW_MODEL_SELECTOR;
delete from IFW_PRICEMDL_STEP;
delete from IFW_RATEPLAN_CNF;
delete from IFW_RESOURCE;
delete from IFW_RUMGROUP_LNK;
delete from IFW_SELECTOR_BLOCK;
delete from IFW_SELECTOR_BLOCK_LNK;
delete from IFW_SELECTOR_DETAIL;
delete from IFW_SELECTOR_RULE;
delete from IFW_SELECTOR_RULESET;
delete from IFW_SELECTOR_RULE_LNK;
delete from IFW_SPECIALDAY_LNK;
delete from IFW_STANDARD_ZONE;
delete from IFW_TIMEMODEL;
delete from IFW_TIMEMODEL_LNK;
delete from IFW_TIMEZONE;
delete from IFW_USC_MAP;
delete from IFW_ZONE;
delete from IFW_SPECIALDAYRATE;
delete from IFW_DAYCODE;
delete from IFW_DISCOUNTMODEL;
delete from IFW_DISCOUNTSTEP;
delete from IFW_PRICEMODEL;
delete from IFW_RATEPLAN_VER;
delete from IFW_RUM;
delete from IFW_TIMEINTERVAL;
delete from IFW_ZONEMODEL;
delete from IFW_DISCOUNTRULE;
delete from IFW_DISCOUNTMASTER;
delete from IFW_ICPRODUCT_RATE;
delete from IFW_RATEPLAN;
delete from IFW_CALENDAR;
REM INSERTING into IFW_RUMGROUP
Insert into IFW_RUMGROUP (RUMGROUP,NAME,TYPE,ENTRYBY,ENTRYDATE,MODIFBY,MODIFDATE,MODIFIED,RECVER) values ('ServiceTelcoGprs_RumGroup','ServiceTelcoGprs_RumGroup','S',0,to_timestamp('23-FEB-09','DD-MON-RR HH.MI.SSXFF AM'),null,to_timestamp('23-FEB-09','DD-MON-RR HH.MI.SSXFF AM'),1,0);
Insert into IFW_RUMGROUP (RUMGROUP,NAME,TYPE,ENTRYBY,ENTRYDATE,MODIFBY,MODIFDATE,MODIFIED,RECVER) values ('ServiceTelcoGsmFax_RumGroup','ServiceTelcoGsmFax_RumGroup','S',0,to_timestamp('23-FEB-09','DD-MON-RR HH.MI.SSXFF AM'),null,to_timestamp('23-FEB-09','DD-MON-RR HH.MI.SSXFF AM'),1,0);
Insert into IFW_RUMGROUP (RUMGROUP,NAME,TYPE,ENTRYBY,ENTRYDATE,MODIFBY,MODIFDATE,MODIFIED,RECVER) values ('ServiceTelcoGsmSms_RumGroup','ServiceTelcoGsmSms_RumGroup','S',0,to_timestamp('23-FEB-09','DD-MON-RR HH.MI.SSXFF AM'),null,to_timestamp('23-FEB-09','DD-MON-RR HH.MI.SSXFF AM'),1,0);
Insert into IFW_RUMGROUP (RUMGROUP,NAME,TYPE,ENTRYBY,ENTRYDATE,MODIFBY,MODIFDATE,MODIFIED,RECVER) values ('ServiceSettlementRoamingOutcollect_RumGroup','ServiceSettlementRoamingOutcollect_RumGroup','S',0,to_timestamp('23-FEB-09','DD-MON-RR HH.MI.SSXFF AM'),null,to_timestamp('23-FEB-09','DD-MON-RR HH.MI.SSXFF AM'),1,0);
Insert into IFW_RUMGROUP (RUMGROUP,NAME,TYPE,ENTRYBY,ENTRYDATE,MODIFBY,MODIFDATE,MODIFIED,RECVER) values ('ServiceTelcoGsmData_RumGroup','ServiceTelcoGsmData_RumGroup','S',0,to_timestamp('23-FEB-09','DD-MON-RR HH.MI.SSXFF AM'),null,to_timestamp('23-FEB-09','DD-MON-RR HH.MI.SSXFF AM'),1,0);
Insert into IFW_RUMGROUP (RUMGROUP,NAME,TYPE,ENTRYBY,ENTRYDATE,MODIFBY,MODIFDATE,MODIFIED,RECVER) values ('Service_RumGroup','Service_RumGroup','S',0,to_timestamp('23-FEB-09','DD-MON-RR HH.MI.SSXFF AM'),null,to_timestamp('23-FEB-09','DD-MON-RR HH.MI.SSXFF AM'),1,0);
Insert into IFW_RUMGROUP (RUMGROUP,NAME,TYPE,ENTRYBY,ENTRYDATE,MODIFBY,MODIFDATE,MODIFIED,RECVER) values ('ServiceIpGprs_RumGroup','ServiceIpGprs_RumGroup','S',0,to_timestamp('23-FEB-09','DD-MON-RR HH.MI.SSXFF AM'),null,to_timestamp('23-FEB-09','DD-MON-RR HH.MI.SSXFF AM'),1,0);
Insert into IFW_RUMGROUP (RUMGROUP,NAME,TYPE,ENTRYBY,ENTRYDATE,MODIFBY,MODIFDATE,MODIFIED,RECVER) values ('ServiceTelcoGsmTelephony_RumGroup','ServiceTelcoGsmTelephony_RumGroup','S',0,to_timestamp('23-FEB-09','DD-MON-RR HH.MI.SSXFF AM'),null,to_timestamp('23-FEB-09','DD-MON-RR HH.MI.SSXFF AM'),1,0);
Insert into IFW_RUMGROUP (RUMGROUP,NAME,TYPE,ENTRYBY,ENTRYDATE,MODIFBY,MODIFDATE,MODIFIED,RECVER) values ('ServiceSettlementRoamingIncollect_RumGroup','ServiceSettlementRoamingIncollect_RumGroup','S',0,to_timestamp('23-FEB-09','DD-MON-RR HH.MI.SSXFF AM'),null,to_timestamp('23-FEB-09','DD-MON-RR HH.MI.SSXFF AM'),1,0);
Insert into IFW_RUMGROUP (RUMGROUP,NAME,TYPE,ENTRYBY,ENTRYDATE,MODIFBY,MODIFDATE,MODIFIED,RECVER) values ('ServiceWapInteractive_RumGroup','ServiceWapInteractive_RumGroup','S',0,to_timestamp('23-FEB-09','DD-MON-RR HH.MI.SSXFF AM'),null,to_timestamp('23-FEB-09','DD-MON-RR HH.MI.SSXFF AM'),1,0);
REM UPDATING into IFW_SERVICE
Update IFW_SERVICE Set RUMGROUP = 'ServiceWapInteractive_RumGroup' Where PIN_SERVICETYPE = '/service/wap/interactive';
Update IFW_SERVICE Set RUMGROUP = 'ServiceSettlementRoamingOutcollect_RumGroup' Where PIN_SERVICETYPE = '/service/settlement/roaming/outcollect';
Update IFW_SERVICE Set RUMGROUP = 'ServiceTelcoGsmTelephony_RumGroup' Where PIN_SERVICETYPE = '/service/telco/gsm/telephony';
Update IFW_SERVICE Set RUMGROUP = 'Service_RumGroup' Where PIN_SERVICETYPE = '/service';
Update IFW_SERVICE Set RUMGROUP = 'ServiceTelcoGprs_RumGroup' Where PIN_SERVICETYPE = '/service/telco/gprs';
Update IFW_SERVICE Set RUMGROUP = 'ServiceTelcoGsmData_RumGroup' Where PIN_SERVICETYPE = '/service/telco/gsm/data';
Update IFW_SERVICE Set RUMGROUP = 'ServiceSettlementRoamingIncollect_RumGroup' Where PIN_SERVICETYPE = '/service/settlement/roaming/incollect';
Update IFW_SERVICE Set RUMGROUP = 'ServiceTelcoGsmSms_RumGroup' Where PIN_SERVICETYPE = '/service/telco/gsm/sms';
Update IFW_SERVICE Set RUMGROUP = 'ServiceTelcoGsmFax_RumGroup' Where PIN_SERVICETYPE = '/service/telco/gsm/fax';
Update IFW_SERVICE Set RUMGROUP = 'ServiceIpGprs_RumGroup' Where PIN_SERVICETYPE = '/service/ip/gprs';
commit;
exit;
