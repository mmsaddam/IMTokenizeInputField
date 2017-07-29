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

public enum CellType {
    case placeholder
    case `default`
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
    
    var type: CellType = .default {
        didSet {
            fitToType()
        }
    }
    var contentInset: UIEdgeInsets = UIEdgeInsets.zero {
        didSet{
            updateCorners()
            layoutIfNeeded()
        }
    }
    
    /// Cell become selected or deselected
    /// There is some difference between selected and responding cell.
    /// Responding cell means for which key is appeared but hasSelected means the cell is ready for action
    
    var hasSelected = false {
        didSet{
            backgroundColor = hasSelected ? Utils.Color.tokenSelectedColor : Utils.Color.CellBgColor
            textField.textColor = hasSelected ? .white : .black
            setNeedsDisplay()
        }
    }
    
    override func awakeFromNib() {
        
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        updateCorners()
        setConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setConstraints()
       // textField.frame = CGRect(x: contentInset.left, y: contentInset.top, width: bounds.size.width - (contentInset.left + contentInset.right), height: bounds.size.height - (contentInset.top + contentInset.bottom))
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
        textField.translatesAutoresizingMaskIntoConstraints = false

    }
    func setConstraints() {
        addConstraint(NSLayoutConstraint(item: textField, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leadingMargin, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: textField, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailingMargin, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: textField, attribute: .top, relatedBy: .equal, toItem: self, attribute: .topMargin, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: textField, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottomMargin, multiplier: 1, constant: 0))
    }
    func updateCorners() {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    private func fitToType() {
        textField.textAlignment = type == .default ? .center : .left
        textField.isUserInteractionEnabled = type == .default ? false : true
        textField.textColor = UIColor.black
        textField.text = ""
        hasSelected = false
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



