//
//  CardDeckProcessor.swift
//  BlackJackIII
//
//  Created by Jiaxin.Li on 3/15/15.
//  Copyright (c) 2015 jl6467. All rights reserved.
//

import UIKit

class CardDeckProcessor: NSObject, UICollectionViewDataSource, UICollectionViewDelegate {
	private let CARD_CELL_IDENTIFER = "card"
	
	var deck = [Card]()
	
	override init() {
		super.init()
	}
	
	func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
		return 1
	}
	
	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return deck.count
	}
	
	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier(CARD_CELL_IDENTIFER, forIndexPath: indexPath) as CardCell
		cell.layer.shadowPath = UIBezierPath(rect: cell.bounds).CGPath	//it's important to set shadowPath at here
		
		let card = deck[indexPath.row]
		
		if card.canShow {
			cell.setCard(card)
		}
		
		return cell
	}
	
	func reset() {
		deck.removeAll(keepCapacity: false)
	}
	
	func addCardToDeck(card: Card) {
		deck.append(card)
	}
	
	func removeCardFromDeck(card: Card) {
		if deck.count < 1 {return}
	}
}
