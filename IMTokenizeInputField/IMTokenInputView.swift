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
    
    private var minTokenHeight: CGFloat = 40
    
    var defaultFont: UIFont = UIFont.systemFont(ofSize: 17)
    
   // let demoCellSize = CGSize(width: 60, height: 40)
    
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
        
        return UIEdgeInsets(top: topInset, left: 0, bottom: bottomInset, right: 0)
    }
    
    
}

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
        
        if isLastItem(for: indexPath) {
            cell.textField.isUserInteractionEnabled = true
            cell.textField.text = ""
            cell.textField.delegate = self
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
    
    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        code
//    }
    
    func textFieldDeleteBackward(_ textField: TokenTextField) {
        let indexPath = IndexPath(item: allTokens.count, section: 0)
        collectionView(collectionView, didSelectItemAt: indexPath)
    }
    
    
}


extension IMTokenInputView: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var targetIndexPath: IndexPath = indexPath
        
        if isLastItem(for: indexPath) {
            targetIndexPath =  IndexPath(item: indexPath.item - 1, section: indexPath.section)
           
        }
        
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



