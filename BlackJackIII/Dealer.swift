//
//  Dealer.swift
//  BlackJackIII
//
//  Created by Jiaxin.Li on 3/15/15.
//  Copyright (c) 2015 jl6467. All rights reserved.
//

import Foundation

class Dealer: Gamer {
	override func initCards(deck: Deck) {
		super.initCards(deck)
		
		self.cards[1].canShow = false
	}
}