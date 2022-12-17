-- 1a)
SELECT *,
CASE 
	WHEN (PRODUCT_NAME LIKE '%loan') OR (PRODUCT_NAME LIKE '%Loan') THEN 'Loan'
	WHEN PRODUCT_NAME IN ('Bank account or service', 'Mortgage', 'Debt collection',
	'Credit card', 'Credit reporting', 'Money transfers') THEN 'Service'
	ELSE 'Other'
AS  Finance_type

FROM AJ_CONSUMERS;


--1b) Optimized form of (1a):
-- N.B: 'DATA' inside {DB's, Tables} is case-sensitive; SQL Queries are not.
--N.B: In CASE stmt, DO NOT use Commas after every new case.
SELECT *,
CASE
	WHEN LOWER(PRODUCT_NAME)LIKE '%loan' THEN 'Loan'  --no 'Comma' after WHEN.
	WHEN LOWER(PRODUCT_NAME) IN ('bank account or service','mortgage','debt collection',
	'credit card','credit reporting','money transfers') THEN 'Service'
	ELSE 'Other'
END AS Finance_type --'END' keyword
FROM AJ_CONSUMER_COMPLAINTS;



--2)
SELECT *,
	CASE
	--Wrong way to check for NULL's: WHEN SUB_PRODUCT IN ('NULL', 'I do not know') THEN 'NA'
	WHEN (SUB_PRODUCT IS NULL) OR (lower(SUB_PRODUCT) = 'i do not know') THEN 'NA'
	WHEN lower(SUB_PRODUCT) LIKE '%loan' THEN 'LOAN'
	WHEN lower(SUB_PRODUCT) LIKE '%card' THEN 'CARD'
	WHEN lower(SUB_PRODUCT) LIKE '%mortage' THEN 'MORTGAGE'
	ELSE SUB_PRODUCT
	END AS SUB_PRODUCT_TYPE --'END' keyword
FROM AJ_CONSUMER_COMPLAINTS;


-- 3) 
SELECT *,
	CASE
	WHEN COMPANY_RESPONSE_TO_CONSUMER = 'Closed with explanation' THEN 'Explained'
	WHEN COMPANY_RESPONSE_TO_CONSUMER = 'Closed with monetary relief' THEN 'Monetary relief provided'
	WHEN COMPANY_RESPONSE_TO_CONSUMER IN ('Closed', 'Closed with non-monetary relief') THEN 'Closed'
	ELSE COMPANY_RESPONSE_TO_CONSUMER -- for 'Untimely response'
END AS Modified_Company_Response 
FROM AJ_CONSUMER_COMPLAINTS;


--4)Merging the results of multiple CASE stmts into a View:
CREATE OR REPLACE VIEW v_AJ_COMPANY_RESPONSE AS


----------------------------------------------------------17th Dec, 2022:
-- removing null rows from 3 cols ('sub_issue, comsuner_complaint, company'):
CREATE OR REPLACE VIEW RSM_complaints_view AS
SELECT *, 
STATE_NAME || '-' || ZIP_CODE AS NEW_STATE_DETAILS
WHERE 
(
SUB_ISSUE IS NOT NULL OR
COMPANY IS NOT NULL OR
CONSUMER_COMPLAINT_NARRATIVE IS NOT NULL
)
FROM "DEMO_DATABASE"."PUBLIC"."RSM_CONSUMER_COMPLAINTS";

