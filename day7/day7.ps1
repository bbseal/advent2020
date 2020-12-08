# -- Part One
function getParentBags ($QueryBag) {
    foreach ($Rule in $Global:BagRules) {
        $RuleBag = $Rule.Split(" bags contain ")[0]
        $RuleBagContains = $Rule.Split("contain ")[1]
        if ($RuleBagContains -match $QueryBag) {
            $MatchPosition = $RuleBagContains.IndexOf("$QueryBag")-2
            $BagAdd = "" | Select-Object "Name","ParentContains"
            $BagAdd.Name = $RuleBag
            $BagAdd.ParentContains = $RuleBagContains.Substring($MatchPosition,1)
            if ($Global:ParentBags.Name -notcontains $BagAdd.Name) {
                $Global:ParentBags += $BagAdd
            }
            getParentBags $RuleBag
        }
    }
}

# -- Part Two
function getChildBags ($QueryBag, [Int]$NumBags) {
    foreach ($Rule in $Global:BagRules) {
        $RuleBag = $Rule.Split(" bags contain ")[0]
        $RuleBagContains = $Rule.Split("contain ")[1]
        if ($RuleBag -match $QueryBag) {
            $cSplit = $RuleBagContains.Split(", ")
            for ($i = 0; $i -lt $cSplit.Count; $i++) {
                $ChildBag = ($cSplit[$i] | Select-String -Pattern '\d (\D+ ){2}')
                if ($ChildBag) {
                    $ChildBag = $ChildBag.Matches.Value.Trim()
                    $cbSplit = $ChildBag.Split(" ")
                    $Global:ChildBagCount = $Global:ChildBagCount + (([Int]$cbSplit[0] * $NumBags))
                    getChildBags ($cbSplit[1] + " " + $cbSplit[2]) (([Int]$cbSplit[0]) * $NumBags)
                }
            }
        }
    }
}

Clear-Host
$Global:BagRules = Get-Content ".\day7\day7.txt"

# -- Part One
$Global:ParentBags = @()
getParentBags "shiny gold"
$Global:ParentBags.Count

# -- Part Two
$Global:ChildBagCount = 0
getChildBags "shiny gold" 1
$Global:ChildBagCount