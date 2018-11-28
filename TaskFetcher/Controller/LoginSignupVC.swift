//
//  LoginSignupVC.swift
//  TaskFetcher
//
//  Created by Jonathan Compton on 11/27/18.
//  Copyright © 2018 Jonathan Compton. All rights reserved.
//

protocol LoginVCDelegate {
    func signUpSuccessful()
}

import UIKit
import FirebaseAuth

class LoginSignupVC: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var stackViewTopAnchorConstraint: NSLayoutConstraint!
    @IBOutlet weak var stackViewHeightConstraint: NSLayoutConstraint!
    
    var user: LocalUser?
    var delegate: LoginVCDelegate!
    var existingUser: Bool!
    
    let context = CDService.shared.persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        determineIfLoginOrCreateUser()


    }
    
    func determineIfLoginOrCreateUser() {
        existingUser = user != nil ? true : false
        setupTextFields()
    }
    
    func setupTextFields() {
        if existingUser {
            if let user = user {
                emailTextField.text = user.email
            }
            usernameTextField.isHidden = true
            stackViewTopAnchorConstraint.constant += 60
            stackViewHeightConstraint.constant -= 60
        }
    }
    
    func nonPasswordFormsHaveRequiredData() -> Bool {
        var isValid = false
        if existingUser {
            if let email = emailTextField.text, email.count > 0 {
                isValid = true
            }
        } else {
            if let username = usernameTextField.text, username.count > 0, let email = emailTextField.text, email.count > 0 {
                isValid = true
            }
        }
        return isValid
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        guard nonPasswordFormsHaveRequiredData(), let password = passwordTextField.text, password.count > 0 else { return }
        let email = emailTextField.text!
        let username = usernameTextField.text!
        if !existingUser {
            let newUser = LocalUser(context: context)
            newUser.name = username
            newUser.email = email
            do {
                try context.save()
                SessionManager.shared.currentUser = newUser
            } catch {
                print("Error")
            }
            Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                if error != nil {
                    print(error.debugDescription)
                } else {
                    let firebaseUser = result?.user
                    firebaseUser?.createProfileChangeRequest().displayName = username
                    SessionManager.shared.isLoggedIn = true
                    self.dismiss(animated: true, completion: nil)
                    self.delegate.signUpSuccessful()

                }
            }
        } else {
            Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                if error != nil {
                    print(error.debugDescription)
                } else {
                    SessionManager.shared.isLoggedIn = true
                    self.dismiss(animated: true, completion: nil)
                    self.delegate.signUpSuccessful()
                }
            }
        }
    }
    @IBAction func cancelTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func offlineTapped(_ sender: Any) {
        if existingUser == false {
            guard nonPasswordFormsHaveRequiredData() else { return }
            let newUser = LocalUser(context: context)
            newUser.name = usernameTextField.text!
            newUser.email = emailTextField.text!
            do {
                try context.save()
                SessionManager.shared.currentUser = newUser
                self.dismiss(animated: true, completion: nil)
                delegate.signUpSuccessful()
                
            } catch {
                print("Error Saving")
            }
        }
    }
}
