//
//  ViewController.swift
//  IMTokenizeInputField
//
//  Created by Muzahidul Islam on 3/9/17.
//  Copyright © 2017 Muzahidul Islam. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK:- Outlet Properties
  //  @IBOutlet weak var collectionView: UICollectionView!
    let padding: (leading: CGFloat,tralling: CGFloat) = (leading: 10.0, tralling: 10.0)
    
    // MARK:- Properties
    var items = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        
//        collectionView.dataSource = self
//        collectionView.delegate = self
        
        items = [
            "Hello", "Hello world", "Hello", "Hello world",
            "Hello", "Hello world", "Hello", "Hello world"
        ]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

////---------------------------------------------------
//// MARK: - FlowLayout Delegate
////---------------------------------------------------
//
//extension ViewController: UICollectionViewDelegateFlowLayout {
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        
//        let tokenString = items[indexPath.section] as NSString
//        
//        let size: CGSize = tokenString.size(attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 19)])
//
//        return CGSize(width: size.width + padding.leading + padding.tralling, height: size.height)
//    }
//}
//
////---------------------------------------------------
//// MARK: - CollectionView Datasource
////---------------------------------------------------
//
//extension ViewController: UICollectionViewDataSource {
//    
//    /*
//     ----------------------------
//     | item 1 | item 2 | item 3 |
//     ----------------------------
//     */
//    
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return items.count
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 1
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TokenCell.indentifier, for: indexPath) as! TokenCell
//        cell.nameLabel.text = items[indexPath.section]
//        cell.nameLabel.sizeToFit()
//        cell.nameLabel.superview?.sizeToFit()
//        return cell
//    }
//    
//  }
//
//extension ViewController: UICollectionViewDelegate{
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let cell = collectionView.cellForItem(at: indexPath) as? TokenCell
//        if cell?.isFirstResponder ?? false {
//           _ = cell?.resignFirstResponder()
//        } else {
//           _ = cell?.becomeFirstResponder()
//        }
//    }
//}
