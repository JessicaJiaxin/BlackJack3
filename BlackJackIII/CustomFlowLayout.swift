//
//  CustomFlowLayout.swift
//  BlackJackIII
//
//  Created by Jiaxin.Li on 3/17/15.
//  Copyright (c) 2015 jl6467. All rights reserved.
//

import UIKit

class CustomFlowLayout: UICollectionViewFlowLayout {
	
	override init() {
		super.init()
		
		self.itemSize = CGSizeMake(35, 48)
	}

	required init(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	
	override func initialLayoutAttributesForAppearingItemAtIndexPath(itemIndexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
		let attrs = self.layoutAttributesForItemAtIndexPath(itemIndexPath)
		
		attrs.transform = CGAffineTransformRotate(CGAffineTransformMakeScale(0.2, 0.2), CGFloat(M_PI));
		attrs.center = CGPointMake(CGRectGetMidX(self.collectionView!.bounds), CGRectGetMaxY(self.collectionView!.bounds))
		
		return attrs
	}
}
