//
//  TokenTextField.swift
//  IMTokenizeInputField
//
//  Created by Muzahidul Islam on 3/10/17.
//  Copyright © 2017 Muzahidul Islam. All rights reserved.
//

import UIKit

protocol IMDeleteBackwardDetectingTextFieldDelegate {
    func textFieldDeleteBackward(_ textField: TokenTextField)
}

class TokenTextField: UITextField {
    var backwardDelegate: IMDeleteBackwardDetectingTextFieldDelegate?
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
    
    func setUp() {
        borderStyle = .none
        placeholder = "Enter name"
        backgroundColor = Utils.Color.textFieldBgColor
        isUserInteractionEnabled = false
        textAlignment = .center
        sizeToFit()
        textColor = Utils.Color.tokenTextColor
        font = UIFont.systemFont(ofSize: 17)
    }
    
    override func deleteBackward() {
        if text?.isEmpty ?? false {
            backwardDelegate?.textFieldDeleteBackward(self)
        }
        super.deleteBackward()
    }
   
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
