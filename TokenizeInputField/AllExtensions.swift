//
//  AllExtensions.swift
//  IMTokenizeInputField
//
//  Created by Muzahidul Islam on 3/10/17.
//  Copyright © 2017 Muzahidul Islam. All rights reserved.
//

import Foundation
import UIKit

extension Array where Element: Equatable{
    mutating public func removeObject( obj: Element) -> Bool{
        if let index = index(of: obj) {
            remove(at: index)
            return true
        }
        return false
    }
}

extension String {
    func getSize(font: UIFont) -> CGSize {
        if #available(iOS 11.0, *) {
            return (self as NSString).size(withAttributes: [NSAttributedStringKey.font : font])

            
        } else {
            return (self as NSString).size(withAttributes: [NSAttributedStringKey.font : font])
        }
        
        
            //(self as NSString).size(attributes: [NSAttributedStringKey.font : font])
            //(self as NSString).size(withAttributes: [NSFontAttributeName : font])
    }
}

extension UICollectionView {
    /// Check where the indexPath is last or not
   public func isLast(indexPath: IndexPath) -> Bool {
        let totalSections = self.numberOfSections
        let totalItemInSection = self.numberOfItems(inSection: totalSections - 1)
        return (indexPath.item == (totalItemInSection - 1) )
            && (totalSections - 1) == indexPath.section
    }
    /// 
  public  func scrollToLastItem(at scrollPosition: UICollectionViewScrollPosition) {
        let sections = numberOfSections
        let items = numberOfItems(inSection: sections - 1)
        let lastIndexPath = IndexPath(item: items - 1, section: sections - 1)
        scrollToItem(at: lastIndexPath, at: scrollPosition, animated: true)
    }
}


