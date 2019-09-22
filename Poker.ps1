$continue = "True"
$Preflopcontinue = "False"
$WhoFolded = ""
$playerStack = 5000
$computerStack = 5000
$BigBlind = 50
$SmallBlind = 25
$MoneyInPot = 0
$PlayerMoneyInPot = 0
$ComputerMoneyInPot = 0
$Turn = 0
$TurnBlind = 0
$HandStrength = 0
$StackHolder = 0
$PNumber1 = ""
$PSuit1 = ""
$PNumber2 = ""
$PSuit2 = ""
$CNumber1 = ""
$CSuit1 = ""
$CNumber2 = ""
$CSuit2 = ""
$response = ""
$StartGame = "False" 
$different = ""
$number = ""
$Suit = "" 
$Action = ""
$Amount = 0
$MinRaise = 0
$AllIn = 0
$CheckBack = “True”
$DataHolder = 0 
$AllInCheck = 0
$CallHolder = 0
$RaiseHolder = 0
$PotOdds = 0
$MaxBet = 0
$Random11 = 0
$MinBet = 0
$AllInHolder = 0
$Distance = 0
$PlayAgain = "True"
$Winnings = 0
$AfterFlopStrength = 0
$Flop1Number = 0
$Flop2Number = 0
$Flop3Number = 0
$Flop1Suit = ""
$Flop2Suit = ""
$Flop3Suit = ""
$TurnNumber = 0
$TurnSuit = ""
$RiverNumber = 0
$RiverSuit = ""
$NumberHolder1 = 0
$NumberHolder2 = 0
$SuitHolder1 = ""
$SuitHolder2 = ""
[system.collections.arraylist]$ComputerNumberArray
[system.collections.arraylist]$PlayerNumberArray
[system.collections.arraylist]$NumberArray
[system.collections.arraylist]$ComputerSuitArray
[system.collections.arraylist]$PlayerSuitArray
[system.collections.arraylist]$SuitArray
[system.collections.arraylist]$CardCheckArray
$ComputerHandStrengthOverall = 1
$PlayerHandStrengthOverall = 1 
$HighestCard = 0
$ComputerHighestCard = 0
$PlayerHighestCard = 0
$HolderNumber 
$HandStrengthHolder = 1
$CounterHolder = 0
$CheckTrue
$HighestCardFullHouse = 0
$StraightFlushHolder1 = 0
$StraightFlushHolder2 = 0
$StraightFlushHolder3 = 0
$StraightFlushHolder4 = 0
$StraightFlushHolder5 = 0
$HolderSuit
$IdenticalHolder = 0
$Flop1NumberHolder = 0
$Flop2NumberHolder = 0
$Flop3NumberHolder = 0
$TurnNumberHolder = 0
$RiverNumberHolder = 0
$RunOut = "False"
$Bet = "True"
$tholder = 1
$MoreInPot = 0

#This function chooses whether you would like to start a poker game or not
function new-poker 
{
    clear-host
	Write-Host "Welcome to the Powershell Poker Game"
	Write-Host "Starting Stack Size is `$$playerStack."
	Write-Host "Big Blind is `$$BigBlind. Small Blind is `$$SmallBlind”
    Write-Host "”
    Write-Host "Warning: Game may freeze up and glitch out, just wait 10-20 seconds and it will fix itself”

	while($startGame -eq "False") {
		$script:response = Read-Host "Would you like to play? (Y/N)"
        if ($response -eq "Y") {  
           	$script:startGame = "True"
        } 
        elseif ($response -eq "N") {  
            	exit  
        } 
    } 
} 

#This activates the poker game
function Play-Poker {

    clear-host
	$script:ComputerMoneyInPot = 0
	$script:PlayerMoneyInPot = 0
	$script:MoneyInPot = 0
	$script:Turn = 0
	$script:CheckBack = “True”
	$script:CounterHolder = 0
    $script:ComputerHandStrengthOverall = 1
    $script:PlayerHandStrengthOverall = 1
    $script:HighestCard = 0
    $script:AmountBet = 0
    $script:Bet = "True"
    $script:lltholder = 0
    $script:tholder = 0
    $script:MoreInPot = 0

	Collect-Blinds
	Deal-Hand
	Get-PlayerHand
    $Script:Turn = $TurnBlind 
	Get-ActionPreFlop

	if ($Turn -eq 2) {
		    Get-FoldResults
	}
    if ($Turn -ne 2) {
            $script:lltholder = 1
    }
    if (($lltholder -eq 1) -and ($tholder -eq 0)) {
            Read-Host "Press enter to get flop"
            Get-Flop
            if ($RunOut -eq "True") {
                Read-Host "Press enter to get turn"
                Get-Turn
                Read-Host "Press enter to get river"
                Get-River
                Check-PlayerHand
                Check-ComputerHandRiver
                Get-FinalResults
                $script:tholder = 1
            }
            if ($RunOut -eq "False") {
                $script:Turn = $TurnBlind
                $script:CheckBack = "True"
                Get-FlopAction
            }
            if ($Turn -eq 2) {
                Get-FoldResults
            }
            if ($Turn -ne 2) {
                $script:lltholder = 2
            }
    }
	if (($lltholder -eq 2) -and ($tholder -eq 0)) {
            Read-Host "Press enter to get turn"
            Get-Turn
            if ($RunOut -eq "True") {
                Read-Host "Press enter to get river"
                Get-River
                Check-PlayerHand
                Check-ComputerHandRiver
                Get-FinalResults
                $script:tholder = 1
            }
            if ($RunOut -eq "False") {
                $script:Turn = $TurnBlind
                $script:CheckBack = "True"
                Get-TurnAction
            }
            if ($Turn -eq 2) {
                Get-FoldResults
            }
            if ($Turn -ne 2) {
                $script:lltholder = 3
            }
    }
    if (($lltholder -eq 3) -and ($tholder -eq 0)) {
            Read-Host "Press enter to get river"
            Get-River
            $script:Turn = $TurnBlind
            $script:CheckBack = "True"
            Get-RiverAction
            if ($Turn -eq 2) {
                Get-FoldResults
            }
            if ($Turn -ne 2) {
                $script:lltholder = 4
            }
            Check-PlayerHand
            Check-ComputerHandRiver
            Get-FinalResults
    }
}

#Gets the results of the poker hand
function Get-FinalResults {
    if ($ComputerMoneyInPot -gt $PlayerMoneyInPot) {
        $script:MoreInPot = ($ComputerMoneyInPot - $PlayerMoneyInPot)
        $script:ComputerMoneyInPot = ($ComputerMoneyInPot - $MoreInPot)
        $script:MoneyInPot = ($MoneyInPot - $MoreInPot)
        $script:computerStack = ($computerStack + $MoreInPot)
    }
    if ($PlayerMoneyInPot -gt $ComputerMoneyInPot) {
        $script:MoreInPot = ($PlayerMoneyInPot - $ComputerMoneyInPot)
        $script:PlayerMoneyInPot = ($PlayerMoneyInPot - $MoreInPot)
        $script:MoneyInPot = ($MoneyInPot - $MoreInPot)
        $script:PlayerStack = ($PlayerStack + $MoreInPot)
    }
    if (($ComputerHandStrengthOverall -eq 1) -and ($ComputerHandStrengthOverall -eq $PlayerHandStrengthOverall)) {
        if ($CNumber1 -ge $CNumber2) {
            $script:ComputerHighestCard = $CNumber1
        }
        if ($CNumber1 -lt $CNumber2) {
            $script:ComputerHighestCard = $CNumber2
        }
        if ($PNumber1 -ge $PNumber2) {
            $script:PlayerHighestCard = $PNumber1
        }
        if ($PNumber1 -lt $PNumber2) {
            $script:PlayerHighestCard = $PNumber2
        }
    }
    if ($ComputerHandStrengthOverall -gt $PlayerHandStrengthOverall) {
        write-host ""
        write-host ""
        write-host "Opponent's Hand: $CNumber1 of $CSuit1        $CNumber2 of $CSuit2"
        write-host "Your Hand: $PNumber1 of $PSuit1        $PNumber2 of $PSuit2"
        write-host "The Flop is: $Flop1Number of $Flop1Suit    $Flop2Number of $Flop2Suit    $Flop3Number of $Flop3Suit"
        write-host "The Turn is: $TurnNumber of $TurnSuit"
        write-host "The River is: $RiverNumber of $RiverSuit"
        write-host ""
        $script:ComputerStack = ($computerStack + $MoneyInPot)
        write-host "Opponent wins `$$MoneyInPot"
        Write-Host "Opponent's stack is `$$ComputerStack"
        Write-Host "Your stack is `$$PlayerStack"
    }
    if ($PlayerHandStrengthOverall -gt $ComputerHandStrengthOverall) {
        write-host ""
        write-host ""
        write-host "Opponent's Hand: $CNumber1 of $CSuit1        $CNumber2 of $CSuit2"
        write-host "Your Hand: $PNumber1 of $PSuit1        $PNumber2 of $PSuit2"
        write-host "The Flop is: $Flop1Number of $Flop1Suit    $Flop2Number of $Flop2Suit    $Flop3Number of $Flop3Suit"
        write-host "The Turn is: $TurnNumber of $TurnSuit"
        write-host "The River is: $RiverNumber of $RiverSuit"
        write-host ""
        $script:PlayerStack = ($PlayerStack + $MoneyInPot)
        write-host "You win `$$MoneyInPot"
        Write-Host "Opponent's stack is `$$ComputerStack"
        Write-Host "Your stack is `$$PlayerStack"
    }
    if (($ComputerHandStrengthOverall -eq $PlayerHandStrengthOverall) -and ($ComputerHighestCard -gt $PlayerHighestCard)) {
        write-host ""
        write-host ""
        write-host "Opponent's Hand: $CNumber1 of $CSuit1        $CNumber2 of $CSuit2"
        write-host "Your Hand: $PNumber1 of $PSuit1        $PNumber2 of $PSuit2"
        write-host "The Flop is: $Flop1Number of $Flop1Suit    $Flop2Number of $Flop2Suit    $Flop3Number of $Flop3Suit"
        write-host "The Turn is: $TurnNumber of $TurnSuit"
        write-host "The River is: $RiverNumber of $RiverSuit"
        write-host ""
        $script:ComputerStack = ($computerStack + $MoneyInPot)
        write-host "Opponent wins `$$MoneyInPot"
        Write-Host "Opponent's stack is `$$ComputerStack"
        Write-Host "Your stack is `$$PlayerStack"
    }
    if (($PlayerHandStrengthOverall -eq $ComputerHandStrengthOverall) -and ($PlayerHighestCard -gt $ComputerHighestCard)) {
        write-host ""
        write-host ""
        write-host "Opponent's Hand: $CNumber1 of $CSuit1        $CNumber2 of $CSuit2"
        write-host "Your Hand: $PNumber1 of $PSuit1        $PNumber2 of $PSuit2"
        write-host "The Flop is: $Flop1Number of $Flop1Suit    $Flop2Number of $Flop2Suit    $Flop3Number of $Flop3Suit"
        write-host "The Turn is: $TurnNumber of $TurnSuit"
        write-host "The River is: $RiverNumber of $RiverSuit"
        write-host ""
        $script:PlayerStack = ($PlayerStack + $MoneyInPot)
        write-host "You win `$$MoneyInPot"
        Write-Host "Opponent's stack is `$$ComputerStack"
        Write-Host "Your stack is `$$PlayerStack"
    }
    if (($PlayerHandStrengthOverall -eq $ComputerHandStrengthOverall) -and ($PlayerHighestCard -eq $ComputerHighestCard)) {
        write-host ""
        write-host ""
        write-host "Opponent's Hand: $CNumber1 of $CSuit1        $CNumber2 of $CSuit2"
        write-host "Your Hand: $PNumber1 of $PSuit1        $PNumber2 of $PSuit2"
        write-host "The Flop is: $Flop1Number of $Flop1Suit    $Flop2Number of $Flop2Suit    $Flop3Number of $Flop3Suit"
        write-host "The Turn is: $TurnNumber of $TurnSuit"
        write-host "The River is: $RiverNumber of $RiverSuit"
        write-host ""
        $script:PlayerStack = ($PlayerStack + ($MoneyInPot/2))
        $script:ComputerStack = ($computerStack + ($MoneyInPot/2))
        write-host "You and your opponent push"
        Write-Host "Opponent's stack is `$$ComputerStack"
        Write-Host "Your stack is `$$PlayerStack"
    }
}

#Gets the action on the river
function Get-RiverAction {
    if (($Bet -eq "True") -and ($Turn -ne 0)) {
        $script:Bet = "False"
        $script:Random11 = get-random -Maximum 10 -Minimum 1
        if ($Random11 -lt 3) {
            write-host "Opponent Checked"
            $script:Turn = 0
            $script:CheckBack = "false"
        }
        if ($Random11 -ge 3) {
            if ($Random11 -eq 3) {
                $script:AmountBet = [math]::Round($MoneyInPot/6)
            }
            if ($Random11 -eq 4) {
                $script:AmountBet = [math]::Round($MoneyInPot/5)
            }
            if ($Random11 -eq 5) {
                $script:AmountBet = [math]::Round((5*$MoneyInPot)/4)
            }
            if ($Random11 -eq 6) {
                $script:AmountBet = [math]::Round((3*$MoneyInPot)/4)
            }
            if ($Random11 -eq 7) {
                $script:AmountBet = [math]::Round($MoneyInPot/2)
            }
            if ($Random11 -eq 8) {
                $script:AmountBet = [math]::Round($MoneyInPot/3)
            }
            if ($Random11 -eq 9) {
                $script:AmountBet = [math]::Round($MoneyInPot/4)
            }
            if ($AmountBet -ge $computerStack) {
                Write-Host “Opponent went all in."
                $script:AmountBet = ($AmountBet - ($AmountBet - $computerStack))
                $script:MoneyInPot = $MoneyInPot + $AmountBet
                $script:ComputerMoneyInPot = $ComputerMoneyInPot + $AmountBet
                $script:ComputerStack = $computerStack - $AmountBet
                Write-Host "The total pot size is `$$MoneyInPot"
            }
            if ($AmountBet -lt $computerStack) {
                Write-Host "Opponent bet `$$AmountBet"
                $script:MoneyInPot = $MoneyInPot + $AmountBet
                $script:ComputerMoneyInPot = $ComputerMoneyInPot + $AmountBet
                $script:ComputerStack = $computerStack - $AmountBet
                Write-Host "The total pot size is `$$MoneyInPot"
            }
            $script:Turn = 0
            $script:CheckBack = "false"
        }
    }

	if ($Turn -eq 1) { 
		Run-ComputerActionRiver
        $script:Bet = "False"
	}
    if ($Turn -eq 0) {
        Run-PlayerActionOverall
        $script:Bet = "False"
    }
    if (($Turn -eq 1) -or ($Turn -eq 0)) {
        Get-TurnAction
        $script:Bet = "False"
    }
}

#Gets the action on the turn
function Get-TurnAction {
    if (($Bet -eq "True") -and ($Turn -ne 0)) {
        $script:Bet = "False"
        $script:Random11 = get-random -Maximum 10 -Minimum 1
        if ($Random11 -lt 4) {
            write-host "Opponent Checked"
            $script:Turn = 0
            $script:CheckBack = "false"
        }
        if ($Random11 -ge 4) {
            if ($Random11 -eq 4) {
                $script:AmountBet = [math]::Round($MoneyInPot/5)
            }
            if ($Random11 -eq 5) {
                $script:AmountBet = [math]::Round((5*$MoneyInPot)/4)
            }
            if ($Random11 -eq 6) {
                $script:AmountBet = [math]::Round((3*$MoneyInPot)/4)
            }
            if ($Random11 -eq 7) {
                $script:AmountBet = [math]::Round($MoneyInPot/2)
            }
            if ($Random11 -eq 8) {
                $script:AmountBet = [math]::Round($MoneyInPot/3)
            }
            if ($Random11 -eq 9) {
                $script:AmountBet = [math]::Round($MoneyInPot/4)
            }
            if ($AmountBet -ge $computerStack) {
                Write-Host “Opponent went all in."
                $script:AmountBet = ($AmountBet - ($AmountBet - $computerStack))
                $script:MoneyInPot = $MoneyInPot + $AmountBet
                $script:ComputerMoneyInPot = $ComputerMoneyInPot + $AmountBet
                $script:ComputerStack = $computerStack - $AmountBet
                Write-Host "The total pot size is `$$MoneyInPot"
            }
            if ($AmountBet -lt $computerStack) {
                Write-Host "Opponent bet `$$AmountBet"
                $script:MoneyInPot = $MoneyInPot + $AmountBet
                $script:ComputerMoneyInPot = $ComputerMoneyInPot + $AmountBet
                $script:ComputerStack = $computerStack - $AmountBet
                Write-Host "The total pot size is `$$MoneyInPot"
            }
            $script:Turn = 0
            $script:CheckBack = "false"
        }
    }

	if ($Turn -eq 1) { 
		Run-ComputerActionTurn
        $script:Bet = "False"
	}
    if ($Turn -eq 0) {
        Run-PlayerActionOverall
        $script:Bet = "False"
    }
    if (($Turn -eq 1) -or ($Turn -eq 0)) {
        Get-TurnAction
        $script:Bet = "False"
    }
}

#Gets the action on the flop
function Get-FlopAction {
    if (($Bet -eq "True") -and ($Turn -ne 0)) {
        $script:Bet = "False"
        $script:Random11 = get-random -Maximum 10 -Minimum 1
        if ($Random11 -lt 6) {
            write-host "Opponent Checked"
            $script:Turn = 0
            $script:CheckBack = "false"
        }
        if ($Random11 -ge 6) {
            if ($Random11 -eq 6) {
                $script:AmountBet = [math]::Round((3*$MoneyInPot)/4)
            }
            if ($Random11 -eq 7) {
                $script:AmountBet = [math]::Round($MoneyInPot/2)
            }
            if ($Random11 -eq 8) {
                $script:AmountBet = [math]::Round($MoneyInPot/3)
            }
            if ($Random11 -eq 9) {
                $script:AmountBet = [math]::Round($MoneyInPot/4)
            }
            if ($AmountBet -ge $computerStack) {
                Write-Host “Opponent went all in."
                $script:AmountBet = ($AmountBet - ($AmountBet - $computerStack))
                $script:MoneyInPot = $MoneyInPot + $AmountBet
                $script:ComputerMoneyInPot = $ComputerMoneyInPot + $AmountBet
                $script:ComputerStack = $computerStack - $AmountBet
                Write-Host "The total pot size is `$$MoneyInPot"
            }
            if ($AmountBet -lt $computerStack) {
                Write-Host "Opponent bet `$$AmountBet"
                $script:MoneyInPot = $MoneyInPot + $AmountBet
                $script:ComputerMoneyInPot = $ComputerMoneyInPot + $AmountBet
                $script:ComputerStack = $computerStack - $AmountBet
                Write-Host "The total pot size is `$$MoneyInPot"
            }
            $script:Turn = 0
            $script:CheckBack = "false"
        }
    }

	if ($Turn -eq 1) { 
		Run-ComputerActionFlop
        $script:Bet = "False"
	}
    if ($Turn -eq 0) {
        Run-PlayerActionOverall
        $script:Bet = "False"
    }
    if (($Turn -eq 1) -or ($Turn -eq 0)) {
        Get-FlopAction
        $script:Bet = "False"
    }
}

#Gets the computer flop action
function Run-ComputerActionFlop { 
    Check-ComputerHandFlop
    $script:CallHolder = ($PlayerMoneyInPot - $ComputerMoneyInPot)
    $script:PotOdds = $CallHolder/$MoneyInPot

    if ($ComputerHandStrengthOverall -eq 1) {
        Computer-Flop0
    }
    if ($ComputerHandStrengthOverall -eq 2) {
	    Computer-Flop1
    }
    if ($ComputerHandStrengthOverall -ge 3) {
	    Computer-Flop2
    }
}

#Gets the computer turn action
function Run-ComputerActionTurn { 
    Check-ComputerHandTurn
    $script:CallHolder = ($PlayerMoneyInPot - $ComputerMoneyInPot)
    $script:PotOdds = $CallHolder/$MoneyInPot

    if ($ComputerHandStrengthOverall -eq 1) {
        Computer-Flop0
    }
    if ($ComputerHandStrengthOverall -eq 2) {
	    Computer-Flop1
    }
    if ($ComputerHandStrengthOverall -ge 3) {
	    Computer-Flop2
    }
}

#Gets the computer river action
function Run-ComputerActionRiver { 
    Check-ComputerHandRiver
    $script:CallHolder = ($PlayerMoneyInPot - $ComputerMoneyInPot)
    $script:PotOdds = $CallHolder/$MoneyInPot

    if ($ComputerHandStrengthOverall -eq 1) {
        Computer-Flop0
    }
    if ($ComputerHandStrengthOverall -eq 2) {
	    Computer-Flop1
    }
    if ($ComputerHandStrengthOverall -ge 3) {
	    Computer-Flop2
    }
}

function Computer-Flop0 {
    if ($CallHolder -eq 0) {
        $script:Random11 = get-random -Maximum 10 -Minimum 1
        if ($Random11 -lt 6) {
            $script:CallHolder = 0
        }
        if ($Random11 -ge 6) {
            if ($Random11 -eq 6) {
                $script:CallHolder = [math]::Round(304/8)
            }
            if ($Random11 -eq 7) {
                $script:CallHolder = [math]::Round(99/3)
            }
            if ($Random11 -eq 8) {
                $script:CallHolder = [math]::Round(115/5)
            }
            if ($Random11 -eq 9) {
                $script:CallHolder = [math]::Round(120/6)
            }
            $script:CheckBack = "True"
        }
    }
	if (($CallHolder -lt 150) -or ($PotOdds -lt .3)) {
       		$script:MoneyInPot = $MoneyInPot + $CallHolder
            $script:ComputerMoneyInPot = $ComputerMoneyInPot + $CallHolder
            $script:ComputerStack = $computerStack - $CallHolder
        	if ($computerStack -gt 0) {
                        Write-Host “Opponent called `$$CallHolder to make the total pot size `$$MoneyInPot"
                        Write-Host “Opponent’s remaining stack size is `$$computerStack"
        	}
       		if ($computerStack -le 0) {
                       	Write-Host “Opponent went all in."
                        $script:AllInHolder = [math]::abs($ComputerStack)
                        $script:MoneyInPot = $MoneyInPot - $AllInHolder
                        $script:ComputerMoneyInPot = $ComputerMoneyInPot - $AllInHolder
                        $script:ComputerStack = 0
                        Write-Host "The total pot size is `$$MoneyInPot"
                        $script:RunOut = "True"
  		    }
        	if ($CheckBack -eq “False”) {
                        $script:Turn = 3
       		}
        	if ($CheckBack -eq “True”) {
                        $script:Turn = 0
                        $script:CheckBack = “False”
        	}

	}
	else {
		$script:Turn = 2
		$script:WhoFolded = "Computer"
	}
}

function Computer-Flop1 {
    if ($CallHolder -lt 25) {
        $script:Random11 = get-random -Maximum 10 -Minimum 1
            if ($Random11 -eq 1) {
                $script:CallHolder = 35
            }
            if ($Random11 -eq 2) {
                $script:CallHolder = 65
            }
            if ($Random11 -eq 3) {
                $script:CallHolder = 185
            }
            if ($Random11 -eq 4) {
                $script:CallHolder = 100
            }
            if ($Random11 -eq 5) {
                $script:CallHolder = 213
            }
            if ($Random11 -eq 6) {
                $script:CallHolder = 57
            }
            if ($Random11 -eq 7) {
                $script:CallHolder = 125
            }
            if ($Random11 -eq 8) {
                $script:CallHolder = 75
            }
            if ($Random11 -eq 9) {
                $script:CallHolder = 250
            }
        $script:CheckBack = "True"
    }
	if (($CallHolder -lt 500) -or ($PotOdds -lt 1.3)) {
       		$script:MoneyInPot = $MoneyInPot + $CallHolder
            $script:ComputerMoneyInPot = $ComputerMoneyInPot + $CallHolder
            $script:ComputerStack = $computerStack - $CallHolder
        	if ($computerStack -gt 0) {
                        Write-Host “Opponent called `$$CallHolder to make the total pot size `$$MoneyInPot"
                        Write-Host “Opponent’s remaining stack size is `$$computerStack"
        	}
       		if ($computerStack -le 0) {
                       	Write-Host “Opponent went all in."
                        $script:AllInHolder = [math]::abs($ComputerStack)
                        $script:MoneyInPot = $MoneyInPot - $AllInHolder
                        $script:ComputerMoneyInPot = $ComputerMoneyInPot - $AllInHolder
                        $script:ComputerStack = 0
                        Write-Host "The total pot size is `$$MoneyInPot"
                        $script:RunOut = "True"
  		    }
        	if ($CheckBack -eq “False”) {
                        $script:Turn = 3
       		}
        	if ($CheckBack -eq “True”) {
                        $script:Turn = 0
                        $script:CheckBack = “False”
        	}

	}
	else {
		$script:Turn = 2
		$script:WhoFolded = "Computer"
	}
}

function Computer-Flop2 {
    if ($CallHolder -lt 30) {
        $script:Random11 = get-random -Maximum 10 -Minimum 1
            if ($Random11 -eq 1) {
                $script:CallHolder = 65
            }
            if ($Random11 -eq 2) {
                $script:CallHolder = 115
            }
            if ($Random11 -eq 3) {
                $script:CallHolder = 85
            }
            if ($Random11 -eq 4) {
                $script:CallHolder = 100
            }
            if ($Random11 -eq 5) {
                $script:CallHolder = 135
            }
            if ($Random11 -eq 6) {
                $script:CallHolder = 145
            }
            if ($Random11 -eq 7) {
                $script:CallHolder = 225
            }
            if ($Random11 -eq 8) {
                $script:CallHolder = 75
            }
            if ($Random11 -eq 9) {
                $script:CallHolder = 70
            }
            $script:CheckBack = "True"
    }
	$script:StackHolder = $ComputerStack/2
	$script:Random11 = get-random -minimum 1 -maximum 4
	$script:CheckAllInPossible = "True"

    $script:AllInCheck1 = ($ComputerMoneyInPot - $PlayerMoneyInPot) + $ComputerStack
    if ($AllInCheck1 -gt $PlayerStack) {
      	$script:CheckAllInPossible = "False"
	    $script:AllInCheck1 = $AllInCheck1 - ($AllInCheck1 - $PlayerStack)
    }

	if ($CallHolder -ge $StackHolder) {
		if ($CallHolder -lt $ComputerStack) {
                $script:Turn = 0
                $script:CheckBack = “False”
        	}
       	if ($CallHolder -eq $ComputerStack) {
                $script:Turn = 3
     		}
		if ($CheckAllInPossible -eq "True") {
			    $script:CallHolder = $computerStack
			    Write-Host "Opponent went all in."
			    $script:ComputerStack = $ComputerStack - $CallHolder	
                $script:RunOut = "True"
		}
		if ($CheckAllInPossible -eq "False") {
			    $script:CallHolder = $AllInCheck1
			    Write-Host "Opponent raised to $CallHolder."
			    $script:ComputerStack = $ComputerStack - $CallHolder
			    Write-Host "Opponents stack size `$$ComputerStack"
		}
                
        $script:MoneyInPot = $MoneyInPot + $CallHolder
        $script:ComputerMoneyInPot = $ComputerMoneyInPot + $CallHolder
        Write-Host "The total pot size is `$$MoneyInPot"
	}

	else {
		if ($CallHolder -gt 750) {
			$script:Random11 = 1
		}
		if (($Random11 -eq 1) -or ($Random11 -eq 3)) {
       			    $script:MoneyInPot = $MoneyInPot + $CallHolder
                	$script:ComputerMoneyInPot = $ComputerMoneyInPot + $CallHolder
               		$script:ComputerStack = $computerStack - $CallHolder
        		if ($computerStack -gt 0) {
                        Write-Host “Opponent called `$$CallHolder to make the total pot size `$$MoneyInPot"
                       	Write-Host “Opponent’s remaining stack size is `$$computerStack"
        		}
       			if ($computerStack -le 0) {
                       	Write-Host “Opponent went all in."
                        $script:AllInHolder = [math]::abs($ComputerStack)
                        $script:MoneyInPot = $MoneyInPot - $AllInHolder
                        $script:ComputerMoneyInPot = $ComputerMoneyInPot - $AllInHolder
                        $script:ComputerStack = 0
                        Write-Host "The total pot size is `$$MoneyInPot"
                        $script:RunOut = "True"
  			    }
        		if ($CheckBack -eq “False”) {
                        	$script:Turn = 3
       			}
        		if ($CheckBack -eq “True”) {
                        	$script:Turn = 0
                        	$script:CheckBack = “False”
        		}
		}
		if ($Random11 -eq 2) {
			$script:RandomRaiseRate = get-random -minimum 1 -maximum 6
			$script:RaiseHolder = $CallHolder * 2
			if ($RandomRaiseRate -lt 3) {
				$script:RaiseHolder = [math]::Round($RaiseHolder * ($RandomRaiseRate/3))
			}
       			$script:MoneyInPot = $MoneyInPot + $RaiseHolder
                	$script:ComputerMoneyInPot = $ComputerMoneyInPot + $RaiseHolder
                	$script:ComputerStack = $computerStack - $RaiseHolder
        		if ($computerStack -gt 0) {
                       	Write-Host “Opponent raised `$$RaiseHolder to make the total pot size `$$MoneyInPot"
                        Write-Host “Opponent’s remaining stack size is `$$computerStack"
        		}
       			if ($computerStack -le 0) {
                      	Write-Host “Opponent went all in."
                       	$script:AllInHolder = [math]::abs($ComputerStack)
                       	$script:MoneyInPot = $MoneyInPot - $AllInHolder
                       	$script:ComputerMoneyInPot = $ComputerMoneyInPot - $AllInHolder
                       	$script:ComputerStack = 0
                        Write-Host "The total pot size is `$$MoneyInPot"
                        $script:RunOut = "True"
  			    }

        		if ($CheckBack -eq “False”) {
                    $script:Turn = 0
				    $script:CheckBack = “False”
       			}
        		if ($CheckBack -eq “True”) {
                    $script:Turn = 0
                    $script:CheckBack = “False”
        		}

	    }
    }
}

#Deals the hold cards to you and the computer
function Deal-Hand {
	$script:PNumber1 = Get-Number
	$script:PSuit1 = Get-Suit

	$script:PNumber2 = Get-Number
	$script:PSuit2 = Get-Suit
	
	$script:CNumber1 = Get-Number
	$script:CSuit1 = Get-Suit

	$script:CNumber2 = Get-Number
	$script:CSuit2 = Get-Suit

	$script:different = "False"

	while ($different -eq "False") {
		
		if (($PNumber1 -eq $PNumber2) -and ($PSuit1 -eq $PSuit2)) {
			$script:PNumber1 = Get-Number
			$script:PSuit1 = Get-Suit
			$script:PNumber2 = Get-Number
			$script:PSuit2 = Get-Suit
			$script:different = "False"
		}
		elseif (($PNumber1 -eq $CNumber1) -and ($PSuit1 -eq $CSuit1)) {
			$script:PNumber1 = Get-Number
			$script:PSuit1 = Get-Suit
			$script:CNumber1 = Get-Number
			$script:CSuit1 = Get-Suit
			$script:different = "False"
		}
		elseif (($PNumber1 -eq $CNumber2) -and ($PSuit1 -eq $CSuit2)) {
			$script:PNumber1 = Get-Number
			$script:PSuit1 = Get-Suit
			$script:CNumber2 = Get-Number
			$script:CSuit2 = Get-Suit
			$script:different = "False"
		}
		elseif (($PNumber2 -eq $CNumber1) -and ($PSuit2 -eq $CSuit1)) {
			$script:PNumber2 = Get-Number
			$script:PSuit2 = Get-Suit
			$script:CNumber1 = Get-Number
			$script:CSuit1 = Get-Suit
			$script:different = "False"
		}
		elseif (($PNumber2 -eq $CNumber2) -and ($PSuit2 -eq $CSuit2)) {
			$PNumber2 = Get-Number
			$PSuit2 = Get-Suit
			$CNumber2 = Get-Number
			$CSuit2 = Get-Suit
			$script:different = "False"
		}
		elseif (($CNumber2 -eq $CNumber1) -and ($CSuit2 -eq $CSuit1)) {
			$script:CNumber2 = Get-Number
			$script:CSuit2 = Get-Suit
			$script:CNumber1 = Get-Number
			$script:CSuit1 = Get-Suit
			$script:different = "False"
		}
		else {
			$script:different = "True"
	    }
	} 
}

#Gets the Cards for the flop
function Get-Flop {
    $script:Flop1Number = Get-Number
    $script:Flop2Number = Get-Number
    $script:Flop3Number = Get-Number
    $script:Flop1Suit = Get-Suit
    $script:Flop2Suit = Get-Suit
    $script:Flop3Suit = Get-Suit

 #   [system.collections.arraylist][string[]]$script:CardCheckArray = "$PNumber1$PSuit1","$PNumber2$PSuit2","$CNumber1$CSuit1","$CNumber2$CSuit2","$Flop1Number$Flop1Suit","$Flop2Number$Flop2Suit","$Flop3Number$Flop3Suit"
 #
 #   for ($i = 0 ; $i -lt ($CardCheckArray.count - 1); $i += 1) {
 #       $script:HolderNumber = $CardCheckArray[$i]
 #       while ($CardCheckArray -contains "$HolderNumber") {
 #           $script:IdenticalHolder = ($IdenticalHolder + 1)
 #           $CardCheckArray.Remove("$HolderNumber")
 #       }
 #       if ($IdenticalHolder -ge 2) {
 #           Get-Flop
 #       }
 #       $script:IdenticalHolder = 0
 #   }
    clear-host
    write-host ""    write-host ""
    write-host "The Flop is: $Flop1Number of $Flop1Suit    $Flop2Number of $Flop2Suit    $Flop3Number of $Flop3Suit"
    Get-PlayerHand  
}

#Gets the Cards for the turn
function Get-Turn {
    $script:TurnNumber = Get-Number
    $script:TurnSuit = Get-Suit

 #   [system.collections.arraylist][string[]]$script:CardCheckArray = "$PNumber1$PSuit1","$PNumber2$PSuit2","$CNumber1$CSuit1","$CNumber2$CSuit2","$Flop1Number$Flop1Suit","$Flop2Number$Flop2Suit","$Flop3Number$Flop3Suit","$TurnNumber$TurnSuit"
 #
 #   for ($i = 0 ; $i -lt ($CardCheckArray.count - 1); $i += 1) {
 #       $script:HolderNumber = $CardCheckArray[$i]
 #       while ($CardCheckArray -contains "$HolderNumber") {
 #           $script:IdenticalHolder = ($IdenticalHolder + 1)
 #           $CardCheckArray.Remove("$HolderNumber")
 #       }
 #       if ($IdenticalHolder -ge 2) {
 #           Get-Turn
 #       }
 #       $script:IdenticalHolder = 0
 #   }
    clear-host
    write-host ""    write-host ""
    write-host "The Flop is: $Flop1Number of $Flop1Suit    $Flop2Number of $Flop2Suit    $Flop3Number of $Flop3Suit"
    write-host "The Turn is: $TurnNumber of $TurnSuit"
    Get-PlayerHand  
}

#Gets the Cards for the turn
function Get-River {
    $script:RiverNumber = Get-Number
    $script:RiverSuit = Get-Suit

  #  [system.collections.arraylist][string[]]$script:CardCheckArray = "$PNumber1$PSuit1","$PNumber2$PSuit2","$CNumber1$CSuit1","$CNumber2$CSuit2","$Flop1Number$Flop1Suit","$Flop2Number$Flop2Suit","$Flop3Number$Flop3Suit","$TurnNumber$TurnSuit","$RiverNumber$RiverSuit"
  #
  #  for ($i = 0 ; $i -lt ($CardCheckArray.count - 1); $i += 1) {
  #      $script:HolderNumber = $CardCheckArray[$i]
  #      while ($CardCheckArray -contains "$HolderNumber") {
  #          $script:IdenticalHolder = ($IdenticalHolder + 1)
  #          $CardCheckArray.Remove("$HolderNumber")
  #      }
  #      if ($IdenticalHolder -ge 2) {
  #          Get-Turn
  #      }
  #      $script:IdenticalHolder = 0
  #  }
    clear-host
    write-host ""    write-host ""
    write-host "The Flop is: $Flop1Number of $Flop1Suit    $Flop2Number of $Flop2Suit    $Flop3Number of $Flop3Suit"
    write-host "The Turn is: $TurnNumber of $TurnSuit"
    write-host "The River is: $RiverNumber of $RiverSuit"
    Get-PlayerHand  
}

#This gets the number for the card
function Get-Number {
	
	$script:number = Get-Random -minimum 2 -Maximum 15
	if ($number -eq 14) {$script:number = "Ace"} 
	if ($number -eq 11) {$script:number = "Jack"} 
	if ($number -eq 12) {$script:number = "Queen"} 	
	if ($number -eq 13) {$script:number = "King"} 
	
	$script:number

}

#This gets the suit for the card
function Get-Suit {

	$script:Suit = Get-Random -minimum 1 -Maximum 5
	if ($suit -eq 1) {$script:suit = "Spades"} 
	if ($suit -eq 2) {$script:suit = "Diamonds"} 
	if ($suit -eq 3) {$script:suit = "Hearts"} 
	if ($suit -eq 4) {$script:suit = "Clubs"} 

	$script:Suit

}

#Displays the player's hand
function Get-PlayerHand {
	Write-Host " "
	Write-Host " "
	Write-Host "Your Hand: $PNumber1 of $PSuit1        $PNumber2 of $PSuit2"   	
	Write-Host " "
}

#Gets the statistics of the player and computer as well as the game
function Get-Stats {
	Write-Host "Your stack size is `$$playerStack. Your opponents stack size is `$$computerStack."
	Write-Host "The big blind is `$$bigblind. The small blind is `$$smallblind."
}

#You and the computer will place your corresponding blinds
function Collect-Blinds {
	if ($TurnBlind -eq 0) {
		$script:computerStack = $computerStack - $BigBlind
		$script:MoneyInPot = $MoneyInPot + $BigBlind
		$script:ComputerMoneyInPot = $ComputerMoneyInPot + $BigBlind
        Write-Host ""
        Write-Host ""
        Write-Host ""
		Write-Host "Opponent's Big Blind Bet: `$$BigBlind. Opponent's stack size: `$$computerStack"
		$script:playerStack = $playerStack - $SmallBlind
		$script:MoneyInPot = $MoneyInPot + $SmallBlind
		$script:PlayerMoneyInPot = $PlayerMoneyInPot + $SmallBlind
		Write-Host "Your Small Blind Bet: `$$SmallBlind. Your stack size: `$$playerStack"
		Write-Host "Total Pot Size: `$$MoneyInPot"
		$script:TurnBlind = 1
	}
	else {
		$script:playerStack = $playerStack - $BigBlind
		$script:MoneyInPot = $MoneyInPot + $BigBlind
		$script:PlayerMoneyInPot = $PlayerMoneyInPot + $BigBlind
		Write-Host "Your Big Blind Bet: `$$BigBlind. Your stack size: `$$playerStack"
		$script:computerStack = $computerStack - $SmallBlind
		$script:MoneyInPot = $MoneyInPot + $SmallBlind
		$script:ComputerMoneyInPot = $ComputerMoneyInPot + $SmallBlind
		Write-Host "Opponent's Small Blind Bet: `$$SmallBlind. Opponent's stack size: `$$computerStack"
		Write-Host "Total Pot Size: `$$MoneyInPot"
		$script:TurnBlind = 0
	}
}

#You and the computer will place action
function Get-ActionPreFlop {

	if ($Turn -eq 0) { 
		Run-ComputerAction
	}
    if ($Turn -eq 1) {
        Run-PlayerAction
    }
    if (($Turn -eq 1) -or ($Turn -eq 0)) {
        Get-ActionPreFlop
    }

}

#Receives the action the player would like to do
function Run-PlayerAction {
    write-host “Your stack size is `$$playerStack.”
	
	if ($Turn -eq 1) {
		
		#Only used to display text
		
		$Script:DataHolder = $ComputerMoneyInPot - $PlayerMoneyInPot
		
		write-host “To call you need to add `$$DataHolder”
	
	    #Turn = 1 then player goes first pre flop
        if ($Turn -eq 1) {
                $script:Action = Read-Host "Enter C to call/check, R to raise/bet, or F to fold"

                #The call action
                if ($Action -eq "C") {
                        $script:Amount = ($ComputerMoneyInPot - $PlayerMoneyInPot)
                        $Script:MoneyInPot = $MoneyInPot + $Amount
                        $Script:PlayerMoneyInPot = $PlayerMoneyInPot + $Amount
                        $Script:PlayerStack = $PlayerStack - $Amount
                        if ($PlayerStack -gt 0) {
                                Write-Host "You called `$$Amount to make the total pot size `$$MoneyInPot"
                                Write-Host "Your remaining stack size is `$$playerStack"
                        }
                        if ($PlayerStack -le 0) {
                                Write-Host "You went all in."
                                $script:AllIn = [math]::abs($PlayerStack)
                                $Script:MoneyInPot = $MoneyInPot - $AllIn
                                $Script:PlayerMoneyInPot = $PlayerMoneyInPot - $AllIn
                                $Script:PlayerStack = 0
                                Write-Host "The total pot size is `$$MoneyInPot"
                                $script:RunOut = "True"
                        }
                        if ($CheckBack -eq “True”) {
                                $Script:Turn = 0
                                $Script:CheckBack = “False”
                        }
                        if ($CheckBack -eq “False”) {
                                $Script:Turn = 3
                        }

                }
	}


#The raise action
        if ($Action -eq "R") {
                $script:MinRaise = ($ComputerMoneyInPot - $PlayerMoneyInPot) * 2
                $script:Amount = Read-Host "Please enter your raise amount WITHOUT a dollar sign - minimum raise amount is `$$MinRaise (Put total amount of cash in your stack for all in)”
                $script:AllInCheck = ($ComputerMoneyInPot - $PlayerMoneyInPot) + $ComputerStack

                if ($AllInCheck -le $Amount) {
	                    $script:Amount = $AllInCheck
		        }

                $script:AllIn = $PlayerStack - $Amount        

                if ($AllIn -gt 0) {
                        if ($MinRaise -le $Amount) {
                                $Script:MoneyInPot = $MoneyInPot + $Amount
                                $Script:PlayerMoneyInPot = $PlayerMoneyInPot + $Amount
                                $Script:PlayerStack = $PlayerStack - $Amount   
                                Write-Host "You raised `$$Amount. Total pot size is `$$MoneyInPot"
                                Write-Host "Your remaining stack size is `$$playerStack"

                                $Script:Turn = 0
                                $Script:CheckBack = “False”
                        }
                        if ($MinRaise -gt $Amount) {
                               $Script:Turn = 1
                        }
                }
                if ($AllIn -le 0) {
                        $Script:MoneyInPot = $MoneyInPot + $Amount + $AllIn
                        $Script:PlayerMoneyInPot = $PlayerMoneyInPot + $Amount
                        $Script:PlayerStack = 0
                        Write-Host "You went all in. The total pot size is `$$MoneyInPot"
                        $Script:Turn = 0
                        $Script:CheckBack = “False”
                        $script:RunOut = "True"
                }

        }

                        #The fold action
                if ($Action -eq "F") {
                        $Script:Turn = 2
			            $Script:WhoFolded = "Player"
                }

        }
}

#Receives the action the player would like to do
function Run-PlayerActionOverall {
    write-host “Your stack size is `$$playerStack.”
	
	if ($Turn -eq 0) {
		
		#Only used to display text
		
		$Script:DataHolder = $ComputerMoneyInPot - $PlayerMoneyInPot
		
		write-host “To call you need to add `$$DataHolder”

	    #Turn = 1 then player goes first pre flop
        if ($Turn -eq 0) {
                $script:Action = Read-Host "Enter C to call/check, R to raise/bet, or F to fold"

                #The call action
                if ($Action -eq "C") {
                        $script:Amount = ($ComputerMoneyInPot - $PlayerMoneyInPot)
                        $Script:MoneyInPot = $MoneyInPot + $Amount
                        $Script:PlayerMoneyInPot = $PlayerMoneyInPot + $Amount
                        $Script:PlayerStack = $PlayerStack - $Amount
                        if ($PlayerStack -gt 0) {
                                Write-Host "You called `$$Amount to make the total pot size `$$MoneyInPot"
                                Write-Host "Your remaining stack size is `$$playerStack"
                        }
                        if ($PlayerStack -le 0) {
                                Write-Host "You went all in."
                                $script:AllIn = [math]::abs($PlayerStack)
                                $Script:MoneyInPot = $MoneyInPot - $AllIn
                                $Script:PlayerMoneyInPot = $PlayerMoneyInPot - $AllIn
                                $Script:PlayerStack = 0
                                Write-Host "The total pot size is `$$MoneyInPot"
                                $script:RunOut = "True"
                        }
                        if ($CheckBack -eq “False”) {
                                $Script:Turn = 3
                        }
                        if ($CheckBack -eq “True”) {
                                $Script:Turn = 1
                                $Script:CheckBack = “False”
                        }
                }
	}


#The raise action
        if ($Action -eq "R") {
                $script:MinRaise = ($ComputerMoneyInPot - $PlayerMoneyInPot) * 2
                $script:Amount = Read-Host "Please enter your raise amount WITHOUT a dollar sign - minimum raise amount is `$$MinRaise (Put total amount of cash in your stack for all in)”
                $script:AllInCheck = ($ComputerMoneyInPot - $PlayerMoneyInPot) + $ComputerStack

                if ($AllInCheck -le $Amount) {
	                    $script:Amount = $AllInCheck
		        }

                $script:AllIn = $PlayerStack - $Amount        

                if ($AllIn -gt 0) {
                        if ($MinRaise -le $Amount) {
                                $Script:MoneyInPot = $MoneyInPot + $Amount
                                $Script:PlayerMoneyInPot = $PlayerMoneyInPot + $Amount
                                $Script:PlayerStack = $PlayerStack - $Amount   
                                Write-Host "You raised `$$Amount. Total pot size is `$$MoneyInPot"
                                Write-Host "Your remaining stack size is `$$playerStack"

                                $Script:Turn = 1
                                $Script:CheckBack = “False”
                        }
                        if ($MinRaise -gt $Amount) {
                               $Script:Turn = 0
                        }
                }
                if ($AllIn -le 0) {
                        $Script:MoneyInPot = $MoneyInPot + $Amount + $AllIn
                        $Script:PlayerMoneyInPot = $PlayerMoneyInPot + $Amount
                        $Script:PlayerStack = 0
                        Write-Host "You went all in. The total pot size is `$$MoneyInPot"
                        $Script:Turn = 1
                        $Script:CheckBack = “False”
                        $script:RunOut = "True"
                }

        }

                        #The fold action
                if ($Action -eq "F") {
                        $Script:Turn = 2
			            $Script:WhoFolded = "Player"
                }

        }
}

#Receives the action the computer would like to do pre-flop
function Run-ComputerAction {
        $script:CallHolder = ($PlayerMoneyInPot - $ComputerMoneyInPot)

	Check-handstrengthpreflop

        if ($HandStrength -eq 0) {
		Computer-PreFlop0
        }
        if ($HandStrength -eq 1) {
		Computer-PreFlop1
        }
        if ($HandStrength -eq 2) {
		Computer-PreFlop2
        }
        if ($HandStrength -eq 3) {
		Computer-PreFlop3
        }
        if ($HandStrength -eq 4) {
		Computer-PreFlop4
        }
        if (($HandStrength -eq 5) -or ($HandStrength -eq 6)) {
		Computer-PreFlop5
        }
        if ($HandStrength -ge 7) {
		Computer-PreFlop6
        }
}

#Computer commits this action if handstrength is 0
function Computer-PreFlop0 {
	if (($CallHolder -lt 35) -and ($ComputerMoneyInPot -lt 100)) {
       		$script:MoneyInPot = $MoneyInPot + $CallHolder
                $script:ComputerMoneyInPot = $ComputerMoneyInPot + $CallHolder
                $script:ComputerStack = $computerStack - $CallHolder
        	if ($computerStack -gt 0) {
                        Write-Host “Opponent called `$$CallHolder to make the total pot size `$$MoneyInPot"
                        Write-Host “Opponent’s remaining stack size is `$$computerStack"
        	}
       		if ($computerStack -le 0) {
                       	Write-Host “Opponent went all in."
                        $script:AllInHolder = [math]::abs($ComputerStack)
                        $script:MoneyInPot = $MoneyInPot - $AllInHolder
                        $script:ComputerMoneyInPot = $ComputerMoneyInPot - $AllInHolder
                        $script:ComputerStack = 0
                        Write-Host "The total pot size is `$$MoneyInPot"
                        $script:RunOut = "True"
  		    }
        	if ($CheckBack -eq “False”) {
                        $script:Turn = 3
       		}
        	if ($CheckBack -eq “True”) {
                        $script:Turn = 1
                        $script:CheckBack = “False”
        	}

	}
	else {
		$script:Turn = 2
		$script:WhoFolded = "Computer"
	}
}

#Computer commits this action if handstrength is 1
function Computer-PreFlop1 {
	if (($CallHolder -lt 65) -and ($ComputerMoneyInPot -lt 150)) {
       		$script:MoneyInPot = $MoneyInPot + $CallHolder
                $script:ComputerMoneyInPot = $ComputerMoneyInPot + $CallHolder
                $script:ComputerStack = $computerStack - $CallHolder
        	if ($computerStack -gt 0) {
                        Write-Host “Opponent called `$$CallHolder to make the total pot size `$$MoneyInPot"
                        Write-Host “Opponent’s remaining stack size is `$$computerStack"
        	}
       		if ($computerStack -le 0) {
                       	Write-Host “Opponent went all in."
                        $script:AllInHolder = [math]::abs($ComputerStack)
                        $script:MoneyInPot = $MoneyInPot - $AllInHolder
                        $script:ComputerMoneyInPot = $ComputerMoneyInPot - $AllInHolder
                        $script:ComputerStack = 0
                        Write-Host "The total pot size is `$$MoneyInPot"
                        $script:RunOut = "True"
  		    }
        	if ($CheckBack -eq “False”) {
                        $script:Turn = 3
       		}
        	if ($CheckBack -eq “True”) {
                        $script:Turn = 1
                        $script:CheckBack = “False”
        	}
	}
	else {
		$script:Turn = 2
		$script:WhoFolded = "Computer"
	}
}

#Computer commits this action if handstrength is 2
function Computer-PreFlop2 {
	if (($CallHolder -lt 85) -and ($ComputerMoneyInPot -lt 200)) {
       		$script:MoneyInPot = $MoneyInPot + $CallHolder
                $script:ComputerMoneyInPot = $ComputerMoneyInPot + $CallHolder
                $script:ComputerStack = $computerStack - $CallHolder
        	if ($computerStack -gt 0) {
                        Write-Host “Opponent called `$$CallHolder to make the total pot size `$$MoneyInPot"
                        Write-Host “Opponent’s remaining stack size is `$$computerStack"
        	}
       		if ($computerStack -le 0) {
                       	Write-Host “Opponent went all in."
                        $script:AllInHolder = [math]::abs($ComputerStack)
                        $script:MoneyInPot = $MoneyInPot - $AllInHolder
                        $script:ComputerMoneyInPot = $ComputerMoneyInPot - $AllInHolder
                        $script:ComputerStack = 0
                        Write-Host "The total pot size is `$$MoneyInPot"
                        $script:RunOut = "True"
  		    }
        	if ($CheckBack -eq “False”) {
                        $script:Turn = 3
       		}
        	if ($CheckBack -eq “True”) {
                        $script:Turn = 1
                        $script:CheckBack = “False”
        	}
	}
	else {
		$script:Turn = 2
		$script:WhoFolded = "Computer"
	}
}

#Computer commits this action if handstrength is 3
function Computer-PreFlop3 {
	if (($CallHolder -lt 150) -and ($ComputerMoneyInPot -lt 250)) {
       		$script:MoneyInPot = $MoneyInPot + $CallHolder
                $script:ComputerMoneyInPot = $ComputerMoneyInPot + $CallHolder
                $script:ComputerStack = $computerStack - $CallHolder
        	if ($computerStack -gt 0) {
                        Write-Host “Opponent called `$$CallHolder to make the total pot size `$$MoneyInPot"
                        Write-Host “Opponent’s remaining stack size is `$$computerStack"
        	}
       		if ($computerStack -le 0) {
                       	Write-Host “Opponent went all in."
                        $script:AllInHolder = [math]::abs($ComputerStack)
                        $script:MoneyInPot = $MoneyInPot - $AllInHolder
                        $script:ComputerMoneyInPot = $ComputerMoneyInPot - $AllInHolder
                        $script:ComputerStack = 0
                        Write-Host "The total pot size is `$$MoneyInPot"
                        $script:RunOut = "True"
  		    }
        	if ($CheckBack -eq “False”) {
                        $script:Turn = 3
       		}
        	if ($CheckBack -eq “True”) {
                        $script:Turn = 1
                        $script:CheckBack = “False”
        	}
	}
	else {
		$script:Turn = 2
		$script:WhoFolded = "Computer"
	}
}

#Computer commits this action if handstrength is 4
function Computer-PreFlop4 {
	if (($CallHolder -lt 300) -and ($ComputerMoneyInPot -lt 500)) {
       		$script:MoneyInPot = $MoneyInPot + $CallHolder
                $script:ComputerMoneyInPot = $ComputerMoneyInPot + $CallHolder
                $script:ComputerStack = $computerStack - $CallHolder
        	if ($computerStack -gt 0) {
                        Write-Host “Opponent called `$$CallHolder to make the total pot size `$$MoneyInPot"
                        Write-Host “Opponent’s remaining stack size is `$$computerStack"
        	}
       		if ($computerStack -le 0) {
                       	Write-Host “Opponent went all in."
                        $script:AllInHolder = [math]::abs($ComputerStack)
                        $script:MoneyInPot = $MoneyInPot - $AllInHolder
                        $script:ComputerMoneyInPot = $ComputerMoneyInPot - $AllInHolder
                        $script:ComputerStack = 0
                        Write-Host "The total pot size is `$$MoneyInPot"
                        $script:RunOut = "True"
  		    }
            if ($CheckBack -eq “False”) {
                        $script:Turn = 3
       		}
        	if ($CheckBack -eq “True”) {
                        $script:Turn = 1
                        $script:CheckBack = “False”
        	}
	}
	else {
		$script:Turn = 2
		$script:WhoFolded = "Computer"
	}
}

#Computer commits this action if handstrength is 5 or 6
function Computer-PreFlop5 {
	$script:Random11 = get-random -minimum 1 -maximum 4
	if (($CallHolder -lt 650) -and ($ComputerMoneyInPot -lt 850)) {
		if ($CallHolder -gt 250) {
			$script:Random11 = 1
		}
		if (($Random11 -eq 1) -or ($Random11 -eq 3)) {
       			$script:MoneyInPot = $MoneyInPot + $CallHolder
                	$script:ComputerMoneyInPot = $ComputerMoneyInPot + $CallHolder
               		$script:ComputerStack = $computerStack - $CallHolder
        		if ($computerStack -gt 0) {
                        Write-Host “Opponent called `$$CallHolder to make the total pot size `$$MoneyInPot"
                        Write-Host “Opponent’s remaining stack size is `$$computerStack"
        		}
       			if ($computerStack -le 0) {
                       	Write-Host “Opponent went all in."
                        $script:AllInHolder = [math]::abs($ComputerStack)
                        $script:MoneyInPot = $MoneyInPot - $AllInHolder
                        $script:ComputerMoneyInPot = $ComputerMoneyInPot - $AllInHolder
                        $script:ComputerStack = 0
                        Write-Host "The total pot size is `$$MoneyInPot"
                        $script:RunOut = "True"
  			    }
        	    if ($CheckBack -eq “False”) {
                        $script:Turn = 3
       		    }
        		if ($CheckBack -eq “True”) {
                        $script:Turn = 1
                        $script:CheckBack = “False”
        		}
		}

		if ($Random11 -eq 2) {
			$script:RandomRaiseRate = get-random -minimum 1 -maximum 6
			$script:RaiseHolder = $CallHolder * 2
			if ($RandomRaiseRate -gt 3) {
				$script:RaiseHolder = [math]::Round($RaiseHolder * ($RandomRaiseRate/3))
			}

        		if ($RaiseHolder -gt $ComputerStack) {
				    $script:RaiseHolder = $RaiseHolder - ($RaiseHolder - $ComputerStack)
        		}

			$script:MoneyInPot = $MoneyInPot + $RaiseHolder
			$script:ComputerStack = $ComputerStack - $RaiseHolder
			$script:ComputerMoneyInPot = $ComputerMoneyInPot - $RaiseHolder

       			if ($computerStack -le 0) {
                       	Write-Host “Opponent went all in."
                        $script:AllInHolder = [math]::abs($ComputerStack)
                        $script:MoneyInPot = $MoneyInPot - $AllInHolder
                        $script:ComputerMoneyInPot = $ComputerMoneyInPot - $AllInHolder
                        $script:ComputerStack = 0
                        Write-Host "The total pot size is `$$MoneyInPot"
                        $script:RunOut = "True"
  			}
			
			if ($computerStack -gt 0) {
				Write-Host "Opponent raised to `$$RaiseHolder."
				Write-Host "Opponent's stack size is `$$ComputerStack"
			}	

        	if ($CheckBack -eq “False”) {
                $script:Turn = 1
			    $script:CheckBack = “False”
       		}
        	if ($CheckBack -eq “True”) {
                $script:Turn = 1
                $script:CheckBack = “False”
            }
	    }
    
    }
	else {
		$script:Turn = 2
		$script:WhoFolded = "Computer"
	}
}

#Computer commits this action if handstrength is 7 or higher
function Computer-PreFlop6 {
	$script:StackHolder = $ComputerStack/2
	$script:Random11 = get-random -minimum 1 -maximum 4
	$script:CheckAllInPossible = "True"

        $script:AllInCheck1 = ($ComputerMoneyInPot - $PlayerMoneyInPot) + $ComputerStack
        if ($AllInCheck1 -gt $PlayerStack) {
        	$script:CheckAllInPossible = "False"
		    $script:AllInCheck1 = $AllInCheck1 - ($AllInCheck1 - $PlayerStack)
        }

	if ($CallHolder -ge $StackHolder) {
		if ($CallHolder -lt $ComputerStack) {
                       	$script:Turn = 1
                       	$script:CheckBack = “False”
        	}
       		if ($CallHolder -eq $ComputerStack) {
                       	$script:Turn = 3
     		}
		if ($CheckAllInPossible -eq "True") {
			$script:CallHolder = $computerStack
			Write-Host "Opponent went all in."
			$script:ComputerStack = $ComputerStack - $CallHolder	
            $script:RunOut = "True"
		}
		if ($CheckAllInPossible -eq "False") {
			$script:CallHolder = $AllInCheck1
			Write-Host "Opponent raised to $CallHolder."
			$script:ComputerStack = $ComputerStack - $CallHolder
			Write-Host "Opponents stack size `$$ComputerStack"
		}
                
                $script:MoneyInPot = $MoneyInPot + $CallHolder
                $script:ComputerMoneyInPot = $ComputerMoneyInPot + $CallHolder
                Write-Host "The total pot size is `$$MoneyInPot"
	}

	else {
		if ($CallHolder -gt 750) {
			$script:Random11 = 1
		}
		if (($Random11 -eq 1) -or ($Random11 -eq 3)) {
       			$script:MoneyInPot = $MoneyInPot + $CallHolder
                	$script:ComputerMoneyInPot = $ComputerMoneyInPot + $CallHolder
               		$script:ComputerStack = $computerStack - $CallHolder
        		if ($computerStack -gt 0) {
                        	Write-Host “Opponent called `$$CallHolder to make the total pot size `$$MoneyInPot"
                        	Write-Host “Opponent’s remaining stack size is `$$computerStack"
        		}
       			if ($computerStack -le 0) {
                       	Write-Host “Opponent went all in."
                        $script:AllInHolder = [math]::abs($ComputerStack)
                        $script:MoneyInPot = $MoneyInPot - $AllInHolder
                        $script:ComputerMoneyInPot = $ComputerMoneyInPot - $AllInHolder
                        $script:ComputerStack = 0
                        Write-Host "The total pot size is `$$MoneyInPot"
                        $script:RunOut = "True"
  			}
        		if ($CheckBack -eq “False”) {
                        	$script:Turn = 3
       			}
        		if ($CheckBack -eq “True”) {
                        	$script:Turn = 1
                        	$script:CheckBack = “False”
        		}
		}
		if ($Random11 -eq 2) {
			$script:RandomRaiseRate = get-random -minimum 1 -maximum 6
			$script:RaiseHolder = $CallHolder * 2
			if ($RandomRaiseRate -lt 3) {
				$script:RaiseHolder = [math]::Round($RaiseHolder * ($RandomRaiseRate/3))
			}
       			$script:MoneyInPot = $MoneyInPot + $RaiseHolder
                	$script:ComputerMoneyInPot = $ComputerMoneyInPot + $RaiseHolder
                	$script:ComputerStack = $computerStack - $RaiseHolder
        		if ($computerStack -gt 0) {
                       	Write-Host “Opponent raised `$$RaiseHolder to make the total pot size `$$MoneyInPot"
                        Write-Host “Opponent’s remaining stack size is `$$computerStack"
        		}
       			if ($computerStack -le 0) {
                      	Write-Host “Opponent went all in."
                       	$script:AllInHolder = [math]::abs($ComputerStack)
                       	$script:MoneyInPot = $MoneyInPot - $AllInHolder
                       	$script:ComputerMoneyInPot = $ComputerMoneyInPot - $AllInHolder
                       	$script:ComputerStack = 0
                        Write-Host "The total pot size is `$$MoneyInPot"
                        $script:RunOut = "True"
  			    }

        		if ($CheckBack -eq “False”) {
                    $script:Turn = 1
				    $script:CheckBack = “False”
       			}
        		if ($CheckBack -eq “True”) {
                    $script:Turn = 1
                    $script:CheckBack = “False”
        		}

	    }
    }
}
		
#Checks hand strength to determine call, raise, or fold pre-flop (1-10, 10 being the best hand)
Function check-handstrengthpreflop {
	
#To see how close numbers are

$script:NumberHolder1 = $CNumber1
$script:NumberHolder2 = $CNumber2

if ($NumberHolder1 -eq "Ace") {$NumberHolder1 = 14} 
if ($NumberHolder1 -eq "Jack") {$NumberHolder1 = 11} 
if ($NumberHolder1 -eq "Queen") {$NumberHolder1 = 12} 	
if ($NumberHolder1 -eq "King") {$NumberHolder1 = 13} 

if ($NumberHolder2 -eq "Ace") {$NumberHolder2 = 14} 
if ($NumberHolder2 -eq "Jack") {$NumberHolder2 = 11} 
if ($NumberHolder2 -eq "Queen") {$NumberHolder2 = 12} 	
if ($NumberHolder2 -eq "King") {$NumberHolder2 = 13}
	
$script:Distance = [math]::abs($NumberHolder1 - $NumberHolder2)
$script:HandStrength = 0
	
if (($CNumber1 -eq “Jack”) -or ($CNumber1 -eq “Queen”) -or ($CNumber1 -eq “King”) -or ($CNumber1 -eq “Ace”)) {
		
	$script:HandStrength = $HandStrength + 1
			
		if ($CNumber1 -eq “Ace”) {
				
			$Script:HandStrength = $HandStrength + 1
			
		}
	
}
	
if (($CNumber2 -eq “Jack”) -or ($CNumber2 -eq “Queen”) -or ($CNumber2 -eq “King”) -or ($CNumber2 -eq “Ace”)) {
		
	$script:HandStrength = $HandStrength + 1
			
		if ($CNumber2 -eq “Ace”) {
				
			$Script:HandStrength = $HandStrength + 1
			
		}
	
}
	
if (
$Distance -eq 1) {
	$script:HandStrength = $HandStrength + 2
}
if (
$Distance -eq 2) {
	$script:HandStrength = $HandStrength + 1
}
if ($CSuit1 -eq $CSuit2) {
		
	$script:HandStrength = $HandStrength + 2
	
}

	
if ($CNUmber1 -eq $CNumber2) {
		
	if (($CNumber1 -eq 10) -or ($CNumber1 -eq “Jack”) -or ($CNumber1 -eq “Queen”) -or ($CNumber1 -eq “King”) -or ($CNumber1 -eq “Ace”)) {
			
		$script:HandStrength = 10
	
	}	
	else {
			
		$script:HandStrength = 8
		
	}
	
}
}

#Checks the handstrength overall of the computer
function Check-ComputerHandFlop {
    $script:NumberHolder1 = $CNumber1
    $script:NumberHolder2 = $CNumber2
    $script:SuitHolder1 = $CSuit1
    $script:SuitHolder2 = $CSuit2
    $script:Flop1NumberHolder = $Flop1Number
    $script:Flop2NumberHolder = $Flop2Number
    $script:Flop3NumberHolder = $Flop3Number

    if ($NumberHolder1 -eq "Ace") {$script:NumberHolder1 = 14} 
	if ($NumberHolder1 -eq "Jack") {$script:NumberHolder1 = 11} 
	if ($NumberHolder1 -eq "Queen") {$script:NumberHolder1 = 12} 	
	if ($NumberHolder1 -eq "King") {$script:NumberHolder1 = 13} 

    if ($NumberHolder2 -eq "Ace") {$script:NumberHolder2 = 14} 
	if ($NumberHolder2 -eq "Jack") {$script:NumberHolder2 = 11} 
	if ($NumberHolder2 -eq "Queen") {$script:NumberHolder2 = 12} 	
	if ($NumberHolder2 -eq "King") {$script:NumberHolder2 = 13}

    if ($Flop1Number -eq "Ace") {$script:Flop1NumberHolder = 14} 
	if ($Flop1Number -eq "Jack") {$script:Flop1NumberHolder = 11} 
	if ($Flop1Number -eq "Queen") {$script:Flop1NumberHolder = 12} 	
	if ($Flop1Number -eq "King") {$script:Flop1NumberHolder = 13}

    if ($Flop2Number -eq "Ace") {$script:Flop2NumberHolder = 14} 
	if ($Flop2Number -eq "Jack") {$script:Flop2NumberHolder = 11} 
	if ($Flop2Number -eq "Queen") {$script:Flop2NumberHolder = 12} 	
	if ($Flop2Number -eq "King") {$script:Flop2NumberHolder = 13}

    if ($Flop3Number -eq "Ace") {$script:Flop3NumberHolder = 14} 
	if ($Flop3Number -eq "Jack") {$script:Flop3NumberHolder = 11} 
	if ($Flop3Number -eq "Queen") {$script:Flop3NumberHolder = 12} 	
	if ($Flop3Number -eq "King") {$script:Flop3NumberHolder = 13}

    [system.collections.arraylist]$script:ComputerNumberArray = $NumberHolder1,$NumberHolder2,$Flop1NumberHolder,$Flop2NumberHolder,$Flop3NumberHolder
    [system.collections.arraylist][int[]]$script:NumberArray = $NumberHolder1,$NumberHolder2,$Flop1NumberHolder,$Flop2NumberHolder,$Flop3NumberHolder
    [system.collections.arraylist]$script:ComputerSuitArray = $SuitHolder1,$SuitHolder2,$Flop1Suit,$Flop2Suit,$Flop3Suit
    [system.collections.arraylist]$script:SuitArray = $SuitHolder1,$SuitHolder2,$Flop1Suit,$Flop2Suit,$Flop3Suit

    $script:CounterHolder = 0
    Check-OnePair
    [system.collections.arraylist][int[]]$script:NumberArray = $NumberHolder1,$NumberHolder2,$Flop1NumberHolder,$Flop2NumberHolder,$Flop3NumberHolder
    $script:CounterHolder = 0
    Check-TwoPair
    [system.collections.arraylist][int[]]$script:NumberArray = $NumberHolder1,$NumberHolder2,$Flop1NumberHolder,$Flop2NumberHolder,$Flop3NumberHolder
    $script:CounterHolder = 0
    Check-ThreeOfAKind
    [system.collections.arraylist][int[]]$script:NumberArray = $NumberHolder1,$NumberHolder2,$Flop1NumberHolder,$Flop2NumberHolder,$Flop3NumberHolder
    $script:CounterHolder = 0
    Check-Straight
    [system.collections.arraylist][int[]]$script:NumberArray = $NumberHolder1,$NumberHolder2,$Flop1NumberHolder,$Flop2NumberHolder,$Flop3NumberHolder
    [system.collections.arraylist]$script:SuitArray = $SuitHolder1,$SuitHolder2,$Flop1Suit,$Flop2Suit,$Flop3Suit
    $script:CounterHolder = 0
    Check-Flush
    [system.collections.arraylist][int[]]$script:NumberArray = $NumberHolder1,$NumberHolder2,$Flop1NumberHolder,$Flop2NumberHolder,$Flop3NumberHolder
    [system.collections.arraylist]$script:SuitArray = $SuitHolder1,$SuitHolder2,$Flop1Suit,$Flop2Suit,$Flop3Suit
    $script:CounterHolder = 0
    Check-FullHouseComputer
    [system.collections.arraylist][int[]]$script:NumberArray = $NumberHolder1,$NumberHolder2,$Flop1NumberHolder,$Flop2NumberHolder,$Flop3NumberHolder
    $script:CounterHolder = 0
    Check-FourOfAKind
    [system.collections.arraylist][int[]]$script:NumberArray = $NumberHolder1,$NumberHolder2,$Flop1NumberHolder,$Flop2NumberHolder,$Flop3NumberHolder
    [system.collections.arraylist]$script:SuitArray = $SuitHolder1,$SuitHolder2,$Flop1Suit,$Flop2Suit,$Flop3Suit
    $script:CounterHolder = 0
    Check-StraightFlushComputer

    $script:ComputerHighestCard = $HighestCard
    $script:ComputerHandStrengthOverall = $HandStrengthHolder
    $script:HandStrengthHolder = 1
}

#Checks the handstrength overall of the computer
function Check-ComputerHandTurn {
    $script:NumberHolder1 = $CNumber1
    $script:NumberHolder2 = $CNumber2
    $script:SuitHolder1 = $CSuit1
    $script:SuitHolder2 = $CSuit2
    $script:Flop1NumberHolder = $Flop1Number
    $script:Flop2NumberHolder = $Flop2Number
    $script:Flop3NumberHolder = $Flop3Number
    $script:TurnNumberHolder = $TurnNumber

    if ($NumberHolder1 -eq "Ace") {$script:NumberHolder1 = 14} 
	if ($NumberHolder1 -eq "Jack") {$script:NumberHolder1 = 11} 
	if ($NumberHolder1 -eq "Queen") {$script:NumberHolder1 = 12} 	
	if ($NumberHolder1 -eq "King") {$script:NumberHolder1 = 13} 

    if ($NumberHolder2 -eq "Ace") {$script:NumberHolder2 = 14} 
	if ($NumberHolder2 -eq "Jack") {$script:NumberHolder2 = 11} 
	if ($NumberHolder2 -eq "Queen") {$script:NumberHolder2 = 12} 	
	if ($NumberHolder2 -eq "King") {$script:NumberHolder2 = 13}

    if ($Flop1Number -eq "Ace") {$script:Flop1NumberHolder = 14} 
	if ($Flop1Number -eq "Jack") {$script:Flop1NumberHolder = 11} 
	if ($Flop1Number -eq "Queen") {$script:Flop1NumberHolder = 12} 	
	if ($Flop1Number -eq "King") {$script:Flop1NumberHolder = 13}

    if ($Flop2Number -eq "Ace") {$script:Flop2NumberHolder = 14} 
	if ($Flop2Number -eq "Jack") {$script:Flop2NumberHolder = 11} 
	if ($Flop2Number -eq "Queen") {$script:Flop2NumberHolder = 12} 	
	if ($Flop2Number -eq "King") {$script:Flop2NumberHolder = 13}

    if ($Flop3Number -eq "Ace") {$script:Flop3NumberHolder = 14} 
	if ($Flop3Number -eq "Jack") {$script:Flop3NumberHolder = 11} 
	if ($Flop3Number -eq "Queen") {$script:Flop3NumberHolder = 12} 	
	if ($Flop3Number -eq "King") {$script:Flop3NumberHolder = 13}

    if ($TurnNumber -eq "Ace") {$script:TurnNumberHolder = 14} 
	if ($TurnNumber -eq "Jack") {$script:TurnNumberHolder = 11} 
	if ($TurnNumber -eq "Queen") {$script:TurnNumberHolder = 12} 	
	if ($TurnNumber -eq "King") {$script:TurnNumberHolder = 13}

    [system.collections.arraylist]$script:ComputerNumberArray = $NumberHolder1,$NumberHolder2,$Flop1NumberHolder,$Flop2NumberHolder,$Flop3NumberHolder,$TurnNumberHolder
    [system.collections.arraylist][int[]]$script:NumberArray = $NumberHolder1,$NumberHolder2,$Flop1NumberHolder,$Flop2NumberHolder,$Flop3NumberHolder,$TurnNumberHolder
    [system.collections.arraylist]$script:ComputerSuitArray = $SuitHolder1,$SuitHolder2,$Flop1Suit,$Flop2Suit,$Flop3Suit,$TurnSuit
    [system.collections.arraylist]$script:SuitArray = $SuitHolder1,$SuitHolder2,$Flop1Suit,$Flop2Suit,$Flop3Suit,$TurnSuit

    $script:CounterHolder = 0
    Check-OnePair
    [system.collections.arraylist][int[]]$script:NumberArray = $NumberHolder1,$NumberHolder2,$Flop1NumberHolder,$Flop2NumberHolder,$Flop3NumberHolder,$TurnNumberHolder
    $script:CounterHolder = 0
    Check-TwoPair
    [system.collections.arraylist][int[]]$script:NumberArray = $NumberHolder1,$NumberHolder2,$Flop1NumberHolder,$Flop2NumberHolder,$Flop3NumberHolder,$TurnNumberHolder
    $script:CounterHolder = 0
    Check-ThreeOfAKind
    [system.collections.arraylist][int[]]$script:NumberArray = $NumberHolder1,$NumberHolder2,$Flop1NumberHolder,$Flop2NumberHolder,$Flop3NumberHolder,$TurnNumberHolder
    $script:CounterHolder = 0
    Check-Straight
    [system.collections.arraylist][int[]]$script:NumberArray = $NumberHolder1,$NumberHolder2,$Flop1NumberHolder,$Flop2NumberHolder,$Flop3NumberHolder,$TurnNumberHolder
    [system.collections.arraylist]$script:SuitArray = $SuitHolder1,$SuitHolder2,$Flop1Suit,$Flop2Suit,$Flop3Suit,$TurnSuit
    $script:CounterHolder = 0
    Check-Flush
    [system.collections.arraylist][int[]]$script:NumberArray = $NumberHolder1,$NumberHolder2,$Flop1NumberHolder,$Flop2NumberHolder,$Flop3NumberHolder,$TurnNumberHolder
    [system.collections.arraylist]$script:SuitArray = $SuitHolder1,$SuitHolder2,$Flop1Suit,$Flop2Suit,$Flop3Suit,$TurnSuit
    $script:CounterHolder = 0
    Check-FullHouseComputer
    [system.collections.arraylist][int[]]$script:NumberArray = $NumberHolder1,$NumberHolder2,$Flop1NumberHolder,$Flop2NumberHolder,$Flop3NumberHolder,$TurnNumberHolder
    $script:CounterHolder = 0
    Check-FourOfAKind
    [system.collections.arraylist][int[]]$script:NumberArray = $NumberHolder1,$NumberHolder2,$Flop1NumberHolder,$Flop2NumberHolder,$Flop3NumberHolder,$TurnNumberHolder
    [system.collections.arraylist]$script:SuitArray = $SuitHolder1,$SuitHolder2,$Flop1Suit,$Flop2Suit,$Flop3Suit,$TurnSuit
    $script:CounterHolder = 0
    Check-StraightFlushComputer

    $script:ComputerHighestCard = $HighestCard
    $script:ComputerHandStrengthOverall = $HandStrengthHolder
    $script:HandStrengthHolder = 1
}

#Checks the handstrength overall of the computer
function Check-ComputerHandRiver {
    $script:NumberHolder1 = $CNumber1
    $script:NumberHolder2 = $CNumber2
    $script:SuitHolder1 = $CSuit1
    $script:SuitHolder2 = $CSuit2
    $script:Flop1NumberHolder = $Flop1Number
    $script:Flop2NumberHolder = $Flop2Number
    $script:Flop3NumberHolder = $Flop3Number
    $script:TurnNumberHolder = $TurnNumber
    $script:RiverNumberHolder = $RiverNumber

    if ($NumberHolder1 -eq "Ace") {$script:NumberHolder1 = 14} 
	if ($NumberHolder1 -eq "Jack") {$script:NumberHolder1 = 11} 
	if ($NumberHolder1 -eq "Queen") {$script:NumberHolder1 = 12} 	
	if ($NumberHolder1 -eq "King") {$script:NumberHolder1 = 13} 

    if ($NumberHolder2 -eq "Ace") {$script:NumberHolder2 = 14} 
	if ($NumberHolder2 -eq "Jack") {$script:NumberHolder2 = 11} 
	if ($NumberHolder2 -eq "Queen") {$script:NumberHolder2 = 12} 	
	if ($NumberHolder2 -eq "King") {$script:NumberHolder2 = 13}

    if ($Flop1Number -eq "Ace") {$script:Flop1NumberHolder = 14} 
	if ($Flop1Number -eq "Jack") {$script:Flop1NumberHolder = 11} 
	if ($Flop1Number -eq "Queen") {$script:Flop1NumberHolder = 12} 	
	if ($Flop1Number -eq "King") {$script:Flop1NumberHolder = 13}

    if ($Flop2Number -eq "Ace") {$script:Flop2NumberHolder = 14} 
	if ($Flop2Number -eq "Jack") {$script:Flop2NumberHolder = 11} 
	if ($Flop2Number -eq "Queen") {$script:Flop2NumberHolder = 12} 	
	if ($Flop2Number -eq "King") {$script:Flop2NumberHolder = 13}

    if ($Flop3Number -eq "Ace") {$script:Flop3NumberHolder = 14} 
	if ($Flop3Number -eq "Jack") {$script:Flop3NumberHolder = 11} 
	if ($Flop3Number -eq "Queen") {$script:Flop3NumberHolder = 12} 	
	if ($Flop3Number -eq "King") {$script:Flop3NumberHolder = 13}

    if ($TurnNumber -eq "Ace") {$script:TurnNumberHolder = 14} 
	if ($TurnNumber -eq "Jack") {$script:TurnNumberHolder = 11} 
	if ($TurnNumber -eq "Queen") {$script:TurnNumberHolder = 12} 	
	if ($TurnNumber -eq "King") {$script:TurnNumberHolder = 13}

    if ($RiverNumber -eq "Ace") {$script:RiverNumberHolder = 14} 
	if ($RiverNumber -eq "Jack") {$script:RiverNumberHolder = 11} 
	if ($RiverNumber -eq "Queen") {$script:RiverNumberHolder = 12} 	
	if ($RiverNumber -eq "King") {$script:RiverNumberHolder = 13}

    [system.collections.arraylist]$script:ComputerNumberArray = $NumberHolder1,$NumberHolder2,$Flop1NumberHolder,$Flop2NumberHolder,$Flop3NumberHolder,$TurnNumberHolder,$RiverNumberHolder
    [system.collections.arraylist][int[]]$script:NumberArray = $NumberHolder1,$NumberHolder2,$Flop1NumberHolder,$Flop2NumberHolder,$Flop3NumberHolder,$TurnNumberHolder,$RiverNumberHolder
    [system.collections.arraylist]$script:ComputerSuitArray = $SuitHolder1,$SuitHolder2,$Flop1Suit,$Flop2Suit,$Flop3Suit,$TurnSuit,$RiverSuit
    [system.collections.arraylist]$script:SuitArray = $SuitHolder1,$SuitHolder2,$Flop1Suit,$Flop2Suit,$Flop3Suit,$TurnSuit,$RiverSuit

    $script:CounterHolder = 0
    Check-OnePair
    [system.collections.arraylist][int[]]$script:NumberArray = $NumberHolder1,$NumberHolder2,$Flop1NumberHolder,$Flop2NumberHolder,$Flop3NumberHolder,$TurnNumberHolder,$RiverNumberHolder
    $script:CounterHolder = 0
    Check-TwoPair
    [system.collections.arraylist][int[]]$script:NumberArray = $NumberHolder1,$NumberHolder2,$Flop1NumberHolder,$Flop2NumberHolder,$Flop3NumberHolder,$TurnNumberHolder,$RiverNumberHolder
    $script:CounterHolder = 0
    Check-ThreeOfAKind
    [system.collections.arraylist][int[]]$script:NumberArray = $NumberHolder1,$NumberHolder2,$Flop1NumberHolder,$Flop2NumberHolder,$Flop3NumberHolder,$TurnNumberHolder,$RiverNumberHolder
    $script:CounterHolder = 0
    Check-Straight
    [system.collections.arraylist][int[]]$script:NumberArray = $NumberHolder1,$NumberHolder2,$Flop1NumberHolder,$Flop2NumberHolder,$Flop3NumberHolder,$TurnNumberHolder,$RiverNumberHolder
    [system.collections.arraylist]$script:SuitArray = $SuitHolder1,$SuitHolder2,$Flop1Suit,$Flop2Suit,$Flop3Suit,$TurnSuit,$RiverSuit
    $script:CounterHolder = 0
    Check-Flush
    [system.collections.arraylist][int[]]$script:NumberArray = $NumberHolder1,$NumberHolder2,$Flop1NumberHolder,$Flop2NumberHolder,$Flop3NumberHolder,$TurnNumberHolder,$RiverNumberHolder
    [system.collections.arraylist]$script:SuitArray = $SuitHolder1,$SuitHolder2,$Flop1Suit,$Flop2Suit,$Flop3Suit,$TurnSuit,$RiverSuit
    $script:CounterHolder = 0
    Check-FullHouseComputer
    [system.collections.arraylist][int[]]$script:NumberArray = $NumberHolder1,$NumberHolder2,$Flop1NumberHolder,$Flop2NumberHolder,$Flop3NumberHolder,$TurnNumberHolder,$RiverNumberHolder
    $script:CounterHolder = 0
    Check-FourOfAKind
    [system.collections.arraylist][int[]]$script:NumberArray = $NumberHolder1,$NumberHolder2,$Flop1NumberHolder,$Flop2NumberHolder,$Flop3NumberHolder,$TurnNumberHolder,$RiverNumberHolder
    [system.collections.arraylist]$script:SuitArray = $SuitHolder1,$SuitHolder2,$Flop1Suit,$Flop2Suit,$Flop3Suit,$TurnSuit,$RiverSuit
    $script:CounterHolder = 0
    Check-StraightFlushComputer

    $script:ComputerHighestCard = $HighestCard
    $script:ComputerHandStrengthOverall = $HandStrengthHolder
    $script:HandStrengthHolder = 1
}

#Checks the handstrength overall of the player
function Check-PlayerHand {
    $script:NumberHolder1 = $PNumber1
    $script:NumberHolder2 = $PNumber2
    $script:SuitHolder1 = $PSuit1
    $script:SuitHolder2 = $PSuit2
    $script:Flop1NumberHolder = $Flop1Number
    $script:Flop2NumberHolder = $Flop2Number
    $script:Flop3NumberHolder = $Flop3Number
    $script:TurnNumberHolder = $TurnNumber
    $script:RiverNumberHolder = $RiverNumber

    if ($NumberHolder1 -eq "Ace") {$script:NumberHolder1 = 14} 
	if ($NumberHolder1 -eq "Jack") {$script:NumberHolder1 = 11} 
	if ($NumberHolder1 -eq "Queen") {$script:NumberHolder1 = 12} 	
	if ($NumberHolder1 -eq "King") {$script:NumberHolder1 = 13} 

    if ($NumberHolder2 -eq "Ace") {$script:NumberHolder2 = 14} 
	if ($NumberHolder2 -eq "Jack") {$script:NumberHolder2 = 11} 
	if ($NumberHolder2 -eq "Queen") {$script:NumberHolder2 = 12} 	
	if ($NumberHolder2 -eq "King") {$script:NumberHolder2 = 13}

    if ($Flop1Number -eq "Ace") {$script:Flop1NumberHolder = 14} 
	if ($Flop1Number -eq "Jack") {$script:Flop1NumberHolder = 11} 
	if ($Flop1Number -eq "Queen") {$script:Flop1NumberHolder = 12} 	
	if ($Flop1Number -eq "King") {$script:Flop1NumberHolder = 13}

    if ($Flop2Number -eq "Ace") {$script:Flop2NumberHolder = 14} 
	if ($Flop2Number -eq "Jack") {$script:Flop2NumberHolder = 11} 
	if ($Flop2Number -eq "Queen") {$script:Flop2NumberHolder = 12} 	
	if ($Flop2Number -eq "King") {$script:Flop2NumberHolder = 13}

    if ($Flop3Number -eq "Ace") {$script:Flop3NumberHolder = 14} 
	if ($Flop3Number -eq "Jack") {$script:Flop3NumberHolder = 11} 
	if ($Flop3Number -eq "Queen") {$script:Flop3NumberHolder = 12} 	
	if ($Flop3Number -eq "King") {$script:Flop3NumberHolder = 13}

    if ($TurnNumber -eq "Ace") {$script:TurnNumberHolder = 14} 
	if ($TurnNumber -eq "Jack") {$script:TurnNumberHolder = 11} 
	if ($TurnNumber -eq "Queen") {$script:TurnNumberHolder = 12} 	
	if ($TurnNumber -eq "King") {$script:TurnNumberHolder = 13}

    if ($RiverNumber -eq "Ace") {$script:RiverNumberHolder = 14} 
	if ($RiverNumber -eq "Jack") {$script:RiverNumberHolder = 11} 
	if ($RiverNumber -eq "Queen") {$script:RiverNumberHolder = 12} 	
	if ($RiverNumber -eq "King") {$script:RiverNumberHolder = 13}

    [system.collections.arraylist]$script:PlayerNumberArray = $NumberHolder1,$NumberHolder2,$Flop1NumberHolder,$Flop2NumberHolder,$Flop3NumberHolder,$TurnNumberHolder,$RiverNumberHolder
    [system.collections.arraylist][int[]]$script:NumberArray = $NumberHolder1,$NumberHolder2,$Flop1NumberHolder,$Flop2NumberHolder,$Flop3NumberHolder,$TurnNumberHolder,$RiverNumberHolder
    [system.collections.arraylist]$script:PlayerSuitArray = $SuitHolder1,$SuitHolder2,$Flop1Suit,$Flop2Suit,$Flop3Suit,$TurnSuit,$RiverSuit
    [system.collections.arraylist]$script:SuitArray = $SuitHolder1,$SuitHolder2,$Flop1Suit,$Flop2Suit,$Flop3Suit,$TurnSuit,$RiverSuit

    $script:CounterHolder = 0
    Check-OnePair
    [system.collections.arraylist][int[]]$script:NumberArray = $NumberHolder1,$NumberHolder2,$Flop1NumberHolder,$Flop2NumberHolder,$Flop3NumberHolder,$TurnNumberHolder,$RiverNumberHolder
    $script:CounterHolder = 0
    Check-TwoPair
    [system.collections.arraylist][int[]]$script:NumberArray = $NumberHolder1,$NumberHolder2,$Flop1NumberHolder,$Flop2NumberHolder,$Flop3NumberHolder,$TurnNumberHolder,$RiverNumberHolder
    $script:CounterHolder = 0
    Check-ThreeOfAKind
    [system.collections.arraylist][int[]]$script:NumberArray = $NumberHolder1,$NumberHolder2,$Flop1NumberHolder,$Flop2NumberHolder,$Flop3NumberHolder,$TurnNumberHolder,$RiverNumberHolder
    $script:CounterHolder = 0
    Check-Straight
    [system.collections.arraylist][int[]]$script:NumberArray = $NumberHolder1,$NumberHolder2,$Flop1NumberHolder,$Flop2NumberHolder,$Flop3NumberHolder,$TurnNumberHolder,$RiverNumberHolder
    [system.collections.arraylist]$script:SuitArray = $SuitHolder1,$SuitHolder2,$Flop1Suit,$Flop2Suit,$Flop3Suit,$TurnSuit,$RiverSuit
    $script:CounterHolder = 0
    Check-Flush
    [system.collections.arraylist][int[]]$script:NumberArray = $NumberHolder1,$NumberHolder2,$Flop1NumberHolder,$Flop2NumberHolder,$Flop3NumberHolder,$TurnNumberHolder,$RiverNumberHolder
    [system.collections.arraylist]$script:SuitArray = $SuitHolder1,$SuitHolder2,$Flop1Suit,$Flop2Suit,$Flop3Suit,$TurnSuit,$RiverSuit
    $script:CounterHolder = 0
    Check-FullHouseComputer
    [system.collections.arraylist][int[]]$script:NumberArray = $NumberHolder1,$NumberHolder2,$Flop1NumberHolder,$Flop2NumberHolder,$Flop3NumberHolder,$TurnNumberHolder,$RiverNumberHolder
    $script:CounterHolder = 0
    Check-FourOfAKind
    [system.collections.arraylist][int[]]$script:NumberArray = $NumberHolder1,$NumberHolder2,$Flop1NumberHolder,$Flop2NumberHolder,$Flop3NumberHolder,$TurnNumberHolder,$RiverNumberHolder
    [system.collections.arraylist]$script:SuitArray = $SuitHolder1,$SuitHolder2,$Flop1Suit,$Flop2Suit,$Flop3Suit,$TurnSuit,$RiverSuit
    $script:CounterHolder = 0
    Check-StraightFlushComputer

    $script:PlayerHighestCard = $HighestCard
    $script:PlayerHandStrengthOverall = $HandStrengthHolder
    $script:HandStrengthHolder = 1
}

#Checks for a pair
function Check-OnePair {
    for ($i = 0 ; $i -lt ($NumberArray.count); $i += 1) {
        $script:HolderNumber = $NumberArray[$i]
        $NumberArray.remove($HolderNumber)
        if ($NumberArray.contains($HolderNumber)) {
            $script:HandStrengthHolder = 2
            $script:HighestCard = $HolderNumber
        }
    }
}
      
#Checks for two pair
function Check-TwoPair {
    for ($i = 0 ; $i -lt ($NumberArray.count); $i += 1) {
        $script:HolderNumber = $NumberArray[$i]
        $NumberArray.remove($HolderNumber)
        $script:CheckTrue = $NumberArray.contains($HolderNumber) 
        if ($CheckTrue -eq "True") {
            $script:CounterHolder = $CounterHolder + 1
            $script:CheckTrue = "False"
                if ($HolderNumber -gt $HighestCard) {
                    $script:HighestCard = $HolderNumber
                }
        }
    }
    if ($CounterHolder -ge 2) {
        $script:HandStrengthHolder = 3
    }
} 
    
#Checks for three of a kind
function Check-ThreeOfAKind {
    for ($i = 0 ; $i -lt ($NumberArray.count); $i += 1) {
        $script:HolderNumber = $NumberArray[$i]
        while ($NumberArray.contains($HolderNumber)) {
            $script:CounterHolder = ($CounterHolder + 1)
            $NumberArray.remove($HolderNumber)
                if ($CounterHolder -ge 3) {
                    $script:HandStrengthHolder = 4
                    $script:HighestCard = $HolderNumber
                }
        }
        $script:CounterHolder = 0
    }
} 

#Checks for a straight
function Check-Straight {
    $NumberArray.Sort() 
    for ($i = 0 ; $i -lt ($NumberArray.count - 1); $i += 1) {
        if (($NumberArray[$i] + 1) -eq $NumberArray[$i + 1]) {
            $script:CounterHolder = ($CounterHolder + 1)
            if($CounterHolder -ge 4) {
                $script:HandStrengthHolder = 5
                $script:HighestCard = $NumberArray[$i + 1]
            }
        }
        else {
            $script:CounterHolder = 0
        }
    }
} 

#Checks for a flush
function Check-Flush { 
    for ($i = 0 ; $i -lt ($SuitArray.count); $i += 1) {
        $script:HolderSuit = $SuitArray[$i]
        while ($SuitArray.contains($HolderSuit)) {
            $script:CounterHolder = ($CounterHolder + 1)
            $SuitArray.remove($HolderSuit)
                if ($CounterHolder -ge 5) {
                    $script:HandStrengthHolder = 6
                }
        }
        $script:CounterHolder = 0
    }
} 

#Checks for a full house for the computer
function Check-FullHouseComputer {
    $NumberArray.sort()
    for ($i = 0 ; $i -lt ($NumberArray.count); $i += 1) {
        $script:HolderNumber = $NumberArray[$i]
        while ($NumberArray.contains($HolderNumber)) {
            $script:CounterHolder = ($CounterHolder + 1)
            $NumberArray.remove($HolderNumber)
                if ($CounterHolder -ge 3) {
                    $script:HighestCard = $HolderNumber
                    [system.collections.arraylist]$script:NumberArray = $ComputerNumberArray
                    while ($NumberArray.contains($HolderNumber)) {
                        $NumberArray.remove($HolderNumber)
                    }
                    for ($i = 0 ; $i -lt ($NumberArray.count); $i += 1) {
                        $script:HolderNumber = $NumberArray[$i]
                        $NumberArray.removeat($i)
                        if ($NumberArray.contains($HolderNumber)) {
                            $script:HandStrengthHolder = 7
                            $script:HighestCardFullHouse = $HolderNumber
                        }
                    }
                }
        }
        $script:CounterHolder = 0
    }
}

#Checks for a full house for the player
function Check-FullHousePlayer {
    $NumberArray.sort()
    for ($i = 0 ; $i -lt ($NumberArray.count); $i += 1) {
        $script:HolderNumber = $NumberArray[$i]
        while ($NumberArray.contains($HolderNumber)) {
            $script:CounterHolder = ($CounterHolder + 1)
            $NumberArray.remove($HolderNumber)
                if ($CounterHolder -ge 3) {
                    $script:HighestCard = $HolderNumber
                    [system.collections.arraylist]$script:NumberArray = $PlayerNumberArray
                    while ($NumberArray.contains($HolderNumber)) {
                        $NumberArray.remove($HolderNumber)
                    }
                    for ($i = 0 ; $i -lt ($NumberArray.count); $i += 1) {
                        $script:HolderNumber = $NumberArray[$i]
                        $NumberArray.removeat($i)
                        if ($NumberArray.contains($HolderNumber)) {
                            $script:HandStrengthHolder = 7
                            $script:HighestCardFullHouse = $HolderNumber
                        }
                    }
                }
        }
        $script:CounterHolder = 0
    }
}

#Checks for four of a kind
function Check-FourOfAKind {
    for ($i = 0 ; $i -lt ($NumberArray.count); $i += 1) {
        $script:HolderNumber = $NumberArray[$i]
        while ($NumberArray.contains($HolderNumber)) {
            $script:CounterHolder = ($CounterHolder + 1)
            $NumberArray.remove($HolderNumber)
                if ($CounterHolder -ge 4) {
                    $script:HandStrengthHolder = 8
                    $script:HighestCard = $HolderNumber
                }
        }
        $script:CounterHolder = 0
    }
} 

#Checks for a straight flush for the player (includes royal flush)
function Check-StraightFlushPlayer {
    $NumberArray.Sort() 
    for ($i = 0 ; $i -lt ($NumberArray.count - 1); $i += 1) {
        if (($NumberArray[$i] + 1) -eq $NumberArray[$i + 1]) {
            $script:CounterHolder = ($CounterHolder + 1)
            if($CounterHolder -eq 1) {
                $script:StraightFlushHolder1 = $NumberArray[$i]
            }
            if($CounterHolder -eq 2) {
                $script:StraightFlushHolder2 = $NumberArray[$i]
            }
            if($CounterHolder -eq 3) {
                $script:StraightFlushHolder3 = $NumberArray[$i]
            }
            if($CounterHolder -eq 4) {
                $script:StraightFlushHolder4 = $NumberArray[$i]
            }
            if($CounterHolder -eq 5) {
                $script:StraightFlushHolder5 = $NumberArray[$i]
            }
        }
        else {
            $script:CounterHolder = 0
        }
    }
    if ($CounterHolder -ge 5) {
        [system.collections.arraylist]$script:NumberArray = $PlayerNumberArray
        $script:HolderNumber = $NumberArray.indexof($StraightFlushHolder1)
        $script:HolderSuit = $SuitArray[$HolderNumber]
        $script:HolderNumber = $NumberArray.indexof($StraightFlushHolder2)
        if ($SuitArray[$HolderNumber] -eq $HolderSuit) {
            $script:HolderNumber = $NumberArray.indexof($StraightFlushHolder3)
            if ($SuitArray[$HolderNumber] -eq $HolderSuit) {
                $script:HolderNumber = $NumberArray.indexof($StraightFlushHolder4)
                if ($SuitArray[$HolderNumber] -eq $HolderSuit) {
                    $script:HolderNumber = $NumberArray.indexof($StraightFlushHolder5)
                    if ($SuitArray[$HolderNumber] -eq $HolderSuit) {
                        $script:HandStrengthHolder = 9
                    }
                }
            }
        }
    }
}
        
#Checks for a straight flush for the computer (includes royal flush)
function Check-StraightFlushComputer {
    $NumberArray.Sort() 
    for ($i = 0 ; $i -lt ($NumberArray.count - 1); $i += 1) {
        if (($NumberArray[$i] + 1) -eq $NumberArray[$i + 1]) {
            $script:CounterHolder = ($CounterHolder + 1)
            if($CounterHolder -eq 1) {
                $script:StraightFlushHolder1 = $NumberArray[$i]
            }
            if($CounterHolder -eq 2) {
                $script:StraightFlushHolder2 = $NumberArray[$i]
            }
            if($CounterHolder -eq 3) {
                $script:StraightFlushHolder3 = $NumberArray[$i]
            }
            if($CounterHolder -eq 4) {
                $script:StraightFlushHolder4 = $NumberArray[$i]
            }
            if($CounterHolder -eq 5) {
                $script:StraightFlushHolder5 = $NumberArray[$i]
            }
        }
        else {
            $script:CounterHolder = 0
        }
    }
    if ($CounterHolder -ge 5) {
       [system.collections.arraylist] $script:NumberArray = $ComputerNumberArray
        $script:HolderNumber = $NumberArray.indexof($StraightFlushHolder1)
        $script:HolderSuit = $SuitArray[$HolderNumber]
        $script:HolderNumber = $NumberArray.indexof($StraightFlushHolder2)
        if ($SuitArray[$HolderNumber] -eq $HolderSuit) {
            $script:HolderNumber = $NumberArray.indexof($StraightFlushHolder3)
            if ($SuitArray[$HolderNumber] -eq $HolderSuit) {
                $script:HolderNumber = $NumberArray.indexof($StraightFlushHolder4)
                if ($SuitArray[$HolderNumber] -eq $HolderSuit) {
                    $script:HolderNumber = $NumberArray.indexof($StraightFlushHolder5)
                    if ($SuitArray[$HolderNumber] -eq $HolderSuit) {
                        $script:HandStrengthHolder = 9
                    }
                }
            }
        }
    }
}

#Gets the results if someone folds
function get-foldresults {
    if ($WhoFolded -eq "Player") {
        Write-Host ""
        Write-Host ""
        Write-Host "You Folded"        $script:ComputerStack = $ComputerStack + $MoneyInPot        Write-Host "Your stack size is `$$PlayerStack"
        Write-Host "Your opponent's stack size is `$$ComputerStack"
    }
    if ($WhoFolded -eq "Computer") {
        Write-Host ""
        Write-Host ""
        Write-Host "Opponent Folded"        $script:PlayerStack = $PlayerStack + $MoneyInPot        Write-Host "Your stack size is `$$PlayerStack"
        Write-Host "Your opponent's stack size is `$$ComputerStack"
    }
}






New-Poker

while (($playAgain -eq "True") -and ($StartGame -eq "True")) {
    	Play-Poker
    
    	$response = Read-Host "Press Enter to play again, S to see the game statistics, or Q to quit"
    		if ($response -eq "Q") {  
        		$script:playAgain = "False"
        		Get-Stats
			    $script:winnings = [math]::abs($playerStack-$computerStack)
				if ($playerStack -gt $computerStack) {
					write-host "You won `$$winnings"
                }
				else {
					write-host "You lost `$$winnings"
				}
        		Read-Host "Press enter to quit."
        		Clear-Host
   		    } 
    		if ($playerStack -eq 0) {
    		    $script:playAgain = "False"
        		Get-Stats
        		Read-Host "You lost `$5000. Press enter to quit."
        		Clear-Host
    		}
		    if ($computerStack -eq 0) {
        		$script:playAgain = "False"
        		Get-Stats
        		Read-Host "You won `$5000. Press enter to quit."
        		Clear-Host
    		}
    		if ($response -eq "S") {
        		Get-Stats
			    Read-Host "Press enter to continue."
			    $script:playAgain = "True"
    		}  
}
 
