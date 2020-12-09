function checkSlope ($Field, $Right, $Down) {
    $xPos = 0
    $Trees = 0
    for ($i = 0; $i -lt $Field.Count; $i++) {
        if ($i % $Down -eq 0) {
            $Line = $Field[$i]
            if ($Line[$xPos % $Line.Length] -eq "#") {
                $Trees++
            }
            $xPos = $xPos + $Right
        }
    }
    return $Trees
}

Clear-Host
$Field = Get-Content ".\day3\day3.txt"

Write-Host "Part one: $(checkSlope $Field 3 1)"

$Product = $(checkSlope $Field 1 1) * $(checkSlope $Field 3 1) * $(checkSlope $Field 5 1) * $(checkSlope $Field 7 1) * $(checkSlope $Field 1 2)
Write-Host "Part two: $Product"