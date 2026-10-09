import pandas as pd
from sqlalchemy import create_engine, text
import os

# =========================================================
# ADVENTURE WORKS - LOAD DATA INTO MYSQL
# =========================================================

USER = "root"
PASSWORD = input("Enter MySQL password: ")
HOST = "localhost"
DATABASE = "adventure_works_dw"

engine = create_engine(
    f"mysql+pymysql://{USER}:{PASSWORD}@{HOST}/{DATABASE}"
)

DATA_PATH = "data/cleaned"


# =========================================================
# TABLES
# =========================================================

tables = {
    "DimCustomer": "DimCustomer.csv",
    "DimProduct": "DimProduct.csv",
    "DimGeography": "DimGeography.csv",
    "DimSalesTerritory": "DimSalesTerritory.csv",
    "DimReseller": "DimReseller.csv",
    "DimEmployee": "DimEmployee.csv",
    "FactInternetSales": "FactInternetSales_cleaned.csv",
    "FactResellerSales": "FactResellerSales_cleaned.csv"
}


# =========================================================
# START
# =========================================================

print("=" * 70)
print("ADVENTURE WORKS - MYSQL DATA LOADING")
print("=" * 70)


# =========================================================
# LOAD TABLES
# =========================================================

for table_name, file_name in tables.items():

    file_path = os.path.join(
        DATA_PATH,
        file_name
    )

    print("\n" + "-" * 60)
    print(f"Loading table: {table_name}")

    if not os.path.exists(file_path):

        print(f"ERROR - File not found: {file_path}")
        continue

    df = pd.read_csv(file_path)

    # Replace NaN with None
    df = df.where(pd.notnull(df), None)

    print(f"Rows found: {len(df)}")

    try:

        df.to_sql(
            table_name,
            con=engine,
            if_exists="append",
            index=False,
            chunksize=1000
        )

        print(f"{table_name} loaded successfully.")

    except Exception as error:

        print(f"ERROR while loading {table_name}:")
        print(error)
        break


# =========================================================
# VERIFY ROW COUNTS
# =========================================================

print("\n" + "=" * 70)
print("VERIFYING DATABASE")
print("=" * 70)

with engine.connect() as connection:

    for table_name in tables.keys():

        result = connection.execute(
            text(f"SELECT COUNT(*) FROM {table_name}")
        )

        count = result.scalar()

        print(f"{table_name:<25} {count:,} rows")


print("\n" + "=" * 70)
print("DATA LOADING PROCESS COMPLETED")
print("=" * 70)