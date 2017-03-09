//
//  IMTokenInputView.swift
//  IMTokenizeInputField
//
//  Created by Muzahidul Islam on 3/9/17.
//  Copyright © 2017 Muzahidul Islam. All rights reserved.
//

import UIKit

 protocol IMTokenInputViewDelegate {
    func tokenInputView(_ tokenInputView: IMTokenInputView, didSelect token: Token)
    func tokenInputView(_ tokenInputView: IMTokenInputView, didAdd token: Token)
    func tokenInputView(_ tokenInputView: IMTokenInputView, didRemove token: Token)
    
}

class IMTokenInputView: UIView {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBInspectable var padding: (leading: CGFloat,tralling: CGFloat) = (leading: 10.0, tralling: 10.0)
    
    var allTokens: [Token] = []
    var delegate: IMTokenInputViewDelegate?
    
    override func awakeFromNib() {
        collectionView?.delegate = self
        collectionView?.dataSource = self
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    func commonInit() {
        allTokens = [
            Token(name: "Hello", id: NSDate()), Token(name: "Hello", id: NSDate()), Token(name: "Hello world", id: NSDate()), Token(name: "Hello", id: NSDate())
        ]
    }
    
    func addToken(_ token: Token) -> Bool {
        if allTokens.contains(token) {
            print("Already Added....")
            return false
        } else {
            allTokens.append(contentsOf: [token])
            
            // TODO: - Scroll to new item
            collectionView.reloadData()
            delegate?.tokenInputView(self, didAdd: token)
            return true
        }
    }
    
    func removeToken(_ token: Token) -> Bool {
        let isRemoved = allTokens.removeObject(obj: token)
        if isRemoved {
            delegate?.tokenInputView(self, didRemove: token)
        }
        return isRemoved
    }
}

extension IMTokenInputView: TokenCellDelegate {
    func willRemove(_ cell: TokenCell) {
        if let token = cell.token {
            if removeToken(token) {
                collectionView?.reloadData()
            }
        }
    }
}

//---------------------------------------------------
// MARK: - FlowLayout Delegate
//---------------------------------------------------

extension IMTokenInputView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let tokenString = allTokens[indexPath.section].name as NSString
        
        let size: CGSize = tokenString.size(attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 19)])
        
        return CGSize(width: size.width + padding.leading + padding.tralling, height: size.height)
    }
}



//---------------------------------------------------
// MARK: - CollectionView Datasource
//---------------------------------------------------

extension IMTokenInputView: UICollectionViewDataSource {
    
    /*
     ----------------------------
     | item 1 | item 2 | item 3 |
     ----------------------------
     */
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return allTokens.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TokenCell.indentifier, for: indexPath) as! TokenCell
        cell.token = allTokens[indexPath.section]
        cell.delegate = self
        cell.nameLabel.text = allTokens[indexPath.section].name
        cell.nameLabel.sizeToFit()
        cell.nameLabel.superview?.sizeToFit()
        return cell
    }
    
}

extension IMTokenInputView: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? TokenCell
        if cell?.isFirstResponder ?? false {
            _ = cell?.resignFirstResponder()
        } else {
            _ = cell?.becomeFirstResponder()
        }
    }
}



