--metadb:function new_items_cataloged
CREATE OR REPLACE FUNCTION new_items_cataloged (
	start_date date DEFAULT '2000-01-01',
	end_date date DEFAULT '2050-01-01')
RETURNS TABLE(
	effective_location_name text,
	effective_call_number text,
	holdings_type_name text,
	cataloged_date date,
	index_title text,
	barcode text,
	administrative_note text) AS
$$
SELECT effective_location_name,
	   effective_call_number,
	   holdings_type_name,
	   cataloged_date,
	   index_title,
	   ihi.barcode,
	   ian.administrative_note
	 FROM folio_derived.items_holdings_instances AS ihi
	 LEFT JOIN folio_derived.item_ext AS ie ON ie.item_id = ihi.item_id
	 LEFT JOIN folio_derived.item_administrative_notes AS ian ON ie.item_id = ian.item_id
	 WHERE ihi.cataloged_date >= start_date
         AND ihi.cataloged_date < end_date
$$
LANGUAGE SQL
STABLE
PARALLEL SAFE;
