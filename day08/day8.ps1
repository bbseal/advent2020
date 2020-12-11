function parseInstruction ($Position, [Switch]$Swap) {
    $Instruction = $Global:InstructionSet[$Position]
    if ($Instruction) {
        $InsAction = $Instruction.Split(" ")[0]
        $InsValue = $Instruction.Split(" ")[1]
        if ($Swap) {
            if (($InsAction -eq "nop") -and ($Position -notin $Global:TriedSwitchPositions) -and ($InsValue -notmatch '[-,+]0') -and ($Global:TriedSwitch -eq $false)) {
                $InsAction = "jmp"
                $Global:TriedSwitchPositions += $Position
                $Global:TriedSwitch = $true
            }
            elseif (($InsAction -eq "jmp") -and ($Position -notin $Global:TriedSwitchPositions) -and ($Global:TriedSwitch -eq $false)) {
                $InsAction = "nop"
                $Global:TriedSwitchPositions += $Position
                $Global:TriedSwitch = $true
            }
        }
        if ($InsAction -eq "nop") {
            $Position++
        }
        elseif ($InsAction -eq "acc") {
            $Global:Accumulator += [Int]$InsValue
            $Position++
        }
        elseif ($InsAction -eq "jmp") {
            $Position += [Int]$InsValue
        }
    }
    return $Position
}

Clear-Host
$Global:InstructionSet = Get-Content ".\day8\day8.txt"

# -- Part One
$Global:Accumulator = 0
$CurrentPosition = 0
$PositionHistory = @()
while ([Int]$CurrentPosition -notin $PositionHistory) {
    $PositionHistory += $CurrentPosition
    $CurrentPosition = parseInstruction $CurrentPosition
}
Write-Host "Part one: $Global:Accumulator"

# -- Part Two
$Global:TriedSwitchPositions = @()
do {
    $Global:Accumulator = 0
    $CurrentPosition = 0
    $PositionHistory = @()
    $Global:TriedSwitch = $false
    while ([Int]$CurrentPosition -notin $PositionHistory) {
        $PositionHistory += $CurrentPosition
        $CurrentPosition = parseInstruction $CurrentPosition -Swap
    }
} until ($CurrentPosition -ge $Global:InstructionSet.Count)
Write-Host "Part two: $Global:Accumulator"
