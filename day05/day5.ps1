# https://adventofcode.com/2020/day/5
Clear-Host

$BoardingPasses = Get-Content ".\day5\day5.txt"

$SeatIDArray = @()

foreach ($Ticket in $BoardingPasses) {

    $TicketRowArray = $Ticket[0..6]
    $TicketColumnArray = $Ticket[7..9]

    $Row = 0
    $Column = 0

    for ($i = 0; $i -le 6; $i++) {
        if ($TicketRowArray[$i] -eq "B") {
            $Row = $Row + $([Math]::Pow(2,(6-$i)))
        }
    }

    for ($i = 0; $i -le 2; $i++) {
        if ($TicketColumnArray[$i] -eq "R") {
            $Column = $Column + $([Math]::Pow(2,(2-$i)))
        }
    }

    $SeatIDArray += ($Row*8)+$Column
}

$HighestSeatID = $SeatIDArray | Sort-Object -Descending | Select-Object -First 1
Write-Host $HighestSeatID

# -- Part Two

$LowestSeatID = $SeatIDArray | Sort-Object | Select-Object -First 1
$EmptySeats = @()
for ($i = $LowestSeatID; $i -le $HighestSeatID; $i++) {
    if ($SeatIDArray -notcontains $i) {
        $EmptySeats += $i
    }
}
Write-Host $EmptySeats