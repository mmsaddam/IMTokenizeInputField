//
//  IMTokenInputView.swift
//  IMTokenizeInputField
//
//  Created by Muzahidul Islam on 3/9/17.
//  Copyright © 2017 Muzahidul Islam. All rights reserved.
//

import UIKit

class IMTokenInputView: UIView {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var allItems = [String]()
    
    override func awakeFromNib() {
        collectionView?.delegate = self
        collectionView.dataSource = self
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
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TokenCell.indentifier, for: indexPath) as! TokenCell
        cell.nameLabel.text = items[indexPath.section]
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



