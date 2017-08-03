//
//  InputResultViewController.swift
//  Mobile Test Runner for Jama
//
//  Created by Meghan McBee on 8/3/17.
//  Copyright © 2017 Jaca. All rights reserved.
//
/*
import UIKit

class InputResultViewController: UIViewController, UITextViewDelegate {
    
    let screenSize = UIScreen.main.bounds
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(InputResultViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(InputResultViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        inputResultsTextBox.resignFirstResponder()
        self.inputResultsBox.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        inputResultsTextField.resignFirstResponder()
        return (true)
    }

    // These manage the where the popup goes when keyboard appears
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.inputResultsBox.frame.origin.y == 0{
                self.inputResultsBox.frame.origin.y += keyboardSize.height
            }
        }
    }
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.inputResultsBox.frame.size.height += keyboardSize.height
            self.inputResultsBox.frame = CGRect(x: 0, y: 0, width: (screenSize.width/10)*9, height: screenSize.height-keyboardSize.height)
        }
    }

}*/
