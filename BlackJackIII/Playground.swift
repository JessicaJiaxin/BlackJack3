//
//  Playground.swift
//  BlackJackIII
//
//  Created by Jiaxin.Li on 3/15/15.
//  Copyright (c) 2015 jl6467. All rights reserved.
//

import Foundation

class Playground: NSObject {
	private let MAX_TURN = 5
	
	var turn = 1
	
	var player = Player(title: "Player")
	var ai = AIPlayer(title: "AI")
	var dealer = Dealer(title: "Dealer")
	
	let deck = Deck(numOfDecks: 2)
	
	func initNewGame() {
		player.initCards(deck)
		ai.initCards(deck)
		dealer.initCards(deck)
	}
	
	
	func hitCard(gamer: Gamer) -> Bool {
		return gamer.hitCard(deck)
	}
	
	func turnOver() {
		player.turnOver()
		ai.turnOver()
		dealer.cards[1].canShow = false
		dealer.turnOver()
		
		turn += 1
		
		if turn > MAX_TURN {
			deck.shuffleCards()
		}
	}
    
    func restartGame() {
        player.resetGame()
        ai.resetGame()
        dealer.turnOver()
        
        deck.shuffleCards()
    }
	
	func dealerBust() {
		dealer.gameType = .Lose
		
		if player.gameType != .Lose {
			player.gameType = .Win
			player.winGame()
		}
		
		if ai.gameType != .Lose {
			ai.gameType = .Win
			ai.winGame()
		}
	}
	
	func finalDeal() -> (GameType, GameType, GameType){
		
		if dealer.gameType == .Lose {
			if player.gameType != .Lose {
				player.gameType = .Win
			}
			
			if ai.gameType != .Lose {
				ai.gameType = .Win
			}
			
			return (player.gameType, ai.gameType, dealer.gameType)
		}
		
		if player.gameType != .Lose {
			compareWithDealer(player)
		}
		
		if ai.gameType != .Lose {
			compareWithDealer(ai)
		}
		
		if player.gameType == .Win || ai.gameType == .Win {
			dealer.gameType = .Lose
		}else if player.gameType == .Lose && player.gameType == .Lose {
			dealer.gameType = .Win
		}
		
		return (player.gameType, ai.gameType, dealer.gameType)
	}
	
	func compareWithDealer(player: Player) {
		if dealer.cardSum > 21 {
			player.gameType = .Win
			return
		}
		
		if player.gameType != .Lose {
			if player.cardSum > dealer.cardSum {
				player.gameType = .Win
				player.winGame()
			}else if player.cardSum < dealer.cardSum {
				player.gameType = .Lose
				player.loseGame()
			}else if dealer.cardSum == dealer.BLACK_JACK && player.cards.count == 2 && player.cards.count == dealer.cards.count {	//black Jack
				player.gameType = .Tie
				dealer.gameType = .Tie
			}else {
				player.gameType = .Lose
				player.loseGame()
			}
		}else {
			player.gameType == .Lose
			player.loseGame()
		}
	}
}
