function consolidateMultilineData ($Data) {
    $Data = $Data.Replace("`r`n"," ").Replace("  ","`r`n").Split("`r`n")
    return $Data
}

function buildValidPassports ($PassportData, [Switch]$Strict) {
    $ValidPassports = @()
    foreach ($Line in $PassportData) {
        $Passport = "" | Select-Object "byr","iyr","eyr","hgt","hcl","ecl","pid","cid"

        # Birth year
        $PatternMatch = ($Line | Select-String -Pattern 'byr:(\S+)').Matches
        if ($PatternMatch) {
            $Passport.byr = $PatternMatch.Groups[1].Value
            if ($Strict) {
                [Int]$ValueCheck = $PatternMatch.Groups[1].Value
                if (($ValueCheck -lt 1920) -or ($ValueCheck -gt 2002)) {continue}
            }
        }
        else {continue}

        # Issue year
        $PatternMatch = ($Line | Select-String -Pattern 'iyr:(\S+)').Matches
        if ($PatternMatch) {
            $Passport.iyr = $PatternMatch.Groups[1].Value
            if ($Strict) {
                [Int]$ValueCheck = $PatternMatch.Groups[1].Value
                if (($ValueCheck -lt 2010) -or ($ValueCheck -gt 2020)) {continue}
            }
        }
        else {continue}

        # Expiration year
        $PatternMatch = ($Line | Select-String -Pattern 'eyr:(\S+)').Matches
        if ($PatternMatch) {
            $Passport.eyr = $PatternMatch.Groups[1].Value
            if ($Strict) {
                [Int]$ValueCheck = $PatternMatch.Groups[1].Value
                if (($ValueCheck -lt 2020) -or ($ValueCheck -gt 2030)) {continue}
            }
        }
        else {continue}

        # Height
        $PatternMatch = ($Line | Select-String -Pattern 'hgt:(\S+)').Matches
        if ($PatternMatch) {
            $Passport.hgt = $PatternMatch.Groups[1].Value
            if ($Strict) {
                $PatternMatch = ($PatternMatch.Groups[1].Value | Select-String -Pattern '^(\d+)(in|cm)$').Matches
                if ($PatternMatch) {
                    if ($PatternMatch.Groups[2].Value -eq "cm") {
                        if (([Int]$PatternMatch.Groups[1].Value -lt 150) -or ([Int]$PatternMatch.Groups[1].Value -gt 193)) {continue}
                    }
                    else {
                        if (([Int]$PatternMatch.Groups[1].Value -lt 59) -or ([Int]$PatternMatch.Groups[1].Value -gt 76)) {continue}
                    }
                }
                else {continue}
            }
        }
        else {continue}

        # Hair color
        $PatternMatch = ($Line | Select-String -Pattern 'hcl:(\S+)').Matches
        if ($PatternMatch) {
            $Passport.hcl = $PatternMatch.Groups[1].Value
            if ($Strict) {
                if ($PatternMatch.Groups[1].Value -notmatch '^#\w{6}$') {continue}
            }
        }
        else {continue}

        # Eye color
        $PatternMatch = ($Line | Select-String -Pattern 'ecl:(\S+)').Matches
        if ($PatternMatch) {
            $Passport.ecl = $PatternMatch.Groups[1].Value
            if ($Strict) {
                if ($PatternMatch.Groups[1].Value -notmatch '^(amb|blu|brn|gry|grn|hzl|oth)$') {continue}
            }
        }
        else {continue}

        # Passport ID
        $PatternMatch = ($Line | Select-String -Pattern 'pid:(\S+)').Matches
        if ($PatternMatch) {
            $Passport.pid = $PatternMatch.Groups[1].Value
            if ($Strict) {
                if ($PatternMatch.Groups[1].Value -notmatch '^\d{9}$') {continue}
            }
        }
        else {continue}

        # Country ID
        $PatternMatch = ($Line | Select-String -Pattern 'cid:(\S+)').Matches
        if ($PatternMatch) {
            $Passport.cid = $PatternMatch.Groups[1].Value
        }
        else {$Passport.cid = ""}
        $ValidPassports += $Passport
    }
    return $ValidPassports
}

Clear-Host
$PassportData = consolidateMultilineData $(Get-Content ".\day4\day4.txt" -Raw)

$ValidPassports = buildValidPassports $PassportData
Write-Host "Part one: $($ValidPassports.Count)"

$ValidPassports = buildValidPassports $PassportData -Strict
Write-Host "Part two: $($ValidPassports.Count)"
