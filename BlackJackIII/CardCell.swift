//
//  CardCell.swift
//  BlackJackIII
//
//  Created by Jiaxin.Li on 3/15/15.
//  Copyright (c) 2015 jl6467. All rights reserved.
//

import UIKit

class CardCell: UICollectionViewCell {

	@IBOutlet var label: UILabel!
	@IBOutlet var topSuit: UILabel!
	@IBOutlet var bottomSuit: UILabel!
	
	override func awakeFromNib() {
		self.layer.masksToBounds = false
		
		self.layer.cornerRadius = 3.0
		self.layer.borderColor = UIColor.blackColor().CGColor
		self.layer.borderWidth = 1.0
		self.layer.shadowColor = UIColor.blackColor().CGColor
		self.layer.shadowOpacity = 0.8
		self.layer.shadowOffset = CGSizeMake(0, 1.5)
		self.layer.shadowRadius = 1.2
	}
	
	
	func setCard(card: Card) {
		label.text = card.rank.simpleDescription()
		topSuit.text = card.suit.simpleDescription()
		bottomSuit.text = card.suit.simpleDescription()
		
		if card.suit == Suit.Clubs || card.suit == Suit.Spades {
			label.textColor = UIColor.blackColor()
			topSuit.textColor = UIColor.blackColor()
			bottomSuit.textColor = UIColor.blackColor()
		}else {
			label.textColor = UIColor(red: 0.8, green: 0.207, blue: 0.207, alpha: 1)
			topSuit.textColor = UIColor(red: 0.8, green: 0.207, blue: 0.207, alpha: 1)
			bottomSuit.textColor = UIColor(red: 0.8, green: 0.207, blue: 0.207, alpha: 1)
		}
	}
}
