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
    
    var collectionView: UICollectionView!
    fileprivate lazy var layout:CustomFlowLayout = CustomFlowLayout()
    fileprivate var minTokenHeight: CGFloat = 40.0
    fileprivate var minTokenWidth: CGFloat = 50.0

    fileprivate var defaultFont: UIFont = UIFont.systemFont(ofSize: 17)
    fileprivate var searchFieldWidth: CGFloat = 150
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
        collectionView.frame = bounds
    }
    
    // Currently not used. Future improvement
    
    func setConstraints() {
        collectionView.topAnchor.constraint(equalTo: self.topAnchor)
        collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
    }
    
    // MARK: Initial Setup
    
    private func commonInit() {
        
        collectionView = UICollectionView(frame: bounds, collectionViewLayout: layout)
        collectionView.bounces = true
        collectionView.alwaysBounceHorizontal = true
        addSubview(collectionView)
        
       // setConstraints()
    }
    
    //---------------------------------------------------
    // MARK: - Public Method
    //---------------------------------------------------
    
    static func generateToken(for name: String, id: String) -> Token {
        return Token(name: name, id: id)
    }
    
    //---------------------------------------------------
    // MARK: - Add / Remove Token
    //---------------------------------------------------
    
    fileprivate func addToken(_ token:Token) {
        if !allTokens.contains(token) {
            // add element into array first
            self.allTokens.append(token)
            
            // insert new cell
            OperationQueue.main.addOperation {
                self.collectionView.performBatchUpdates({ [weak self] in
                    let targetIndexPath = NSIndexPath(item: (self?.allTokens.count)!-1, section: 0)
                    self?.collectionView.insertItems(at: [targetIndexPath as IndexPath])
                    }, completion: {[weak self] (complete) in
                        guard let strongSelf = self else { return }
                        strongSelf.scrollToLastItem()
                        strongSelf.delegate?.tokenInputView(strongSelf, didAdd: token)
                })
                
            }
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
    
//   fileprivate func isLastItem(for indexPath: IndexPath) -> Bool {
//        let totalSections = collectionView.numberOfSections
//        let totalItemInSection = collectionView.numberOfItems(inSection: totalSections - 1)
//        return (indexPath.item == (totalItemInSection - 1) )
//            && (totalSections - 1) == indexPath.section
//    }
    
   fileprivate func scrollToLastItem() {
        
        let sections = collectionView.numberOfSections
        let items = collectionView.numberOfItems(inSection: sections - 1)
        let lastIndexPath = IndexPath(item: items - 1, section: sections - 1)
        collectionView.scrollToItem(at: lastIndexPath, at: .left, animated: true)
    
    }
    
    fileprivate func removeItem(at indexPath: IndexPath, then: @escaping (Bool) -> Void) {
        self.collectionView.performBatchUpdates({
            self.collectionView.deleteItems(at: [indexPath])
        }, completion: { (completed) in
            then(completed)
        })
        
    }
    
    fileprivate func calculateCellSize(for tokenStr: String = "", atIndexPath indexPath: IndexPath) -> CGSize {
        
        let totalVInset = tokenContentInset.top + tokenContentInset.bottom
        let totalHInset = tokenContentInset.left + tokenContentInset.right
        var strSize = tokenStr.getSize(font: tokenFont)
        
        if (strSize.height > (tokenHeight - totalVInset)) {
            strSize = tokenStr.getSize(font: defaultFont)
        }
        
        var cellWidth: CGFloat = 0.0
        
        if collectionView.isLast(indexPath: indexPath) {
            cellWidth = searchFieldWidth
        } else {
            cellWidth = strSize.width + totalHInset + 10
        }
        
        return CGSize(width: max(minTokenWidth, cellWidth), height: tokenHeight)
        
    }
    
    
}

// MARK: - Add, Get, Remove Token

extension IMTokenInputView {
    
    public func addTokenFor(name: String, id: String) {
       let newToken = IMTokenInputView.generateToken(for: name, id: id)
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
    
}


// MARK: TokenCell Delegate

extension IMTokenInputView: TokenCellDelegate {
    func willRemove(_ cell: TokenCell) {
        if let token = cell.token {
            if cell.hasSelected {
                let isRemoved = allTokens.removeObject(obj: token)
                if isRemoved {
                    if let indexPath = self.collectionView.indexPath(for: cell) {
                        self.removeItem(at: indexPath, then: { (completed) in
                            
                            self.respondingCell = nil
                            self.delegate?.tokenInputView(self, didRemove: token)
                            // respond to previous item. If no previous item the goes to next item
                            let nextItem = min(indexPath.item, (self.collectionView.numberOfItems(inSection: 0) - 1))
                            let targetIndexPath = IndexPath(item: nextItem, section: 0)
                            guard let cell = self.collectionView.cellForItem(at: targetIndexPath) as? TokenCell  else {
                                print("cell found")
                                return
                            }
                            if self.collectionView.isLast(indexPath: targetIndexPath) {
                                self.respondingCell = nil
                                cell.textField.becomeFirstResponder()
                            } else {
                                self.respondingCell = cell
                                _ = cell.becomeFirstResponder()
                                
                            }
                        })
                    } else {
                        print("Path not found...")
                    }
                }
            } else {
                cell.hasSelected = true
                self.respondingCell = cell
                let indexPath  = collectionView.indexPath(for: cell)
                collectionView.scrollToItem(at: indexPath!, at: .right, animated: true)
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
    
    /*
      Place holder cell textfield backward deletion handle. When the textField is empty the respond the immediate
         previous cell of the search field.
     */
    func textFieldDeleteBackward(_ textField: TokenTextField) {
        
        /// when there exist any token in the view then go ahead
        let numberOfItems = self.collectionView.numberOfItems(inSection: 0)
        guard numberOfItems > 1 else { return }
        guard let cell: TokenCell = collectionView.cellForItem(at: IndexPath(item: numberOfItems - 2, section: 0)) as? TokenCell else {
            print("Cell not found.....")
            return
            
        }
        
        if cell.hasSelected {
            return
        } else {
            respondingCell?.hasSelected = false
            respondingCell = nil // reset previous responding cell
            cell.hasSelected = true
            respondingCell = cell
            _ = cell.becomeFirstResponder()
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
        debugPrint(indexPath)
        if indexPath.item == (self.collectionView.numberOfItems(inSection: 0)-1) {
            cell = placeholderCell(for: indexPath)
        } else {
            cell = commonCell(for: indexPath)
            cell.token = allTokens[indexPath.item]
            cell.textField.text = allTokens[indexPath.item].name
        }
        
        return cell
        
    }
    
    func placeholderCell(for indexPath: IndexPath) -> TokenCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TokenCell.Identifier.last, for: indexPath) as! TokenCell
        cell.textField.font = tokenFont
        
        cell.type = .placeholder
        cell.textField.delegate = self
        cell.textField.addTarget(self, action: #selector(IMTokenInputView.onTextFieldDidChange(_:)), for: .editingChanged)
        cell.textField.backwardDelegate = self
        return cell
    }
    func commonCell(for indexPath: IndexPath) -> TokenCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TokenCell.Identifier.common, for: indexPath) as! TokenCell
        cell.textField.font = tokenFont
        cell.type = .default
        cell.delegate = self
        return cell
    }
    
}


//---------------------------------------------------
// MARK: - FlowLayout Delegate
//---------------------------------------------------

extension IMTokenInputView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if  collectionView.isLast(indexPath: indexPath) {
            return calculateCellSize(atIndexPath: indexPath)
        }
        return calculateCellSize(for: allTokens[indexPath.item].name, atIndexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        
        let colVHeight = self.collectionView.frame.size.height
        let topInset = (colVHeight - tokenHeight) / 2
        _ = topInset
        
        return UIEdgeInsets.zero
            //UIEdgeInsets(top: topInset, left: tokenContentInset.left, bottom: bottomInset, right: tokenContentInset.right)
    }
    
}


// MARK: - UICollectionView Delegate

extension IMTokenInputView: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let targetIndexPath: IndexPath = indexPath
        
        guard !collectionView.isLast(indexPath: indexPath) else {
            return
        }
        
        guard let cell: TokenCell = collectionView.cellForItem(at: targetIndexPath) as? TokenCell else {
            return
        }
        if respondingCell == cell {
            cell.hasSelected = !cell.hasSelected
            respondingCell = cell
            
        } else {
            respondingCell?.hasSelected = false // deselect current section because only one selection at a time
            cell.hasSelected = !cell.hasSelected
            respondingCell = cell
        }
        
        _ = cell.becomeFirstResponder()
        
    }
}



