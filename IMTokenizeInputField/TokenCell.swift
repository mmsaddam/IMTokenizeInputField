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
    
    var nameLabel = UILabel()
    
    static let indentifier = "TokenCell"
    
    var delegate: TokenCellDelegate?
    
    var token: Token?
    
    override func awakeFromNib() {
    }
    override func layoutSubviews() {
        let superSize = self.frame.size
        nameLabel.frame = CGRect(x: 5.0, y: 0.0, width: superSize.width - 10, height: superSize.height)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonSetup()
    }
    
    func commonSetup() {
        backgroundColor = UIColor.white
        nameLabel.textAlignment = .center
        nameLabel.font = UIFont.systemFont(ofSize: 17)
        nameLabel.backgroundColor = UIColor.green
        addSubview(nameLabel)
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



