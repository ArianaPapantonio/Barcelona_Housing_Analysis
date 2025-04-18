# Barcelona_Housing_Analysis

## 🧼 Data Cleaning Summary

The dataset was imported and cleaned in **Google Sheets**, using a structured approach with three dedicated tabs:

### 📄 Tabs Used:
- **Raw_data**: Original dataset as downloaded
- **Data_cleaning**: Summary table to track cleaning metrics
- **Cleaned_Data**: Final cleaned dataset, ready for SQL/Tableau analysis

### 🔍 Cleaning Steps Performed:
- ✅ **Removed 2 empty rows** from the bottom of the dataset
- ✅ Created a cleaning summary including:
  - Null values per column
  - Count of unique values
  - Sample of unique values (Top 10)
  - Duplicate detection (especially in `ID`)
- ✅ Applied `TRIM()` and `PROPER()` to standardize capitalization and remove extra spaces from text columns:
  - `Condition`, `Type`, `District`, `Neighborhood`, `Views`, `Lift`
- ✅ Verified numeric columns (`Price`, `Area_m2`, `Rooms`, `Floor_number`) contain only valid values
- ✅ Created new tab `Cleaned_Data` with all transformations applied using `ARRAYFORMULA`

The cleaned dataset was then exported as `.csv` and is ready for SQL import and further visualization in Tableau.
