Resp name :- HOLX - Order Management - SuperUser
Hold Name :- T - 1. EDI PRICING EXCEPTION
Issue Order :- 468878
New Order :- 8200904


1. Create the Order in Enter Status 
    
    Workflow            --No
    Business Event      --No 
    
2 Apply the Hold  in Enter status

    Workflow            --No
    Business Event      --No 

3. Booking Order is not possible as the hold will prevent from booking

    Workflow            --No
    Business Event      --No 

4  Release the Hold 

    Workflow 			--No
    Business Event 		--Yes
	
5  Book the Order (before applying manual Hold)

    Workflow 			--No
    Business Event 		--No

6 Apply the Hold  in Booked status

    Workflow            --No
    Business Event      --No 

select * from oe_order_headers_all where order_number='8181534';


        SELECT
            ooha.order_number,
            ooha.header_id,
            oh.line_id,
            ohd.hold_id,
            ohd.name           hold_name,
            ooha.ordered_date,
            ohs.released_flag,
            ooha.attribute2    contact_mail
        FROM
            oe_order_headers_all  ooha,
            oe_order_holds_all    oh,
            oe_hold_definitions   ohd,
            oe_hold_sources_all   ohs,
            fnd_lookup_values     flv
        WHERE
                1 = 1
            AND ooha.header_id = oh.header_id
            AND oh.hold_source_id = ohs.hold_source_id
            AND ohs.hold_id = ohd.hold_id
            AND ohd.name = flv.meaning --T - 1. EDI Pricing Exception
            AND flv.language = 'US'
            AND flv.lookup_type = 'HOLX_PRICING_HOLD_TYPE'
            AND ohs.released_flag = 'N'
            AND ooha.order_number = 8181534
            AND ooha.attribute2 IS NOT NULL
--            AND NOT EXISTS (
--                SELECT
--                    1
--                FROM
--                    wf_items
--                WHERE
--                        item_type = 'HOLEDINO'
--                    AND item_key = to_char(l_header_id)
--            );
;


select * from wf_deferred;

SELECT
(
SELECT
value
FROM
TABLE ( d.user_data.parameter_list ) t
WHERE
t.name = 'HEADER_ID'
) delivery_id,
d.*
FROM
wf_deferred d
WHERE 1=1
--d.state = 0
AND corrid like '%oracle.apps.ont.hold.action%';