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
    
    var collectionView: UICollectionView!
    
    private var minTokenHeight: CGFloat = 40
    var defaultFont: UIFont = UIFont.systemFont(ofSize: 17)
    
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
    
    var tokens: [Token] {
        return self.allTokens
    }
    var selectedCell: TokenCell?
    var delegate: IMTokenInputViewDelegate?
    
    override func awakeFromNib() {
        collectionView.register(TokenCell.self,         forCellWithReuseIdentifier: TokenCell.indentifier)
        collectionView.backgroundColor = Utils.Color.collectionViewBgColor
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
    }
    
    func commonInit() {
        backgroundColor = UIColor.black
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 5.0
        layout.scrollDirection = .horizontal
        
        collectionView = UICollectionView(frame: bounds, collectionViewLayout: layout)
        
        addSubview(collectionView)
 
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
    
    func isLastItem(for indexPath: IndexPath) -> Bool {
        let totalSections = collectionView.numberOfSections
        let totalItemInSection = collectionView.numberOfItems(inSection: totalSections - 1)
        return (indexPath.item == (totalItemInSection - 1) )
            && (totalSections - 1) == indexPath.section
    }
    
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

// MARK: - IMTokenInputView Extension

extension IMTokenInputView {
    
    func calculateCellSize(for tokenStr: String = "", atIndexPath indexPath: IndexPath) -> CGSize {
        
        let totalVInset = tokenContentInset.top + tokenContentInset.bottom
        let totalHInset = tokenContentInset.left + tokenContentInset.right
        
        
        var strSize = tokenStr.getSize(font: tokenFont)
        
        if (strSize.height > (tokenHeight - totalVInset)) {
            strSize = tokenStr.getSize(font: defaultFont)
        }
        
        var cellWidth: CGFloat = 0.0
        
        if isLastItem(for: indexPath) {
            cellWidth = 150.0
        } else {
            cellWidth = strSize.width + totalHInset
        }
        
        return CGSize(width: cellWidth, height: tokenHeight)
        
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TokenCell.indentifier, for: indexPath) as! TokenCell
        
        cell.textField.font = tokenFont
        cell.contentInset = tokenContentInset
        cell.delegate = self
        
        cell.textField.isUserInteractionEnabled = false

        if isLastItem(for: indexPath) {
            cell.textField.isUserInteractionEnabled = true
            cell.textField.text = ""
            cell.textField.delegate = self
            cell.textField.addTarget(self, action: #selector(IMTokenInputView.onTextFieldDidChange(_:)), for: .editingChanged)
            cell.textField.backwardDelegate = self
            cell.textField.textAlignment = .left
            return cell
        } else {
            cell.token = allTokens[indexPath.item]
            cell.textField.text = allTokens[indexPath.item].name
            cell.textField.textAlignment = .center
            return cell

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
        textField.resignFirstResponder()
        endEditing(true)
        return true
    }
   
    func textFieldDeleteBackward(_ textField: TokenTextField) {
       
        if allTokens.count > 0 {
             let indexPath = IndexPath(item: allTokens.count - 1, section: 0)
            guard let cell: TokenCell = collectionView.cellForItem(at: indexPath) as? TokenCell else {
                return
            }
            if cell.tokenIsSelected {
               _ = cell.becomeFirstResponder()
                return
            } else {
                selectedCell?.tokenIsSelected = false
                cell.tokenIsSelected = true
                selectedCell = cell
                _ = cell.becomeFirstResponder()
            }
        }
      
    }
    
    func onTextFieldDidChange(_ textField: UITextField) {
        delegate?.tokenInputView(self, didChangeText: textField.text ?? "")
    }
    
}

// MARK: - UICollectionView Delegate

extension IMTokenInputView: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let targetIndexPath: IndexPath = indexPath
        
        guard let cell: TokenCell = collectionView.cellForItem(at: targetIndexPath) as? TokenCell else {
            return
        }

        if cell.tokenIsSelected {
            cell.tokenIsSelected = false
            selectedCell = nil
            _ = cell.resignFirstResponder()

        } else {
            selectedCell?.tokenIsSelected = false
            cell.tokenIsSelected = true
            selectedCell = cell
            _ = cell.becomeFirstResponder()
        }

    }
}



