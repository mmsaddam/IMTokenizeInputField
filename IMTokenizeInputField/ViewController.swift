//
//  ViewController.swift
//  IMTokenizeInputField
//
//  Created by Muzahidul Islam on 3/9/17.
//  Copyright © 2017 Muzahidul Islam. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var tokenInputView: IMTokenInputView!
	
	// MARK:- Properties
	var names:[String] = []
	var filteredNames:[String] = []
	var selectedNames:[String] = []
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		tokenInputView.tokenHeight = 40.0
		self.automaticallyAdjustsScrollViewInsets = false
		
		tokenInputView.delegate = self
		
		for i in 0..<99 {
			names.append("item number \(i)")
		}
		
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
}
extension ViewController: IMTokenInputViewDelegate {
    func tokenInputViewDidBeginEditing(_ tokenInputView: IMTokenInputView) {
        
    }
    func tokenInputViewDidEndEditing(_ tokenInputView: IMTokenInputView) {
        
    }
    func tokenInputView(_ tokenInputView: IMTokenInputView, didSelect token: Token){
        
    }
    func tokenInputView(_ tokenInputView: IMTokenInputView, didAdd token: Token) {
        if !selectedNames.contains(token.name) {
            selectedNames.append(token.name)
        }
    }
    func tokenInputView(_ tokenInputView: IMTokenInputView, didRemove token: Token) {
        if selectedNames.contains(token.name) {
           _ = selectedNames.removeObject(obj: token.name)
        }
    }
    func tokenInputView(_ tokenInputView: IMTokenInputView, didChangeText text: String) {
        
        if text == "" {
            self.filteredNames = []
            self.tableView.isHidden = true
        }
        else {
            let predicate:NSPredicate = NSPredicate(format: "self contains[cd] %@", argumentArray: [text])
            self.filteredNames = self.names.filter { predicate.evaluate(with: $0) }
            self.tableView.isHidden = false
        }
        self.tableView.reloadData()
    }
    
    
    
}
// MARK: - TableView Data Source

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredNames.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath)
        cell.textLabel?.text = filteredNames[indexPath.row]
        let name = filteredNames[indexPath.row]
        if self.selectedNames.contains(name) {
            cell.accessoryType = .checkmark
        }
        else {
            cell.accessoryType = .none
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let name = filteredNames[indexPath.row]
        let token = Token(name: name, id: nil)
        tokenInputView.addToken(token)
    }
}


