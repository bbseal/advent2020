function getSeriesMultiplier ($Number) {
    $Series = @()
    $Series += 1
    $Series += 2
    $Series += 4

    if ($Number -lt 3) {
        return $Series[0]
    }
    elseif (($Number -eq 3) -or ($Number -eq 4)) {
        return $Series[$Number-2]
    }
    else {
        for ($i = 0; $i -lt $Number-4; $i++) {
            $Prev3Sum = ($Series | Measure-Object -Sum).Sum
            $NewArray = @()
            $NewArray += $Series[1]
            $NewArray += $Series[2]
            $NewArray += $Prev3Sum
            $Series = $NewArray
        }
        return $Series[2]
    }
}


Clear-Host

# -- Part One
[Int[]]$Adapters = @()
$Adapters += 0
$Adapters += Get-Content ".\day10\day10.txt"
$Adapters = $Adapters | Sort-Object
$Adapters += ($Adapters | Measure-Object -Maximum).Maximum + 3

$Add1Count = 0
$Add3Count = 0
for ($i = 0; $i -lt $Adapters.Count-1; $i++) {
    if ($Adapters[$i] + 1 -eq $Adapters[$i + 1]) {
        $Add1Count++
    }
    elseif (($Adapters[$i] + 3 -eq $Adapters[$i + 1])) {
        $Add3Count++
    }
    else {
        throw "Input error."
    }
}
Write-Host "Part one: $($Add1Count * $Add3Count)"


# -- Part Two
$i = 0
$Series = 1
[long]$Product = 1
do {
    if ($Adapters[$i]+1 -eq $Adapters[$i+1]) {
        $Series++
    }
    elseif ($i -eq $Adapters.Count) {
        $Product = $Product * $(getSeriesMultiplier $Series)
        break
    }
    else {
        $Product = $Product * $(getSeriesMultiplier $Series)
        $Series = 1
    }
$i++
} while ($i -lt $Adapters.Count)
Write-Host "Part two: $Product"
