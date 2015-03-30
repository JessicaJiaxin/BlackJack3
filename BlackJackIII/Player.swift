//
//  Player.swift
//  BlackJackIII
//
//  Created by Jiaxin.Li on 3/15/15.
//  Copyright (c) 2015 jl6467. All rights reserved.
//

import Foundation

class Player: Gamer {
	var money = 100
	var bet = 0
	var isTurnOver = false
	
	override func hitCard(deck: Deck) -> Bool {
		super.hitCard(deck)
		
		findAce()
		
		//bust
		if cardSum > BLACK_JACK {
			isTurnOver = true
			gameType = GameType.Lose
			return false
		}
		
		return true
	}
	
	func winGame() {
		gameType = .Win
		money += bet
		bet = 0
	}
	
	func loseGame() {
		gameType = .Lose
		money -= bet
		bet = 0
	}
    
    func resetGame() {
        self.turnOver()
        bet = 0
    }
}