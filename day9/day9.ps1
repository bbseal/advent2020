function checkValidSum ($NumberRoll, $CheckNum) {
    $Valid = $false
    for ($i = 0; $i -lt $NumberRoll.Count; $i++) {
        for ($j = 0; $j -lt $NumberRoll.Count; $j++) {
            if ($j -ne $i) {
                if ($NumberRoll[$i] + $NumberRoll[$j] -eq $CheckNum) {
                    $Valid = $true
                    break
                }
            }
        }
    }
    return $Valid
}

function slideArray ($Array, $Value) {
    $NewArray = @()
    for ($i = 0; $i -lt $Array.Count-1; $i++) {
        $NewArray += $Array[$i+1]
    }
    $NewArray += $Value
    return $NewArray
}


Clear-Host
[long[]]$DataStream = Get-Content ".\day9\day9.txt"


# -- Part One
$RollLength = 25
$NumberRoll = @()

for ($i = 0; $i -lt $RollLength; $i++) {
    $NumberRoll += $DataStream[$i]
}
for ($i = $RollLength; $i -lt $DataStream.Count; $i++) {
    if (checkValidSum $NumberRoll $DataStream[$i] -eq $true) {
        $NumberRoll = slideArray $NumberRoll $DataStream[$i]
    }
    else {
        $FirstAddFail = $DataStream[$i]
        Write-Host "Part one: $FirstAddFail"
        break
    }
}


# -- Part Two
$Answer = 0
for ($i = 0; (($Answer -eq 0) -and ($i -lt $DataStream.Count)); $i++) {
    [long[]]$CurrentGroup = @()
    $CurrentGroup += $DataStream[$i]
    $GroupSum = $DataStream[$i]
    for ($j = $i+1; $GroupSum -lt $FirstAddFail; $j++) {
        $CurrentGroup += $DataStream[$j]
        $GroupSum += $DataStream[$j]
        if ($GroupSum -eq $FirstAddFail) {
            $Answer = $CurrentGroup | Measure-Object -AllStats
            Write-Host "Part two: $($Answer.Minimum + $Answer.Maximum)"
            break
        }
    }
}