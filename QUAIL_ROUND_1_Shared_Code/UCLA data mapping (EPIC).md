# RAW_NDC (DISPENSING) 
    - med_dispense.EXT_DRUD_ID_STR

#  RAW_RX_MED_NAME (PRESCRIBING table) - 
    - coalesce(cm.name, cm.generic_name) as raw_rx_med_name from CLARITY_MEDICATION.NAME joining on  ORDER_MEDINFO.DISPENSABLE_MED_ID.
    - UCLA retained this approach after validation because ORDER_MED.MEDICATION_ID frequently mapped to template records ("ZZ IMS TEMPLATE") rather than the actual medication name.

# RAW_RXNORM_CUI (PRESCRIBING table) - For assistance, reach out to: Nebraska and Utah [pending]

# RAW_RX_NDC (PRESCRIBING table, populate with the full 11 digit NDC code whenever possible)- For assistance, reach out to:WashU, UC Davis, and UT Houston [pending]

# RAW_MEDADMIN_MED_NAME (MED_ADMIN table)- For assistance, reach out to: Allina and UT Southwestern [pending]
