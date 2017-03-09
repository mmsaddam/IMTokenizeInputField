//
//  TokenCell.swift
//  IMTokenizeInputField
//
//  Created by Muzahidul Islam on 3/9/17.
//  Copyright © 2017 Muzahidul Islam. All rights reserved.
//

import UIKit

class TokenCell: UICollectionViewCell, UIKeyInput {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    static let indentifier = "TokenCell"
    
    var hasText: Bool{
        return true
    }
    
    func insertText(_ text: String) {
        
    }
    
    func deleteBackward() {
        
    }
    
    override func resignFirstResponder() -> Bool {
        return super.resignFirstResponder()
    }
    
    override func becomeFirstResponder() -> Bool {
        return super.becomeFirstResponder()
    }
    
    override var canBecomeFirstResponder: Bool{
        return true
    }
}
