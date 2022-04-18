//
//  ViewController.swift
//  ForsquareClone
//
//  Created by Berke Baç on 16.04.2022.
//

import UIKit
import Firebase
class SignUpVC: UIViewController {
    
    @IBOutlet weak var emailText: UITextField!
    
    @IBOutlet weak var passwordText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }

    @IBAction func signInClicked(_ sender: Any) {
        if emailText.text != "" && passwordText.text != "" {
            
            Auth.auth().signIn(withEmail: emailText.text!, password: passwordText.text!) { authdata, error in
                if error != nil {
                    self.MakeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                    
                }else{
                    self.performSegue(withIdentifier: "toPlacesVC", sender: nil)
                }
            }
        }else {
            self.MakeAlert(titleInput: "Error", messageInput: "email/password ?")
        }
        
    }
    
    @IBAction func signUpClicked(_ sender: Any) {
        if emailText.text != "" && passwordText.text != "" {
            
            Auth.auth().createUser(withEmail: emailText.text!, password: passwordText.text!) { authdata, error in
                if error != nil {
                    
                    self.MakeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                }else{
                    
                    self.performSegue(withIdentifier: "toPlacesVC", sender: nil)
                    
                }
            }
            
        }else {
            self.MakeAlert(titleInput: "Error", messageInput: "Email/Password?")
        }
        
    }
    
    func MakeAlert(titleInput: String, messageInput:String)
    {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
        
    }
}

