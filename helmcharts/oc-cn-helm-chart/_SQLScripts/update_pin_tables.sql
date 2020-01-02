-- -*-SQL-*-
-- ============================================================================
-- Script to Clean the BRM tables for mastering in PDC
-- ============================================================================
-- Version 1.00 - 08/27/2012
-- Kevin Lussie
-- ============================================================================
set echo on;
delete from config_beid_balances_t;
delete from config_beid_rules_t;
delete from config_rum_map_t;
delete from config_candidate_rums_t;
commit;

-- ============================================================================
-- Following SQL statements deletes sample /plan_list object from GROUP_T,
-- GROUP_PLANLIST_MEMBERS_T & GROUP_PLANLIST_CODE_T tables created during BRM installation.
-- ============================================================================
-- As BRM installation creates sample /plan_list, Customer center will not be able to recognize the 
-- /plan_list object with the same name created from Pricing Design Center.
-- ============================================================================
delete from group_t where poid_type = '/group/plan_list';
delete from au_group_t where poid_type = '/au_group/plan_list';
delete from group_planlist_members_t;
delete from au_group_planlist_members_t;
delete from group_planlist_code_t;
delete from au_group_planlist_code_t;
commit;

exit;
