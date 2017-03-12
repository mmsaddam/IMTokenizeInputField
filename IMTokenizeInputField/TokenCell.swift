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
    
    var textField: TokenTextField = TokenTextField()
    static let indentifier = "TokenCell"
    
    var delegate: TokenCellDelegate?
    var token: Token?
    let cornerRadius = 4.0
    
    var contentInset: UIEdgeInsets = UIEdgeInsets.zero {
        didSet{
            updateCorners()
            layoutIfNeeded()
        }
    }
    
    var tokenIsSelected = false {
        didSet{
            backgroundColor = tokenIsSelected ? Utils.Color.tokenSelectedColor : Utils.Color.CellBgColor
        }
    }
    
    override func awakeFromNib() {
        
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
    }
    
    override func layoutSubviews() {
        super.layoutIfNeeded()
        textField.frame = CGRect(x: contentInset.left, y: contentInset.top, width: bounds.size.width - (contentInset.left + contentInset.right), height: bounds.size.height - (contentInset.top + contentInset.bottom))
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
        backgroundColor = Utils.Color.CellBgColor
        addSubview(textField)

    }
    func updateCorners() {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
        setNeedsLayout()
    }
    
    //---------------------------------------------------
    // MARK: - UIKeyInput Override Method
    //---------------------------------------------------
    
    var hasText: Bool{
        return false
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



