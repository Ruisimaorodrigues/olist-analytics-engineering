import duckdb
import pandas as pd
from pathlib import Path

DB_PATH = 'C:/Users/ruisi/olist-analytics-engineering/transform/dev.duckdb'
OUTPUT_DIR = Path('C:/Users/ruisi/olist-analytics-engineering/powerbi_data')
OUTPUT_DIR.mkdir(exist_ok=True)

conn = duckdb.connect(DB_PATH)

tables = ['fct_orders', 'fct_order_items', 'fct_reviews', 'dim_customers', 'dim_products']

for table in tables:
    df = conn.execute(f"SELECT * FROM {table}").df()
    output_path = OUTPUT_DIR / f"{table}.csv"
    df.to_csv(output_path, index=False)
    print(f"Exportado {table}: {len(df)} linhas -> {output_path}")

conn.close()
print("Exportação concluída.")