# Auromita
# August 6, 2021
# Rename all files in folder. Present regex: change single-digit speaker ID in filename (e.g. f1_passage.wav) to double digit (f01_passage.wav)

Write-Output "Renamed these files:"
Get-ChildItem |
Foreach-Object {
    #$filename = '^F(?<spknum>.+)r(?<repnum>.+)\.wav$'
    $filename = 'f(?<number>.)_(?<rest>.+)\.(?<extension>.+)'
    if ($_.Name -cmatch $Filename){
        $oldname = $_.Name
        #$newname = 'f'+[regex]::escape($Matches.spknum)+'frame_rep'+[regex]::escape($Matches.repnum)+'.wav'
        $newname = 'f0'+[regex]::escape($Matches.number)+'_'+[regex]::escape($Matches.rest)+'.'+[regex]::escape($Matches.extension)
        $_.Name | Rename-Item -NewName {$_.Name -replace $filemane, $newname}
        Write-Output $oldname
    
    }
}


