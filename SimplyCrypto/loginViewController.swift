//
//  loginViewController.swift
//  SimplyCrypto
//
//  Created by Steven Grutman on 4/30/19.
//  Copyright © 2019 Group18. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import Firebase

class loginViewController: UIViewController {

    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        if FIRAuth.auth()?.currentUser != nil {
            self.performSegue(withIdentifier: "Sign In", sender: self)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    
    @IBAction func signIn(_ sender: Any) {
        signInHelper()
    }
    
    func signInHelper() {
        FIRAuth.auth()?.signIn(withEmail: (emailField.text ?? ""), password: (passwordField.text ?? "")) { (result, error) in
            if let _eror = error{
                let alert = UIAlertController(title: "Error", message: _eror.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Click", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                print(_eror.localizedDescription)
            }else{
                if let _res = result{
                    self.performSegue(withIdentifier: "Sign In", sender: self)
                    print(_res)
                }
            }
        }
    }
    
    @IBAction func signUp(_ sender: Any) {
        FIRAuth.auth()?.createUser(withEmail: (emailField.text ?? ""), password: (passwordField.text ?? "")) { (result, error) in
            if let _eror = error {
                //something bad happning
                print(_eror.localizedDescription )
                let alert = UIAlertController(title: "Error", message: _eror.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Click", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }else{
                //user registered successfully
                self.signInHelper()
                self.performSegue(withIdentifier: "Sign In", sender: self)
                print(result)
                
            }
        }
        
    }
    
}
