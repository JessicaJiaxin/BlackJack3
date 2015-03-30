//
//  AddBetViewController.swift
//  BlackJackIII
//
//  Created by Jiaxin.Li on 3/16/15.
//  Copyright (c) 2015 jl6467. All rights reserved.
//

import UIKit

protocol PlayerAddBetDelegate {
	func addBetForPlayer(bet: Int);
}

class AddBetViewController: UIViewController {
	@IBOutlet var hint: UILabel!
	
	@IBOutlet var moneyBet: UITextField!
	
	var money: Int!
	
	var delegate: PlayerAddBetDelegate!
	
	@IBAction func cancelClicked(sender: AnyObject) {
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	
	@IBAction func betClicked(sender: AnyObject) {
		
		
		if moneyBet.text.isEmpty {
			let alert = createAlertController("Warning", msg: "Bet should not be null.")
			presentViewController(alert, animated: false, completion: nil)
			return
		}
		
		let bet = moneyBet.text.toInt()
		
		if bet < 0 {
			let alert = createAlertController("Warning", msg: "Bet should more than 0$.")
			self.presentViewController(alert, animated: true, completion: nil)
			return
		}
		
		if bet > money {
			let alert = createAlertController("Warning", msg: "Bet should less than the money you have now.")
			presentViewController(alert, animated: true, completion: nil)
			return
		}
		
		delegate.addBetForPlayer(bet!)
		
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		hint.text = "You now have \(money)$"
	}
	
	
	func createAlertController(title: String, msg: String) -> UIAlertController {
		let alertViewController = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.Alert)
		
		let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
		
		alertViewController.addAction(okAction)
		
		return alertViewController;
	}
}
