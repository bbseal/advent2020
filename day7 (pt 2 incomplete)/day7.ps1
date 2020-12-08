# -- Part One (Done)
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

# -- Part Two (Incomplete)
# -- Can't nail down out how to track the multipliers through the recursion...
function getChildBags ($QueryBag, [Int]$BagMultiplier, [Int]$ParentMultiplier) {
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
                    $Global:ChildBagCount += ([Int]$cbSplit[0] * $BagMultiplier * $ParentMultiplier)
                    #$ParentMultiplier = [Int]$cbSplit[0]
                    $ParentMultiplier = $BagMultiplier
                    if ($Global:rLevel -le 1) {
                        $ParentMultiplier = 1
                    }
                    else {
                        $ParentMultiplier = $BagMultiplier * $ParentMultiplier
                    }
                    if ($Rule.Split("contain ")[1] -ne "no other bags.") {
                        $Global:rLevel++
                        getChildBags ($cbSplit[1] + " " + $cbSplit[2]) ([Int]$cbSplit[0]) $ParentMultiplier
                    }
                }
                else {
                }
            }
        }
    }
}

$Global:BagRules = Get-Content ".\day7 (pt 2 incomplete)\day7.txt"


# -- Part One
$Global:ParentBags = @()
getParentBags "shiny gold"
$Global:ParentBags.Count


# -- Part Two
$Global:ChildBagCount = 0
$Global:rLevel = 1
#getChildBags "shiny gold" 1 1
#$Global:ChildBagCount + 1