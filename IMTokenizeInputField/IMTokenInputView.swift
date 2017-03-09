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

protocol IMTokenInutViewProtocol {
    var tokens: [Token] { get }
}

class IMTokenInputView: UIView, IMTokenInutViewProtocol {
    
    var collectionView: UICollectionView!
    
    @IBInspectable var padding: (leading: CGFloat,tralling: CGFloat) = (leading: 10.0, tralling: 10.0)
    
    fileprivate var allTokens: [Token] = []
    
    var tokens: [Token] {
        return self.allTokens
    }
    
    var delegate: IMTokenInputViewDelegate?
    
    override func awakeFromNib() {
        collectionView.register(TokenCell.self,         forCellWithReuseIdentifier: TokenCell.indentifier)
        collectionView.backgroundColor = UIColor.blue
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.reloadData()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override func layoutSubviews() {
        collectionView.frame = bounds
    }
    
    func commonInit() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0.0
        layout.minimumLineSpacing = 0.0
        layout.estimatedItemSize = CGSize.zero
        layout.scrollDirection = .horizontal
        collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        addSubview(collectionView)
        
        allTokens = [
            Token(name: "Hello 1", id: NSDate()), Token(name: "Hello 2", id: NSDate()), Token(name: "Hello world 1", id: NSDate()), Token(name: "Hello 3", id: NSDate()), Token(name: "Hello 1", id: NSDate()), Token(name: "Hello 2", id: NSDate()), Token(name: "Hello world 1", id: NSDate()), Token(name: "Hello 3", id: NSDate())
        ]
    }
    
    //---------------------------------------------------
    // MARK: - Public Method
    //---------------------------------------------------

    public func tokenInputView(addToken token:Token) {
        if addToken(token) {
            // TODO: - Scroll to new item
            collectionView.reloadData()
            delegate?.tokenInputView(self, didAdd: token)
        }
    }
    
    public func tokenInputView(remove token:Token) {
        if removeToken(token) {
            collectionView.reloadData()
            delegate?.tokenInputView(self, didRemove: token)
        }
    }
    
    
    //---------------------------------------------------
    // MARK: - Private Method
    //---------------------------------------------------
    
    fileprivate func addToken(_ token: Token) -> Bool {
        if allTokens.contains(token) {
            print("Already Added....")
            return false
        } else {
            allTokens.append(contentsOf: [token])
            return true
        }
    }
    
    fileprivate func removeToken(_ token: Token) -> Bool {
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



