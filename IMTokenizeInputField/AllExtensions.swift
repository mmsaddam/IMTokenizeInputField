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
    mutating func removeObject( obj: Element) -> Bool{
        if let index = index(of: obj) {
            remove(at: index)
            return true
        }
        return false
    }
}

extension String {
    func getSize(font: UIFont) -> CGSize {
        return (self as NSString).size(attributes: [NSFontAttributeName : font])
    }
}
