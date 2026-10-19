import duckdb

conn = duckdb.connect('C:/Users/ruisi/olist-analytics-engineering/transform/dev.duckdb')

fct = conn.execute("SELECT round(sum(total_payment_value), 2) FROM fct_orders").fetchone()[0]
stg = conn.execute("""
    SELECT round(sum(p.payment_value), 2)
    FROM stg_payments p
    JOIN stg_orders o ON p.order_id = o.order_id
    WHERE o.order_status = 'delivered'
""").fetchone()[0]

print(f"fct_orders revenue:  {fct}")
print(f"staging revenue:     {stg}")
print(f"diferença:           {round(fct - stg, 2)}")

conn.close()