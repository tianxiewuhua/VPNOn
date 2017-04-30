//
//  VPNEditor+TextField.swift
//  VPNOn
//
//  Created by Lex on 1/17/15.
//  Copyright (c) 2015 LexTang.com. All rights reserved.
//

import UIKit

extension VPNEditor {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "textDidChange:",
            name: UITextFieldTextDidChangeNotification,
            object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "keyboardWillShow:",
            name: UIKeyboardWillShowNotification,
            object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "keyboardWillHide:",
            name: UIKeyboardWillHideNotification,
            object: nil)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        switch textField {
        case titleTextField:
            serverTextField.becomeFirstResponder()
            break
        case serverTextField:
            accountTextField.becomeFirstResponder()
            break
        case accountTextField:
            passwordTextField.becomeFirstResponder()
            break
        case passwordTextField:
            secretTextField.becomeFirstResponder()
            break
        case secretTextField:
            groupTextField.becomeFirstResponder()
            break
        default:
            groupTextField.resignFirstResponder()
        }
        
        return true
    }
    
    func textDidChange(notification: NSNotification) {
        toggleSaveButtonByStatus()
    }
    
    func keyboardWillShow(notification: NSNotification) {
        // Add bottom edge inset so that the last cell is visiable
        
        var bottom: CGFloat = 216
        defer {
            var edgeInsets = self.tableView.contentInset
            edgeInsets.bottom = bottom
            self.tableView.contentInset = edgeInsets
        }
        
        guard let userInfo = notification.userInfo else {
            return
        }
        
        guard let boundsObject = userInfo["UIKeyboardBoundsUserInfoKey"] else {
            return
        }
        
        bottom = CGRectGetHeight(boundsObject.CGRectValue)
    }
    
    func keyboardWillHide(notification: NSNotification) {
        var edgeInsets = self.tableView.contentInset
        edgeInsets.bottom = 0
        self.tableView.contentInset = edgeInsets
    }

}
