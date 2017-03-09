//
//  TokenCell.swift
//  IMTokenizeInputField
//
//  Created by Muzahidul Islam on 3/9/17.
//  Copyright © 2017 Muzahidul Islam. All rights reserved.
//

import UIKit

protocol TokenCellDelegate {
    func willRemove(_ cell: TokenCell)
}

protocol TokenCellDecorable {
    var token: Token? { get set}
}

class TokenCell: UICollectionViewCell,TokenCellDecorable, UIKeyInput {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    static let indentifier = "TokenCell"
    
    var delegate: TokenCellDelegate?
    
    var token: Token?
    
    override func awakeFromNib() {
        
    }
    
    
    var hasText: Bool{
        return true
    }
    
    func insertText(_ text: String) {
        
    }
    
    func deleteBackward() {
        delegate?.willRemove(self)
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
