//
//  GameViewController.swift
//  BlackJackIII
//
//  Created by Jiaxin.Li on 3/15/15.
//  Copyright (c) 2015 jl6467. All rights reserved.
//

import UIKit

class GameViewController: UIViewController, PlayerAddBetDelegate {
	
	//Player Variables
	@IBOutlet var playerArea: UIView!
	@IBOutlet var playerCurrentBet: UILabel!
	@IBOutlet var playerMoney: UILabel!
	@IBOutlet var playerDeck: UICollectionView!
	@IBOutlet var playerGameStatus: UILabel!
	
	let playerProcessor = CardDeckProcessor()
	let playerLayout = CustomFlowLayout()
	
	//AIPlayer Variables
	@IBOutlet var aiArea: UIView!
	@IBOutlet var aiCurrentBet: UILabel!
	@IBOutlet var aiMoney: UILabel!
	@IBOutlet var aiDeck: UICollectionView!
	@IBOutlet var aiGameStatus: UILabel!
	
	let aiProcessor = CardDeckProcessor()
	let aiLayout = CustomFlowLayout()
	
	//Dealer Variables
	@IBOutlet var dealerArea: UIView!
	@IBOutlet var dealerDeck: UICollectionView!
	@IBOutlet var dealerGameStatus: UILabel!
	
	let dealerProcessor = CardDeckProcessor()
	let dealerLayout = CustomFlowLayout()
	
	private let CARD_CELL_IDENTIFER = "card"
	
	//other parameter
	let playground = Playground()
	let normalGamerBackgroundColor = UIColor(red: 242/255.0, green: 242/255.0, blue: 242/255.0, alpha: 1)
	let currentGamerBackgroundColor = UIColor(red: 46 / 255.0, green: 175/255.0, blue: 231/255.0, alpha: 1)
	var currentGamerView: UIView!
	
	var timer: NSTimer!
	var expectedValue: Int!
	
	//Operator Variables
	@IBOutlet var standBtn: UIBarButtonItem!
	@IBOutlet var hitBtn: UIBarButtonItem!
	@IBAction func standClicked(sender: AnyObject) {
		playerTurnOver()
	}
	
	@IBAction func hitClicked(sender: AnyObject) {
		let result = playground.hitCard(playground.player)
		addLastCardToGamer(playground.player, view: playerDeck, processor: playerProcessor)
		
		if !result {	//bust
			playerGameStatus.text = "Lose"
			playground.player.loseGame()
			
			//player turn over
			playerTurnOver()
		}
	}
	
	//Navigator Variables
	@IBAction func restartClicked(sender: AnyObject) {
        if currentGamerView != nil {
            currentGamerView.backgroundColor = normalGamerBackgroundColor
            currentGamerView = nil
        }
        
        playground.restartGame()
        updateLabels()
        
        clearGameStatus()
        clearCards()
	}
	
	private func playerControl(enabled: Bool) {
		//disable stand and hit
		standBtn.enabled = enabled
		hitBtn.enabled = enabled
	}
	
	private func playerTurnOver() {
		playerControl(false)
		playground.player.isTurnOver = true
		currentGamerView.backgroundColor = normalGamerBackgroundColor
		currentGamerView = aiArea
		currentGamerView.backgroundColor = currentGamerBackgroundColor
		aiTurn()
	}
	
	private func aiTurn() {
		expectedValue = Int(arc4random()) % 5 + 17	//AI
		
		timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "updateAI", userInfo: nil, repeats: true)
	}
	
	func updateAI() {
		if playground.ai.cardSum < expectedValue {
			let result = playground.hitCard(playground.ai)
			addLastCardToGamer(playground.ai, view: aiDeck, processor: aiProcessor)
			
			if !result {	//bust
				aiGameStatus.text = "Lose"
				playground.ai.loseGame()
			}
		}else {
			timer.invalidate()
			aiTurnOver()
		}
	}
	
	
	
	private func aiTurnOver() {
		playground.ai.isTurnOver = true
		currentGamerView.backgroundColor = normalGamerBackgroundColor
		currentGamerView = dealerArea
		currentGamerView.backgroundColor = currentGamerBackgroundColor
		
		dealerTurn()
	}
	
	private func dealerTurn() {
		//second card can be seen
		dealerProcessor.deck.removeLast()
		dealerDeck.deleteItemsAtIndexPaths([NSIndexPath(forRow: dealerProcessor.deck.count, inSection: 0)])
		playground.dealer.cards[1].canShow = true
		addLastCardToGamer(playground.dealer, view: dealerDeck, processor: dealerProcessor)
		
		if playground.player.gameType == GameType.Lose && playground.ai.gameType == GameType.Lose {
			playground.dealer.gameType = .Win
		}else {
			timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "updateDealer", userInfo: nil, repeats: true)
		}
	}
	
	func updateDealer() {
		if playground.dealer.cardSum < 17 {
			let result = playground.hitCard(playground.dealer)
			addLastCardToGamer(playground.dealer, view: dealerDeck, processor: dealerProcessor)
			
			if !result {	//bust
				playground.dealerBust()
			}
		}else {
			timer.invalidate()
			dealerTurnOver()
		}

	}
	
	private func dealerTurnOver() {
		let result = playground.finalDeal()
			
		playerGameStatus.text = result.0 == .Lose ? "Lose" : result.0 == .Win ? "Win" : "Tie"
		aiGameStatus.text = result.1 == .Lose ? "Lose" : result.1 == .Win ? "Win" : "Tie"
		dealerGameStatus.text = result.2 == .Lose ? "Lose" : result.2 == .Win ? "Win" : "Tie"
		
		currentGamerView.backgroundColor = normalGamerBackgroundColor
		
		playground.turnOver()
		
		updateLabels()
	}
	
	//PlayerAddBetDelegate
	func addBetForPlayer(bet: Int) {
		playground.player.bet = bet
		
		//ai bet money
		let bet = (Int(arc4random()) % playground.ai.money) / 4 + 1
		playground.ai.bet = bet
		
		updateLabels()
		
		clearGameStatus()
		clearCards()
		
		//init cards
		playground.initNewGame()
		
		addCardsToGamer(playground.player, view: playerDeck, processor: playerProcessor)
		addCardsToGamer(playground.ai, view: aiDeck, processor: aiProcessor)
		addCardsToGamer(playground.dealer, view: dealerDeck, processor: dealerProcessor)
		
		//playerTurn start
		playerControl(true)
		
		currentGamerView = playerArea
		currentGamerView.backgroundColor = currentGamerBackgroundColor
	}
	
	func clearGameStatus() {
		playerGameStatus.text = ""
		aiGameStatus.text = ""
		dealerGameStatus.text = ""
	}
	
	func clearCards() {
		while !playerProcessor.deck.isEmpty {
			playerProcessor.deck.removeLast()
			playerDeck.deleteItemsAtIndexPaths([NSIndexPath(forRow: playerProcessor.deck.count, inSection: 0)])
		}
		
		while !aiProcessor.deck.isEmpty {
			aiProcessor.deck.removeLast()
			aiDeck.deleteItemsAtIndexPaths([NSIndexPath(forRow: aiProcessor.deck.count, inSection: 0)])
		}
		
		while !dealerProcessor.deck.isEmpty {
			dealerProcessor.deck.removeLast()
			dealerDeck.deleteItemsAtIndexPaths([NSIndexPath(forRow: dealerProcessor.deck.count, inSection: 0)])
		}
	}
	
	func addCardsToGamer(gamer: Gamer, view: UICollectionView, processor: CardDeckProcessor) {
		for item in gamer.cards {
			processor.deck.append(item)
			view.insertItemsAtIndexPaths([NSIndexPath(forRow: processor.deck.count - 1, inSection: 0)])
		}
	}
	
	func addLastCardToGamer(gamer: Gamer, view: UICollectionView, processor: CardDeckProcessor) {
		processor.deck.append(gamer.cards.last!)
		view.insertItemsAtIndexPaths([NSIndexPath(forRow: processor.deck.count - 1, inSection: 0)])
	}
	
	/**-----------------------------
	Override method
	-------------------------------*/
	override func viewDidLoad() {
		super.viewDidLoad()
		
		initializeDecks()
		
		updateLabels()
		
		playerControl(false)
	}
	
	func initializeDecks() {
		let cardCellNib = UINib(nibName: "CardCell", bundle: nil)
		
		initializeDeck(cardCellNib, view: playerDeck, processor: playerProcessor)
		initializeDeck(cardCellNib, view: aiDeck, processor: aiProcessor)
		initializeDeck(cardCellNib, view: dealerDeck, processor: dealerProcessor)
		
		playerDeck.collectionViewLayout = playerLayout
		aiDeck.collectionViewLayout = aiLayout
		dealerDeck.collectionViewLayout = dealerLayout
		
		//game status
		clearGameStatus()
	}
	
	func initializeDeck(cardCellNib: UINib, view: UICollectionView, processor: CardDeckProcessor) {
		view.registerNib(cardCellNib, forCellWithReuseIdentifier: CARD_CELL_IDENTIFER)
		view.dataSource = processor
		view.delegate = processor
	}
	
	func updateLabels() {
		playerMoney.text = "Money: \(playground.player.money)$"
		playerCurrentBet.text = "Bet: \(playground.player.bet)$"
		
		aiMoney.text = "Money: \(playground.ai.money)$"
		aiCurrentBet.text = "Bet: \(playground.ai.bet)$"
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "addBet" {
			let viewController = segue.destinationViewController as AddBetViewController
			viewController.money = playground.player.money
			viewController.delegate = self
		}
	}
}
