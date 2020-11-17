//
//  RegisterViewController.swift
//  LoginApp
//
//  Created by 肖玥 on 11/16/20.
//

import UIKit
import Firebase
import SwiftSpinner

class RegisterViewController: UIViewController{
    

    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var lblStatus: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func registerAction(_ sender: Any) {
        let email = txtEmail.text
        let password = txtPassword.text
        
        if email == "" || password!.count < 6 {
            lblStatus.text = "The email address or the password you entered is not correct. Please re-enter."
            return
        }
        if email?.isEmail == false {
            lblStatus.text = "The email address you entered is not valid. Please re-enter."
            return
        }
        
        SwiftSpinner.show("Please wait. It's signing up now.")
        Auth.auth().createUser(withEmail: email!, password: password!) { authResult, error in
            SwiftSpinner.hide()
            
            if(error != nil) {
                self.lblStatus.text = "ERROR"
                print("ERROR")
                return
            }
            self.lblStatus.text = "The user is created."
        }
    }
}

