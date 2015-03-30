//
//  Gamer.swift
//  BlackJackIII
//
//  Created by Jiaxin.Li on 3/15/15.
//  Copyright (c) 2015 jl6467. All rights reserved.
//

import Foundation

enum GameType: Int {
	case Win = 0, Lose, Tie, Out, None
}

class Gamer {
	let BLACK_JACK = 21
	
	var cards = [Card]()
	var cardSum = 0
	var gameType = GameType.None
	
	init(title: String){
		self.gameType = .None
	}
	
	func initCards(deck: Deck) {
		cards.append(deck.getRandomCard())
		cards.append(deck.getRandomCard())
		cardSum += cards[0].value
		cardSum += cards[1].value
		
		findAce()
	}
	
	func hitCard(deck: Deck) -> Bool {
		cards.append(deck.getRandomCard())
		cardSum += cards[cards.count - 1].value
		
		return true
	}
	
	func findAce() {
		if cardSum > BLACK_JACK {
			for card in cards {
				if card.value == 11 {
					card.value = 1
					cardSum -= 10
					break
				}
			}
		}
	}
	
	func turnOver() {
		cards.removeAll(keepCapacity: false)
		cardSum = 0
		gameType = GameType.None
	}
}