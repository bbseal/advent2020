function partOne ($Instructions) {
    $xPos = 0
    $yPos = 0
    $Facing = 90

    foreach ($Instruction in $Instructions) {
        $InsMatch = ($Instruction | Select-String -Pattern '([NSEWLRF])(\d+)').Matches
        $Dir = $InsMatch.Groups[1].Value
        $Value = $InsMatch.Groups[2].Value
        Write-Debug "Ship: $xPos, $yPos   Facing: $Facing   Instruction: $Instruction."
        if ($Dir -eq "R") {
            $Facing = ($Facing + $Value) % 360
        }
        elseif ($Dir -eq "L") {
            $Facing = ($Facing - $Value) % 360
        }
        else {
            if ($Facing -lt 0) {
                $Facing = $Facing + 360
            }
            if (($Dir -eq "N") -or (($Dir -eq "F") -and (($Facing -eq 0) -or ($Facing -eq 360)))) {
                $yPos = $yPos + $Value
            }
            elseif (($Dir -eq "E") -or (($Dir -eq "F") -and ($Facing -eq 90))) {
                $xPos = $xPos + $Value
            }
            elseif (($Dir -eq "S") -or (($Dir -eq "F") -and ($Facing -eq 180))) {
                $yPos = $yPos - $Value
            }
            elseif (($Dir -eq "W") -or (($Dir -eq "F") -and ($Facing -eq 270))) {
                $xPos = $xPos - $Value
            }
            else {
                throw "Bad input."
            }
        }
    }

    $MDistance = [Math]::Abs($xPos) + [Math]::Abs($yPos)
    Write-Host "Part one: $MDistance"
}

function partTwo ($Instructions) {
    $ShipxPos = 0
    $ShipyPos = 0
    $WPRelxPos = 10
    $WPRelyPos = 1

    foreach ($Instruction in $Instructions) {
        $InsMatch = ($Instruction | Select-String -Pattern '([NSEWLRF])(\d+)').Matches
        $Dir = $InsMatch.Groups[1].Value
        $Value = $InsMatch.Groups[2].Value
        Write-Debug "Ship: $ShipxPos,$ShipyPos   Waypoint: $WPRelxPos,$WPRelyPos  Instruction: $Instruction."
        if ($Dir -eq "F") {
            $ShipxPos = $ShipxPos + ($WPRelxPos * $Value)
            $ShipyPos = $ShipyPos + ($WPRelyPos * $Value)
        }
        elseif ($Dir -eq "N") {
            $WPRelyPos = $WPRelyPos + $Value
        }
        elseif ($Dir -eq "S") {
            $WPRelyPos = $WPRelyPos - $Value
        }
        elseif ($Dir -eq "E") {
            $WPRelxPos = $WPRelxPos + $Value
        }
        elseif ($Dir -eq "W") {
            $WPRelxPos = $WPRelxPos - $Value
        }
        elseif (($Dir -eq "R") -or ($Dir -eq "L")) {
            if (($Instruction -eq "L90") -or ($Instruction -eq "R270")) {
                $NewXPos = -$WPRelyPos
                $NewYPos = $WPRelxPos
            }
            elseif (($Instruction -eq "L270") -or ($Instruction -eq "R90")) {
                $NewXPos = $WPRelyPos
                $NewYPos = -$WPRelxPos
            }
            elseif ($Value -eq 180) {
                $NewXPos = -$WPRelxPos
                $NewYPos = -$WPRelyPos
            }
            else {
                throw "Bad rotation."
            }
            $WPRelxPos = $NewXPos
            $WPRelyPos = $NewYPos
        }
        else {
            throw "Bad input."
        }
    }

    $MDistance = [Math]::Abs($ShipxPos) + [Math]::Abs($ShipyPos)
    Write-Host "Part two: $MDistance"
}


Clear-Host
$Instructions = Get-Content ".\day12\day12.txt"

partOne $Instructions
partTwo $Instructions
