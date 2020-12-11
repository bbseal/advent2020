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

function getOccupiedSeatCount ($Field, $SeatRow, $SeatColumn, $OccupyCheckType) {
    $OccupiedCount = 0
    $RowLimit = $Field.Count
    $ColumnLimit = $Field[0].Length

    if ($OccupyCheckType -eq "Adjacent") {
        for ($i = -1; $i -le 1; $i++) {
            for ($j = -1; $j -le 1; $j++) {
                if ($i -ne 0 -or $j -ne 0) {
                    $CheckRow = $SeatRow+$i
                    $CheckColumn = $SeatColumn+$j
                    if (($CheckRow -lt $RowLimit) -and ($CheckRow -ge 0) -and ($CheckColumn -lt $Field[$i].Length) -and ($CheckColumn -ge 0)) {
                        if ($Field[$SeatRow+$i][$SeatColumn+$j] -eq "#") {
                            $OccupiedCount++
                        }
                    }
                }
            }
        }
    }

    if ($OccupyCheckType -eq "Directional") {
        # Up
        for ($i = $SeatRow-1; $i -ge 0; $i--) {
            if ($Field[$i][$SeatColumn] -eq "#") {
                $OccupiedCount++
                break
            }
            if ($Field[$i][$SeatColumn] -eq "L") {
                break
            }
        }

        # Down
        for ($i = $SeatRow+1; $i -lt $RowLimit; $i++) {
            if ($Field[$i][$SeatColumn] -eq "#") {
                $OccupiedCount++
                break
            }
            if ($Field[$i][$SeatColumn] -eq "L") {
                break
            }
        }

        # Left
        for ($i = $SeatColumn-1; $i -ge 0; $i--) {
            if ($Field[$SeatRow][$i] -eq "#") {
                $OccupiedCount++
                break
            }
            if ($Field[$SeatRow][$i] -eq "L") {
                break
            }
        }

        # Right
        for ($i = $SeatColumn+1; $i -lt $ColumnLimit; $i++) {
            if ($Field[$SeatRow][$i] -eq "#") {
                $OccupiedCount++
                break
            }
            if ($Field[$SeatRow][$i] -eq "L") {
                break
            }
        }

        # Diagonal Up/Left
        $ColumnCheck = $SeatColumn-1
        for ($i = $SeatRow-1; (($i -ge 0) -and ($ColumnCheck -ge 0) -and ($i -lt $RowLimit) -and ($ColumnCheck -lt $ColumnLimit)); $i--) {
            if ($Field[$i][$ColumnCheck] -eq "#") {
                $OccupiedCount++
                break
            }
            elseif ($Field[$i][$ColumnCheck] -eq "L") {
                break
            }
            else {
                $ColumnCheck--
            }
        }

        # Diagonal Up/Right
        $ColumnCheck = $SeatColumn+1
        for ($i = $SeatRow-1; (($i -ge 0) -and ($ColumnCheck -ge 0) -and ($i -lt $RowLimit) -and ($ColumnCheck -lt $ColumnLimit)); $i--) {
            if ($Field[$i][$ColumnCheck] -eq "#") {
                $OccupiedCount++
                break
            }
            elseif ($Field[$i][$ColumnCheck] -eq "L") {
                break
            }
            else {
                $ColumnCheck++
            }
        }

        # Diagonal Down/Left
        $ColumnCheck = $SeatColumn-1
        for ($i = $SeatRow+1; (($i -ge 0) -and ($ColumnCheck -ge 0) -and ($i -lt $RowLimit) -and ($ColumnCheck -lt $ColumnLimit)); $i++) {
            if ($Field[$i][$ColumnCheck] -eq "#") {
                $OccupiedCount++
                break
            }
            elseif ($Field[$i][$ColumnCheck] -eq "L") {
                break
            }
            else {
                $ColumnCheck--
            }
        }

        # Diagonal Down/Right
        $ColumnCheck = $SeatColumn+1
        for ($i = $SeatRow+1; (($i -ge 0) -and ($ColumnCheck -ge 0) -and ($i -lt $RowLimit) -and ($ColumnCheck -lt $ColumnLimit)); $i++) {
            if ($Field[$i][$ColumnCheck] -eq "#") {
                $OccupiedCount++
                break
            }
            elseif ($Field[$i][$ColumnCheck] -eq "L") {
                break
            }
            else {
                $ColumnCheck++
            }
        }
    }
    return $OccupiedCount
}

function updateField {
    Param (
        $Field,
        $SeatLeaveThreshold,
        [ref]$Changes,
        [ValidateSet('Adjacent','Directional')][String]$OccupyCheckType
    )
    $NewField = @()
    for ($i = 0; $i -lt $Field.Count; $i++) {
        $NewRow = ""
        for ($j = 0; $j -lt $Field[$i].Length; $j++) {
            if ($Field[$i][$j] -eq ".") {
                $NewRow = $NewRow + "."
            }
            else {
                $Occupied = getOccupiedSeatCount $Field $i $j $OccupyCheckType
                if ($Field[$i][$j] -eq "#") {
                    if ($Occupied -ge $SeatLeaveThreshold) {
                        $NewRow = $NewRow + "L"
                        $Changes.Value++
                    }
                    else {
                        $NewRow = $NewRow + "#"
                    }
                }
                elseif ($Field[$i][$j] -eq "L") {
                    if ($Occupied -eq 0) {
                        $NewRow = $NewRow + "#"
                        $Changes.Value++
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
    return $NewField
}


Clear-Host

# -- Part One
$SeatLeaveThreshold = 4
$Field = Get-Content ".\day11\day11.txt"
do {
    $Changes = 0
    $Field = updateField $Field $SeatLeaveThreshold ([ref]$Changes) -OccupyCheckType Adjacent
} until ($Changes -eq 0)
Write-Host "Part one: $(getNumChars $Field "#")"


# -- Part Two
$SeatLeaveThreshold = 5
$Field = Get-Content ".\day11\day11.txt"
do {
    $Changes = 0
    $Field = updateField $Field $SeatLeaveThreshold ([ref]$Changes) -OccupyCheckType Directional
} until ($Changes -eq 0)
Write-Host "Part two: $(getNumChars $Field "#")"
