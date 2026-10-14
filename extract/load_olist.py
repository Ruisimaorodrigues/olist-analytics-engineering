import duckdb
import csv
import logging
from pathlib import Path

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Caminho para os CSVs e para a base de dados
DATA_DIR = Path("C:/Users/ruisi/Downloads/Olist dataset")
DB_PATH = Path("C:/Users/ruisi/olist-analytics-engineering/transform/dev.duckdb")

# Mapeamento de ficheiro para nome de tabela no schema raw
TABLES = {
    "olist_orders_dataset.csv": "raw_orders",
    "olist_order_items_dataset.csv": "raw_order_items",
    "olist_customers_dataset.csv": "raw_customers",
    "olist_products_dataset.csv": "raw_products",
    "olist_sellers_dataset.csv": "raw_sellers",
    "olist_order_payments_dataset.csv": "raw_payments",
    "olist_order_reviews_dataset.csv": "raw_reviews",
    "olist_geolocation_dataset.csv": "raw_geolocation",
    "product_category_name_translation.csv": "raw_category_translation",
}

def load_csv_to_duckdb(conn, csv_path, table_name):
    """Carga idempotente — apaga e reinsere."""
    logger.info(f"A carregar {csv_path.name} -> {table_name}")
    conn.execute(f"DROP TABLE IF EXISTS {table_name}")
    conn.execute(f"""
        CREATE TABLE {table_name} AS
        SELECT * FROM read_csv_auto('{csv_path}', header=true)
    """)
    count = conn.execute(f"SELECT COUNT(*) FROM {table_name}").fetchone()[0]
    logger.info(f"  {count} linhas carregadas em {table_name}")
    return count

def main():
    conn = duckdb.connect(str(DB_PATH))
    
    total = 0
    for filename, table_name in TABLES.items():
        csv_path = DATA_DIR / filename
        if not csv_path.exists():
            logger.warning(f"Ficheiro não encontrado: {csv_path}")
            continue
        count = load_csv_to_duckdb(conn, csv_path, table_name)
        total += count
    
    logger.info(f"Carga concluída. Total de linhas: {total}")
    conn.close()

if __name__ == "__main__":
    main()