//
//  IMToken.swift
//  IMTokenizeInputField
//
//  Created by Muzahidul Islam on 3/9/17.
//  Copyright © 2017 Muzahidul Islam. All rights reserved.
//

import Foundation

public struct Token {
   public var name: String
   public var context: AnyObject?
   public var id: String
    
    init(name: String, id: String) {
        self.name = name
        self.id = id
    }
    
}

extension Token: Equatable {}

public func ==(lhs: Token, rhs: Token) -> Bool{
    return lhs.id == rhs.id
}

func isEqual<T: Equatable>(type: T.Type, a: Any, b: Any) -> Bool {
    guard let a = a as? T, let b = b as? T else { return false }
    
    return a == b
}


