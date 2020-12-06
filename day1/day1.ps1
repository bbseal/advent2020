function partOne ($Entries) {
    for ($i = 0; $i -lt $Entries.Length; $i++) {
        for ($x = 0; $x -lt $Entries.Length; $x++) {
            if ($i -ne $x) {
                if ($([Int]$Entries[$i] + [Int]$Entries[$x]) -eq 2020) {
                    Write-Host "Found two entries that sum to 2020:  $($Entries[$i]) and $($Entries[$x])."
                    $Product = [Int]$Entries[$i] * [Int]$Entries[$x]
                    return $Product
                }
            }
        }
    }
}

function partTwo ($Entries) {
    for ($i = 0; $i -lt $Entries.Length; $i++) {
        for ($x = 0; $x -lt $Entries.Length; $x++) {
            for ($y = 0; $y -lt $Entries.Length; $y++) {
                if (($i -ne $x) -and ($i -ne $y) -and ($x -ne $y)) {
                    if ($([Int]$Entries[$i] + [Int]$Entries[$x] + [Int]$Entries[$y]) -eq 2020) {
                        Write-Host "Found three entries that sum to 2020:  $($Entries[$i]), $($Entries[$x]), and $($Entries[$y])."
                        $Product = [Int]$Entries[$i] * [Int]$Entries[$x] * [Int]$Entries[$y]
                        return $Product
                    }
                }
            }
        }
    }
}

Clear-Host

$Entries = Get-Content ".\day1\day1.txt"

partOne $Entries
partTwo $Entries