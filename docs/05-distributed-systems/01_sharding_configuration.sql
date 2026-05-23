-- Create a Sharded Table (Requires Shard Catalog setup)
CREATE SHARDED TABLE customers (
    cust_id     NUMBER NOT NULL,
    cust_name   VARCHAR2(100),
    country     VARCHAR2(2),
    CONSTRAINT pk_customers PRIMARY KEY (cust_id, country)
)
PARTITION BY LIST (country) (
    PARTITION p_asia VALUES ('VN', 'JP', 'SG') TABLESPACE ts_asia,
    PARTITION p_euro VALUES ('FR', 'DE', 'UK') TABLESPACE ts_euro,
    PARTITION p_amer VALUES ('US', 'CA', 'BR') TABLESPACE ts_amer
);