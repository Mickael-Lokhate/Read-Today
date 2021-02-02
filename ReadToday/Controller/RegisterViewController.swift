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
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameTextfield.delegate = self
        emailTextfield.delegate = self
        passwordTextfield.delegate = self
        confirmPasswordTextfield.delegate = self
    
        errorLabel.text = ""
        usernameTextfield.layer.cornerRadius = usernameTextfield.frame.height / 2
        emailTextfield.layer.cornerRadius = emailTextfield.frame.height / 2
        passwordTextfield.layer.cornerRadius = passwordTextfield.frame.height / 2
        confirmPasswordTextfield.layer.cornerRadius = confirmPasswordTextfield.frame.height / 2
        
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    @IBAction func createAccountPressed(_ sender: UIButton) {
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
                                        self.emailTextfield.layer.borderColor = UIColor.red.cgColor
                                    case .invalidEmail:
                                        self.errorLabel.text = "Votre email est invalide, entrez une adresse valide."
                                        self.emailTextfield.layer.borderColor = UIColor.red.cgColor
                                    case .weakPassword:
                                        self.errorLabel.text = "Le mot de passe doit faire un minimum de 6 caractères."
                                        self.passwordTextfield.layer.borderColor = UIColor.red.cgColor
                                    default:
                                        self.errorLabel.text = "Une erreur s'est produite, veuillez réessayer."
                                    }
                                } else {
                                    self.userID = result?.user.uid
                                    let defaults = UserDefaults.standard
                                    defaults.setValue(self.userID, forKey: "userID")
                                    
                                    if let id = self.userID {
                                        let newUser = Users(userID: id, username: username, email: email)
                                        addToDatabase(newUser, with: self.db)
                                    }
                                    self.performSegue(withIdentifier: "goToLibraryFromRegister", sender: self)
                                }
                            }
                        } else {
                            errorLabel.text = "Le mot de passe et la confirmation ne correspondent pas."
                        }
                    } else {
                        confirmPasswordTextfield.layer.borderColor = UIColor.red.cgColor
                        errorLabel.text = "Veuillez confirmer votre mot de passe."
                    }
                } else {
                    passwordTextfield.layer.borderColor = UIColor.red.cgColor
                    errorLabel.text = "Veuillez entrer votre mot de passe."
                }
            } else {
                emailTextfield.layer.borderColor = UIColor.red.cgColor
                errorLabel.text = "Veuillez entrer votre email."
            }
        } else {
            usernameTextfield.layer.borderColor = UIColor.red.cgColor
            errorLabel.text = "Veuillez entrer votre nom d'utilisateur."
        }
    }
}

private func addToDatabase(_ newUser: Users, with db: Firestore) {
    db.collection("users").document(newUser.userID).setData([
        "username" : newUser.username,
        "email" : newUser.email
    ])
}

//MARK: - Textfield delegate

extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
