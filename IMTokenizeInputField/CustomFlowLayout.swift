//
//  CustomFlowLayout.swift
//  IMTokenizeInputField
//
//  Created by Muzahidul Islam on 3/11/17.
//  Copyright © 2017 Muzahidul Islam. All rights reserved.
//

import UIKit

class CustomFlowLayout: UICollectionViewFlowLayout {
    
    var scrollerDireciton: UICollectionViewScrollDirection = .horizontal
    override init() {
        super.init()
		setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
		setup()

    }
	
	// MARK: Set up
	func setup() {
		minimumInteritemSpacing = 5.0
		scrollDirection = scrollerDireciton
        sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
	}

}
