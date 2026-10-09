import pandas as pd
import os

# =========================================================
# ADVENTURE WORKS - DATA CLEANING & ETL
# =========================================================

DATA_PATH = "data"
OUTPUT_PATH = "data/cleaned"

# Create cleaned-data folder
os.makedirs(OUTPUT_PATH, exist_ok=True)

print("=" * 70)
print("ADVENTURE WORKS - DATA CLEANING & ETL")
print("=" * 70)


# =========================================================
# 1. LOAD DIMENSION TABLES
# =========================================================

dim_file = os.path.join(DATA_PATH, "DimTables.xlsx")

excel_file = pd.ExcelFile(dim_file)

print("\nDimension Tables Found:")
print(excel_file.sheet_names)

dimension_tables = {}

for sheet in excel_file.sheet_names:

    df = pd.read_excel(
        dim_file,
        sheet_name=sheet
    )

    print("\n" + "-" * 60)
    print(f"Processing: {sheet}")
    print(f"Original rows: {len(df)}")

    # Remove completely empty rows
    df = df.dropna(how="all")

    # Remove completely identical duplicate rows
    df = df.drop_duplicates()

    # Clean column names
    df.columns = df.columns.str.strip()

    # Clean text columns
    for column in df.select_dtypes(include="object").columns:
        df[column] = df[column].astype(str).str.strip()

    dimension_tables[sheet] = df

    print(f"Cleaned rows: {len(df)}")

    # Save cleaned dimension table
    output_file = os.path.join(
        OUTPUT_PATH,
        f"{sheet}.csv"
    )

    df.to_csv(
        output_file,
        index=False
    )

    print(f"Saved: {output_file}")


# =========================================================
# 2. LOAD INTERNET SALES
# =========================================================

internet_file = os.path.join(
    DATA_PATH,
    "FactInternetSales.xlsx"
)

internet_sales = pd.read_excel(
    internet_file,
    sheet_name="FactInternetSales"
)

print("\n" + "=" * 70)
print("PROCESSING FACT INTERNET SALES")
print("=" * 70)

print(f"Original rows: {len(internet_sales)}")


# Remove completely empty rows
internet_sales = internet_sales.dropna(how="all")

# Remove rows with missing transaction keys
internet_sales = internet_sales.dropna(
    subset=[
        "SalesOrderNumber",
        "SalesOrderLineNumber"
    ]
)

# Remove completely identical duplicate rows
internet_sales = internet_sales.drop_duplicates()

# Clean column names
internet_sales.columns = internet_sales.columns.str.strip()


# =========================================================
# DATE CONVERSION
# =========================================================

date_columns = [
    "OrderDate",
    "DueDate",
    "ShipDate"
]

for column in date_columns:

    if column in internet_sales.columns:

        internet_sales[column] = pd.to_datetime(
            internet_sales[column],
            errors="coerce"
        )


# =========================================================
# NUMERIC CONVERSION
# =========================================================

internet_numeric_columns = [
    "OrderQuantity",
    "UnitPrice",
    "DiscountAmount",
    "TotalProductCost",
    "SalesAmount",
    "TaxAmt",
    "Freight"
]

for column in internet_numeric_columns:

    if column in internet_sales.columns:

        internet_sales[column] = pd.to_numeric(
            internet_sales[column],
            errors="coerce"
        )


# Save cleaned Internet Sales
internet_output = os.path.join(
    OUTPUT_PATH,
    "FactInternetSales_cleaned.csv"
)

internet_sales.to_csv(
    internet_output,
    index=False
)

print(f"Cleaned rows: {len(internet_sales)}")
print(f"Saved: {internet_output}")


# =========================================================
# 3. LOAD RESELLER SALES
# =========================================================

reseller_file = os.path.join(
    DATA_PATH,
    "FactResellerSales.xlsx"
)

reseller_sales = pd.read_excel(
    reseller_file,
    sheet_name="FactResellerSales"
)

print("\n" + "=" * 70)
print("PROCESSING FACT RESELLER SALES")
print("=" * 70)

print(f"Original rows: {len(reseller_sales)}")


# Remove completely empty rows
reseller_sales = reseller_sales.dropna(how="all")

# Remove rows with missing transaction keys
reseller_sales = reseller_sales.dropna(
    subset=[
        "SalesOrderNumber",
        "SalesOrderLineNumber"
    ]
)

# Remove completely identical duplicate rows
reseller_sales = reseller_sales.drop_duplicates()

# Clean column names
reseller_sales.columns = reseller_sales.columns.str.strip()


# =========================================================
# DATE CONVERSION
# =========================================================

for column in date_columns:

    if column in reseller_sales.columns:

        reseller_sales[column] = pd.to_datetime(
            reseller_sales[column],
            errors="coerce"
        )


# =========================================================
# NUMERIC CONVERSION
# =========================================================

reseller_numeric_columns = [
    "OrderQuantity",
    "UnitPrice",
    "DiscountAmount",
    "TotalProductCost",
    "SalesAmount",
    "TaxAmt",
    "Freight"
]

for column in reseller_numeric_columns:

    if column in reseller_sales.columns:

        reseller_sales[column] = pd.to_numeric(
            reseller_sales[column],
            errors="coerce"
        )


# Save cleaned Reseller Sales
reseller_output = os.path.join(
    OUTPUT_PATH,
    "FactResellerSales_cleaned.csv"
)

reseller_sales.to_csv(
    reseller_output,
    index=False
)

print(f"Cleaned rows: {len(reseller_sales)}")
print(f"Saved: {reseller_output}")


# =========================================================
# 4. FINAL SALES SUMMARY
# =========================================================

internet_total = internet_sales["SalesAmount"].sum()
reseller_total = reseller_sales["SalesAmount"].sum()

total_sales = internet_total + reseller_total

print("\n" + "=" * 70)
print("FINAL SALES SUMMARY")
print("=" * 70)

print(f"Internet Sales : {internet_total:,.2f}")
print(f"Reseller Sales : {reseller_total:,.2f}")
print(f"Total Sales    : {total_sales:,.2f}")

print("\n" + "=" * 70)
print("ETL PROCESS COMPLETED SUCCESSFULLY!")
print("=" * 70)

print(f"\nCleaned files are available in: {OUTPUT_PATH}")