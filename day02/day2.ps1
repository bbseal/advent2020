Clear-Host
$PWDatabase = Get-Content ".\day2\day2.txt"

$Pt1ValidPWs = 0
$Pt2ValidPWs = 0
foreach ($Line in $PWDatabase) {
    $Pass = $Line.Split(": ")[1]
    $Char = $Line.Chars($Line.Split(": ")[0].Length-1)
    $CharRangeLower = [Int]($Line.Split(" ").Split("-")[0])
    $CharRangeUpper = [Int]($Line.Split(" ").Split("-")[1])
    $CharOccurrences = ($Pass.ToCharArray() | Select-String -Pattern $Char).Count
    if (($CharOccurrences -ge $CharRangeLower) -and ($CharOccurrences -le $CharRangeUpper)) {
        $Pt1ValidPWs++
    }
    if (($Pass[$CharRangeLower-1] -eq $Char) -or ($Pass[$CharRangeUpper-1] -eq $Char)) {
        if ($Pass[$CharRangeLower-1] -ne $Pass[$CharRangeUpper-1]) {
            $Pt2ValidPWs++
        }
    }
}
Write-Host "Part one: $Pt1ValidPWs"
Write-Host "Part two: $Pt2ValidPWs"
