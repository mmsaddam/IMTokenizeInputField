//
//  CustomFlowLayout.swift
//  IMTokenizeInputField
//
//  Created by Muzahidul Islam on 3/11/17.
//  Copyright © 2017 Muzahidul Islam. All rights reserved.
//

import UIKit

class CustomFlowLayout: UICollectionViewFlowLayout {
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
		scrollDirection = .horizontal
	}

}
