^!c::  ; Ctrl + Alt + C
logFile := A_ScriptDir . "\conversion_log.txt"

; keep only the current session in the log
if FileExist(logFile)
    FileDelete, %logFile%

FileAppend, [%A_Now%] Conversion started.`n, %logFile%

selectedFiles := GetSelectedFiles()
if (selectedFiles = "")
{
    FileAppend, [%A_Now%] No files selected.`n, %logFile%
    return
}

Loop, Parse, selectedFiles, `n
{
    file := A_LoopField
    if (file = "")
        continue

    SplitPath, file, name, dir, ext, name_no_ext
    ext := "." . ext

    if (ext ~= "i)\.(mp4|mp3|webm|mkv|avi|mov|flv|wav|aac|wma|ts|3gp)")
    {
        outputFile := dir . "\" . name_no_ext . "_converted.mp3"

        ; always start fresh
        if FileExist(outputFile)
            FileDelete, %outputFile%

        command := "ffmpeg -y -hwaccel cuvid -i """ file """ -vn -ar 44100 -ac 1 -b:a 64k """ outputFile """"
        RunWait, %ComSpec% /c %command%, , Hide, exitCode

        if (exitCode = 0)
            FileAppend, [%A_Now%] SUCCESS: %file% converted to %outputFile%`n, %logFile%
        else
            FileAppend, [%A_Now%] ERROR: Failed to convert %file% (Exit Code: %exitCode%)`n, %logFile%
    }
    else
    {
        FileAppend, [%A_Now%] SKIPPED: %file% (unsupported format)`n, %logFile%
    }
}
FileAppend, [%A_Now%] Conversion finished.`n, %logFile%
return


GetSelectedFiles() {
    selected := ""
    for window in ComObjCreate("Shell.Application").Windows
    {
        try {
            if (InStr(window.Document.FocusedItem.Path, ":\"))
                for item in window.Document.SelectedItems
                    selected .= item.Path "`n"
        }
    }
    return RTrim(selected, "`n")
}
