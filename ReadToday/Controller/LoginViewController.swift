//
//  LoginViewController.swift
//  ReadToday
//
//  Created by Mickael Lokhate on 25/01/2021.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBAction func unwindLogin(segue: UIStoryboardSegue){}
    
    var userID: String?
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        errorLabel.text = ""
        userID = defaults.string(forKey: "userID")
      
        guard userID == nil else {
            performSegue(withIdentifier: "goToLibrary", sender: self)
            return
        }
    }
    
    @IBAction func loginPressed(_ sender: UIButton) {
        if let email = emailTextField.text {
            if let password = passwordTextField.text {
                Auth.auth().signIn(withEmail: email, password: password) { (authResult, err) in
                    if let err = err as NSError? {
                        switch AuthErrorCode(rawValue: err.code) {
                        case .operationNotAllowed:
                            self.errorLabel.text = "Votre compte n'est pas encore activé. Réessayez plus tard."
                        case .userDisabled:
                            self.errorLabel.text = "Votre compte a était désactivé par un administrateur."
                        case .wrongPassword:
                            self.errorLabel.text = "Le mot de passe est incorrect, veuillez réessayer."
                        case .invalidEmail:
                            self.errorLabel.text = "Cet email ne correspond à aucun compte."
                        default:
                            self.errorLabel.text = "Une erreur s'est produite lors de l'authentification."
                        }
                    } else {
                        self.userID = Auth.auth().currentUser?.uid
                        self.defaults.setValue(self.userID, forKey: "userID")
                        self.performSegue(withIdentifier: "goToLibrary", sender: self)
                    }
                }
            } else {
                passwordTextField.backgroundColor = .red
                errorLabel.text = "Un mot de passe est nécessaire."
            }
        } else {
            emailTextField.backgroundColor = .red
            errorLabel.text = "Un email est nécessaire."
        }
    }
}
