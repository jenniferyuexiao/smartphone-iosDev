//
//  ForgetPasswordViewController.swift
//  LoginApp
//
//  Created by 肖玥 on 11/16/20.
//

import UIKit
import Firebase

class ForgetPasswordViewController: UIViewController {
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var lblStatus: UILabel!
        
    
    override func viewDidLoad() {
            super.viewDidLoad()
        }
    
        @IBAction func confirmAction(_ sender: Any) {
            let email = txtEmail.text
            
            if email?.isEmail == false {
                lblStatus.text = "Your email address is invalid. Please re-enter."
                return
            }
            
            Auth.auth().sendPasswordReset(withEmail: email!) { [weak self] error in
                if error != nil {
                    self?.lblStatus.text = "Cannot reset your password by email."
                } else {
                    self?.lblStatus.text = "The email has been sent. Please reset by email."
                }
            }
        }
}
