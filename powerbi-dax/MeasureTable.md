This measure table is designed to do two things:
    Document all columns and measures in the data model  
    Serve as the central measure table.

```
_Measure and Model Info = 

// create variables for each

VAR mea = INFO.VIEW.MEASURES()
VAR col = INFO.VIEW.COLUMNS()

RETURN 

// The segment column allows for a simple way to slice between measures and columns.

UNION(
// Combine the two tables into one
ADDCOLUMNS( 
    SUMMARIZE( mea, [Name], [DisplayFolder], [Table], [DataType], [DataCategory], [Description],[Expression]), "Segment", "Measures"),

// TMDL + a simple prompt to write descriptions is a great task for Copilot (or other AI methods) 

ADDCOLUMNS( 
    SUMMARIZE( col, [Name], [DisplayFolder], [Table], [DataType], [DataCategory], [Description],[Expression]), "Segment", "Columns"))

```