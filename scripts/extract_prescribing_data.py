import pandas as pd

excel_file = "pca_icb_summary_tables_2024_25.xlsx"

# Inspect available sheets
xls = pd.ExcelFile(excel_file)
print("Available sheets:")
for sheet in xls.sheet_names:
    print("-", sheet)

# Export the first sheet for now
sheet_to_export = "SNOMED_Codes"

df = pd.read_excel(excel_file, sheet_name=sheet_to_export)

output_csv = "SNOMED_Codes.csv"
df.to_csv(output_csv, index=False)

print(f"\nExported '{sheet_to_export}' to {output_csv}")
print(f"Rows: {len(df):,}")
