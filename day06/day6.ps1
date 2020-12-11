function partOne ($AllForms) {
    $GroupForm = @()
    $CountUnique = 0
    foreach ($Line in $AllForms) {
        if ($Line) {
            $GroupForm += $Line
        }
        else {
            # Group all the characters in the array and count the number of groups.
            $CountUnique += ($GroupForm.ToCharArray() | Group-Object | Select-Object Name).Count
            $GroupForm = @()
        }
    }
    return $CountUnique
}

function partTwo ($AllForms) {
    $GroupForm = @()
    $CountUnanimous = 0
    foreach ($Line in $AllForms) {
        if ($Line) {
            $GroupForm += $Line
        }
        else {
            # Start with the last line in the group and count the characters that appear in all the other lines.
            $GroupUnanimous = @()
            foreach ($StrChar in ($GroupForm[$GroupForm.Length-1].ToCharArray())) {
                $UnanimousChar = $true
                for ($i = 0; $i -lt $GroupForm.Length-1; $i++) {
                    if ($GroupForm[$i] -notmatch $StrChar) {
                        $UnanimousChar = $false
                        break
                    }
                }
                if ($UnanimousChar -eq $true) {
                    $GroupUnanimous += $StrChar
                }
            }
            $CountUnanimous += $GroupUnanimous.Count
            $GroupForm = @()
        }
    }
    return $CountUnanimous
}

Clear-Host

$AllForms = Get-Content ".\day6\day6.txt"

partOne $AllForms
partTwo $AllForms
