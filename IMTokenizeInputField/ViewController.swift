//
//  ViewController.swift
//  IMTokenizeInputField
//
//  Created by Muzahidul Islam on 3/9/17.
//  Copyright © 2017 Muzahidul Islam. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tokenInputView: IMTokenInputView!
    // MARK:- Properties
    var items = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tokenInputView.tokenHeight = 40.0
        self.automaticallyAdjustsScrollViewInsets = false

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


