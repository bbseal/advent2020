function getAdjOccupied ($Field, $SeatRow, $SeatColumn, $Radius) {
    $AdjOccupied = 0
    for ($i = -$Radius; $i -le $Radius; $i++) {
        for ($j = -$Radius; $j -le $Radius; $j++) {
            if ($i -ne 0 -or $j -ne 0) {
                $CheckRow = $SeatRow+$i
                $CheckColumn = $SeatColumn+$j
                if (($CheckRow -lt $Field.Count) -and ($CheckRow -ge 0) -and ($CheckColumn -lt $Field[$i].Length) -and ($CheckColumn -ge 0)) {
                    if ($Field[$SeatRow+$i][$SeatColumn+$j] -eq "#") {
                        $AdjOccupied++
                    }
                }
            }
        }
    }
    return $AdjOccupied
}

function updateField ($Field, $SeatLeaveThreshold, $OccupyRadius) {
    $NewField = @()
    $Changes = 0
    for ($i = 0; $i -lt $Field.Count; $i++) {
        $NewRow = ""
        for ($j = 0; $j -lt $Field[$i].Length; $j++) {
            if ($Field[$i][$j] -eq ".") {
                $NewRow = $NewRow + "."
            }
            else {
                $Occupied = getAdjOccupied $Field $i $j $OccupyRadius
                if ($Field[$i][$j] -eq "#") {
                    if ($Occupied -ge $SeatLeaveThreshold) {
                        $NewRow = $NewRow + "L"
                        $Changes++
                    }
                    else {
                        $NewRow = $NewRow + "#"
                    }
                }
                elseif ($Field[$i][$j] -eq "L") {
                    if ($Occupied -eq 0) {
                        $NewRow = $NewRow + "#"
                        $Changes++
                    }
                    else {
                        $NewRow = $NewRow + "L"
                    }
                }
                else {
                    throw "Field error."
                }
            }
        }
        $NewField += $NewRow
    }
    return $NewField, $Changes
}

function getNumChars ($Field, $Char) {
    $NumChars = 0
    for ($i = 0; $i -lt $Field.Count; $i++) {
        for ($j = 0; $j -lt $Field[$i].Length; $j++) {
            if ($Field[$i][$j] -eq $Char) {
                $NumChars++
            }
        }
    }
    return $NumChars
}


Clear-Host

$SeatLeaveThreshold = 4
$OccupyRadius = 1
$Field = Get-Content ".\day11\day11.txt"

$NewField = updateField $Field $SeatLeaveThreshold $OccupyRadius
do {
    $NewField = updateField $NewField[0] $SeatLeaveThreshold $OccupyRadius
} until ($NewField[1] -eq 0)
Write-Host "Part one: $(getNumChars $NewField[0] "#")"
