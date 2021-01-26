//
//  RegisterViewController.swift
//  ReadToday
//
//  Created by Mickael Lokhate on 25/01/2021.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var usernameTextfield: UITextField!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var confirmPasswordTextfield: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    var userID: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        confirmPasswordTextfield.backgroundColor = .systemBackground
        passwordTextfield.backgroundColor = .systemBackground
        confirmPasswordTextfield.backgroundColor = .systemBackground
        emailTextfield.backgroundColor = .systemBackground
        usernameTextfield.backgroundColor = .systemBackground
        errorLabel.text = ""
    }
    
    @IBAction func createAccountPressed(_ sender: UIButton) {
        confirmPasswordTextfield.backgroundColor = .systemBackground
        passwordTextfield.backgroundColor = .systemBackground
        confirmPasswordTextfield.backgroundColor = .systemBackground
        emailTextfield.backgroundColor = .systemBackground
        usernameTextfield.backgroundColor = .systemBackground
        errorLabel.text = ""
        
        if let username = usernameTextfield.text {
            if let email = emailTextfield.text {
                if let password = passwordTextfield.text {
                    if let passwordConfirmation = confirmPasswordTextfield.text {
                        if password == passwordConfirmation {
                            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                                if let err = err as NSError?{
                                    switch AuthErrorCode(rawValue: err.code) {
                                    case .operationNotAllowed:
                                        self.errorLabel.text = "Impossible de créer un compte, veuillez nous contacter."
                                    case .emailAlreadyInUse:
                                        self.errorLabel.text = "Ce mail est déjà utilisé avec un compte actif."
                                        self.emailTextfield.backgroundColor = .red
                                    case .invalidEmail:
                                        self.errorLabel.text = "Votre email est invalide, entrez une adresse valide."
                                        self.emailTextfield.backgroundColor = .red
                                    case .weakPassword:
                                        self.errorLabel.text = "Le mot de passe doit faire un minimum de 6 caractères."
                                        self.passwordTextfield.backgroundColor = .red
                                    default:
                                        self.errorLabel.text = "Une erreur s'est produite, veuillez réessayer."
                                    }
                                } else {
                                    self.userID = result?.user.uid
                                    let defaults = UserDefaults.standard
                                    defaults.setValue(self.userID, forKey: "userID")
                                    self.performSegue(withIdentifier: "goToLibraryFromRegister", sender: self)
                                }
                            }
                        } else {
                            errorLabel.text = "Le mot de passe et la confirmation ne correspondent pas."
                        }
                    } else {
                        confirmPasswordTextfield.backgroundColor = .red
                        errorLabel.text = "Veuillez confirmer votre mot de passe."
                    }
                } else {
                    passwordTextfield.backgroundColor = .red
                    errorLabel.text = "Veuillez entrer votre mot de passe."
                }
            } else {
                emailTextfield.backgroundColor = .red
                errorLabel.text = "Veuillez entrer votre email."
            }
        } else {
            usernameTextfield.backgroundColor = .red
            errorLabel.text = "Veuillez entrer votre nom d'utilisateur."
        }
    }
}
