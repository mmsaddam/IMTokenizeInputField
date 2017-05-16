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
    
    struct Identifier {
        static let common = "TokenCell"
        static let last = "LastTokenCell"
    }
    
    

    var delegate: TokenCellDelegate?
    var token: Token?
    let cornerRadius = 20.0
    
    var contentInset: UIEdgeInsets = UIEdgeInsets.zero {
        didSet{
            updateCorners()
            layoutIfNeeded()
        }
    }
    
    var isActive = false {
        didSet{
            backgroundColor = isActive ? Utils.Color.tokenSelectedColor : Utils.Color.CellBgColor
            textField.textColor = isActive ? .white : .black
            setNeedsDisplay()
        }
    }
    
    override func awakeFromNib() {
        
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        updateCorners()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textField.frame = CGRect(x: contentInset.left, y: contentInset.top, width: bounds.size.width - (contentInset.left + contentInset.right), height: bounds.size.height - (contentInset.top + contentInset.bottom))
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        updateCorners()
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
       // mask.lineWidth = 7.0
       // mask.strokeColor = isActive ?  UIColor.white.cgColor : UIColor.red.cgColor
        mask.path = path.cgPath
        self.layer.mask = mask
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



