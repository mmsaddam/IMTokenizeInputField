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
    func tokenInputViewDidBeginEditing(_ tokenInputView: IMTokenInputView)
    func tokenInputViewDidEndEditing(_ tokenInputView: IMTokenInputView)
    func tokenInputView(_ tokenInputView: IMTokenInputView, didChangeText text : String)
}

protocol IMTokenInutViewProtocol {
    var tokens: [Token] { get }
}

class IMTokenInputView: UIView, IMTokenInutViewProtocol {
    
    // MARK: Properties
    
    fileprivate var collectionView: UICollectionView!
    fileprivate var layout:CustomFlowLayout = CustomFlowLayout()
    fileprivate var minTokenHeight: CGFloat = 40.0
    fileprivate var minTokenWidth: CGFloat = 50.0

    fileprivate var defaultFont: UIFont = UIFont.systemFont(ofSize: 17)
    fileprivate var searchFieldWidth: CGFloat = 150
    fileprivate var collectionViewPadding: (left: CGFloat, right: CGFloat) = (left: 5.0, right: 5.0)
    var tokenHeight: CGFloat = 40.0 {
        didSet {
            if tokenHeight < minTokenHeight {
                tokenHeight = minTokenHeight
            }
        }
    }
    @IBInspectable var tokenContentInset: UIEdgeInsets = UIEdgeInsets(top: 5.0, left: 7.0, bottom: 5.0, right: 7.0)
    @IBInspectable var tokenFont: UIFont = UIFont.systemFont(ofSize: 17)
    
    fileprivate var allTokens: [Token] = []
    fileprivate var respondingCell: TokenCell?
    var tokens: [Token] {
        return self.allTokens
    }
    
    var delegate: IMTokenInputViewDelegate?
    
    override func awakeFromNib() {
        collectionView.register(TokenCell.self, forCellWithReuseIdentifier: TokenCell.Identifier.common)
        collectionView.register(TokenCell.self, forCellWithReuseIdentifier: TokenCell.Identifier.last)
        collectionView.backgroundColor = Utils.Color.collectionViewBgColor
        collectionView.delegate = self
        collectionView.dataSource = self
        allTokens.append(generateToken(for: "first", id: "first"))
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
        super.layoutSubviews()
        collectionView.frame = CGRect(x: collectionViewPadding.left, y: 0, width: bounds.width - (collectionViewPadding.left + collectionViewPadding.right), height: bounds.height)
    }
    
    // MARK: Initial Setup
    
   private func commonInit() {
        collectionView = UICollectionView(frame: bounds, collectionViewLayout: layout)
        collectionView.bounces = true
        collectionView.alwaysBounceHorizontal = true
        addSubview(collectionView)
    }
    
    //---------------------------------------------------
    // MARK: - Public Method
    //---------------------------------------------------
    
    
    //---------------------------------------------------
    // MARK: - Add Remove Token
    //---------------------------------------------------
    
    fileprivate func addToken(_ token:Token) {
        if !allTokens.contains(token) {
            allTokens.append(token)
            self.collectionView.reloadData()
            self.scrollToLastItem()
            self.delegate?.tokenInputView(self, didAdd: token)
        } else {
            print("already added...")
        }
    }
   
    fileprivate func removeToken(_ token:Token) {
        let isRemoved = allTokens.removeObject(obj: token)
        if isRemoved {
            self.collectionView.reloadData()
            self.delegate?.tokenInputView(self, didRemove: token)
        }
    }
    
    //-------------------------------
    //MARK: - Helper Methods
    //-------------------------------

   fileprivate func isLastItem(for indexPath: IndexPath) -> Bool {
        let totalSections = collectionView.numberOfSections
        let totalItemInSection = collectionView.numberOfItems(inSection: totalSections - 1)
        return (indexPath.item == (totalItemInSection - 1) )
            && (totalSections - 1) == indexPath.section
    }
    
   fileprivate func scrollToLastItem() {
        
        let sections = collectionView.numberOfSections
        let items = collectionView.numberOfItems(inSection: sections - 1)
        let lastIndexPath = IndexPath(item: items - 1, section: sections - 1)
        collectionView.scrollToItem(at: lastIndexPath, at: .left, animated: true)
    
    }
    
    fileprivate func removeItem(at indexPath: IndexPath) {
        
        self.collectionView.performBatchUpdates({
            self.collectionView.deleteItems(at: [indexPath])
        }, completion: nil)
        
    }
    
    fileprivate func calculateCellSize(for tokenStr: String = "", atIndexPath indexPath: IndexPath) -> CGSize {
        
        let totalVInset = tokenContentInset.top + tokenContentInset.bottom
        let totalHInset = tokenContentInset.left + tokenContentInset.right
        
        
        var strSize = tokenStr.getSize(font: tokenFont)
        
        if (strSize.height > (tokenHeight - totalVInset)) {
            strSize = tokenStr.getSize(font: defaultFont)
        }
        
        var cellWidth: CGFloat = 0.0
        
        if isLastItem(for: indexPath) {
            cellWidth = searchFieldWidth
        } else {
            cellWidth = strSize.width + totalHInset
        }
        
        return CGSize(width: max(minTokenWidth, cellWidth), height: tokenHeight)
        
    }
    
    
}

// MARK: - Add, Get, Remove Token

extension IMTokenInputView {
    
    public func addTokenFor(name: String, id: String) {
       let newToken = generateToken(for: name, id: id)
        addToken(newToken)
    }
    public func removeTokenFor(id: String) {
        guard let token = getToken(for: id) else {
            print("token not found for id \(id)")
            return
        }
        removeToken(token)
    }
    
    public func getToken(for id: String) -> Token? {
        return allTokens.filter { $0.id == id }.first
    }
    
    func generateToken(for name: String, id: String) -> Token {
        return Token(name: name, id: id)
    }
}


// MARK: TokenCell Delegate

extension IMTokenInputView: TokenCellDelegate {
    func willRemove(_ cell: TokenCell) {
        if let token = cell.token {
            let isRemoved = allTokens.removeObject(obj: token)
            if isRemoved {
                self.respondingCell = nil                
                if let indexPath = self.collectionView.indexPath(for: cell) {
                    self.removeItem(at: indexPath)
                } else {
                    print("Path not found...")
                }
            }
            
        }
    }
}


// MARK: - UITextField Delegate

extension IMTokenInputView: UITextFieldDelegate, IMDeleteBackwardDetectingTextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // did not work, need to fix
        endEditing(true) // forcefull resign responder
        return true
    }
    
    func textFieldDeleteBackward(_ textField: TokenTextField) {
        
        if allTokens.count > 0 {
            let indexPath = IndexPath(item: allTokens.count - 1, section: 0)
            guard let cell: TokenCell = collectionView.cellForItem(at: indexPath) as? TokenCell else {
                return
            }
            if cell.isActive {
                _ = cell.becomeFirstResponder()
                return
            } else {
                respondingCell?.isActive = false
                cell.isActive = true
                respondingCell = cell
                _ = cell.becomeFirstResponder()
            }
        }
        
    }
    
    func onTextFieldDidChange(_ textField: UITextField) {
        delegate?.tokenInputView(self, didChangeText: textField.text ?? "")
    }
    
}

// MARK: - CollectionView Datasource

extension IMTokenInputView: UICollectionViewDataSource {
    
    /*
     ----------------------------
     | item 1 | item 2 | item 3 |
     ----------------------------
     */
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1 + allTokens.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell: TokenCell
        
        if isLastItem(for: indexPath) {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: TokenCell.Identifier.last, for: indexPath) as! TokenCell
            cell.textField.isUserInteractionEnabled = true
            cell.textField.textColor = UIColor.black
            cell.textField.text = ""
            cell.textField.delegate = self
            cell.textField.addTarget(self, action: #selector(IMTokenInputView.onTextFieldDidChange(_:)), for: .editingChanged)
            cell.textField.backwardDelegate = self
            cell.textField.textAlignment = .left
        } else {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: TokenCell.Identifier.common, for: indexPath) as! TokenCell
            cell.delegate = self
            cell.token = allTokens[indexPath.item]
            cell.isActive = false
            cell.textField.text = allTokens[indexPath.item].name
            cell.textField.textAlignment = .center
            
        }
        
        cell.textField.font = tokenFont
        cell.contentInset = tokenContentInset
        
        return cell
        
    }
    
}


//---------------------------------------------------
// MARK: - FlowLayout Delegate
//---------------------------------------------------

extension IMTokenInputView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if isLastItem(for: indexPath) {
            return calculateCellSize(atIndexPath: indexPath)
        }
        return calculateCellSize(for: allTokens[indexPath.item].name, atIndexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        
        let colVHeight = self.collectionView.frame.size.height
        let topInset = (colVHeight - tokenHeight) / 2
        let bottomInset = topInset
        
        return UIEdgeInsets(top: topInset, left: tokenContentInset.left, bottom: bottomInset, right: tokenContentInset.right)
    }
    
}


// MARK: - UICollectionView Delegate

extension IMTokenInputView: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let targetIndexPath: IndexPath = indexPath
        
        if isLastItem(for: targetIndexPath) {
            return
        }
        
        guard let cell: TokenCell = collectionView.cellForItem(at: targetIndexPath) as? TokenCell else {
            return
        }
        if respondingCell == cell {
            cell.isActive = !cell.isActive
            respondingCell = cell
            
        } else {
            respondingCell?.isActive = false // deselect current section because only one selection at a time
            cell.isActive = !cell.isActive
            respondingCell = cell
        }
        
        
        
        _ = cell.becomeFirstResponder()
        
        //		selectedCell?.tokenIsSelected = false
        //		
        //        if cell.tokenIsSelected {
        //            cell.tokenIsSelected = false
        //            selectedCell = nil
        //            _ = cell.becomeFirstResponder()
        //
        //        } else {
        //            cell.tokenIsSelected = true
        //            selectedCell = cell
        //           // selectedCell?.tokenIsSelected = false
        //            _ = cell.becomeFirstResponder()
        //        }
        
    }
}



