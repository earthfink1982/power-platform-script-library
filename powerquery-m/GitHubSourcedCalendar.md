//Copy this m code script into a new blank query > advanced editor.  
//It will connect to the calendartable script in this repository and output a ready to use table.

let
    // 1. Fetch the raw binary from GitHub
    RawData = Web.Contents("https://raw.githubusercontent.com/earthfink1982/power-platform-script-library/refs/heads/main/powerquery-m/CalendarTable.m"),
    
    //2. Convert the binary to a single continuous text string
    
    ScriptText = Text.FromBinary(RawData),
    
    // 3. Evaluate the text string as M code
    
    EvaluatedScript = Expression.Evaluate(ScriptText, #shared)
in
    EvaluatedScript

    
