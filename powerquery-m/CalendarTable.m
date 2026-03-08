let
    // 1. ANCHOR: Get Today's Date inLocal Time
    
    Today = DateTime.Date(DateTime.FixedLocalNow()),
    CurrentYear = Date.Year(Today),
    
    // 2. RANGE: Calculate 3 full calendar years (Current, Current-1, Current-2)
    StartDate = #date(CurrentYear - 2, 1, 1), 
    EndDate = #date(CurrentYear, 12, 31),
    
    // 3. GENERATION: Create the list of dates
    DayCount = Duration.Days(Duration.From(EndDate - StartDate)) + 1,
    Source = List.Dates(StartDate, DayCount, #duration(1, 0, 0, 0)),
    TableFromList = Table.FromList(Source, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    RenamedDateColumn = Table.RenameColumns(TableFromList,{{"Column1", "Date"}}),
    SetDateType = Table.TransformColumnTypes(RenamedDateColumn,{{"Date", type date}}),

    // 4. TRANSFORM: Basic Date Parts
    AddYear = Table.AddColumn(SetDateType, "Year", each Date.Year([Date]), Int64.Type),
    AddQuarter = Table.AddColumn(AddYear, "Quarter", each "Q" & Text.From(Date.QuarterOfYear([Date])), type text),
    AddMonthNum = Table.AddColumn(AddQuarter, "Month Number", each Date.Month([Date]), Int64.Type),
    AddMonthName = Table.AddColumn(AddMonthNum, "Month Name", each Date.MonthName([Date]), type text),
    
    // 5. TRANSFORM: ISO Week Logic (Monday Start)
    AddWeekOfYear = Table.AddColumn(AddMonthName, "Week of Year", each Date.WeekOfYear([Date]), Int64.Type),
    AddISOWeekStart = Table.AddColumn(AddWeekOfYear, "ISO Week Start", each Date.StartOfWeek([Date], Day.Monday), type date),
    AddDayName = Table.AddColumn(AddISOWeekStart, "Day Name", each Date.DayOfWeekName([Date]), type text),
    
    // 6. TRANSFORM: Weekday Index (Monday = 0 for easier sorting/math)
    AddDayOfWeekNum = Table.AddColumn(AddDayName, "Day of Week Number", each Date.DayOfWeek([Date], Day.Monday), Int64.Type),
    
    // 7. ADD: Added Start of Month for easier grouping
    AddStartofMonth = Table.AddColumn(AddDayOfWeekNum,"Month Start Date", each Date.StartOfMonth([Date]), type date)
in
    AddStartofMonth
