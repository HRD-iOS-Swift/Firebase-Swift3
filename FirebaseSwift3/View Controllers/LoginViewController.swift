//
//  ViewController.swift
//  MaranathApp
//
//  Created by Frezy Stone Mboumba on 8/11/16.
//  Copyright © 2016 Frezy Stone Mboumba. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var signUpButton: UIButton!{
        didSet {
            signUpButton.layer.cornerRadius = 5
            signUpButton.layer.borderWidth = 1
            signUpButton.layer.borderColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.1).cgColor
        }
    }
    
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var emailTextField: UITextField!{
        didSet {
            emailTextField.delegate = self
            emailTextField.layer.cornerRadius = 5
        }
    }
    
    @IBOutlet weak var passwordTextField: UITextField!{
        didSet {
            passwordTextField.delegate = self
            passwordTextField.layer.cornerRadius = 5
        }
    }
    
    @IBOutlet weak var loginButton: UIButton! {
        didSet {
            loginButton.layer.cornerRadius = 5
            loginButton.layer.borderWidth = 1
            loginButton.layer.borderColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.1).cgColor
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setGestureRecognizersToDismissKeyboard()
    }
    
    
    @IBAction func resetPasswordAction(sender: UIButton) {
        self.view.endEditing(true)
        resetPassword()
        
        }

    var authService = AuthService()
    
    @IBAction func loginAction(sender: UIButton) {
        self.view.endEditing(true)

        let email = emailTextField.text!.lowercased()
        let finalEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!

        if finalEmail.characters.count < 8 || finalEmail.isEmpty || password.isEmpty {
            
            let alertController = UIAlertController(title: "OOPS", message: "hEY MAN, You gotta fill all the fields", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(alertController, animated: true, completion: nil)
            
        }else {
            
            authService.logIn(email: finalEmail, password: password)
        }
        }
    
    
}

//----------------------------------------------------------------------------------------------------------------------//

extension LoginViewController: UITextFieldDelegate  {
    
    @IBAction func unwindToLogin(storyboard: UIStoryboardSegue){}
    
    // Dismissing the Keyboard with the Return Keyboard Button
    func dismissKeyboard(gesture: UIGestureRecognizer){
        self.view.endEditing(true)
    }
    
    // Dismissing the Keyboard with the Return Keyboard Button
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        return true
    }
    
    // Moving the View down after the Keyboard appears
    func textFieldDidBeginEditing(_ textField: UITextField) {
        animateView(up: true, moveValue: 80)
    }
    
    // Moving the View down after the Keyboard disappears
    func textFieldDidEndEditing(_ textField: UITextField) {
        animateView(up: false, moveValue: 80)
    }
    
    // Move the View Up & Down when the Keyboard appears
    func animateView(up: Bool, moveValue: CGFloat){
        let movementDuration: TimeInterval = 0.3
        let movement: CGFloat = (up ? -moveValue : moveValue)
        UIView.beginAnimations("animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration)
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
        
    }
    
    func setGestureRecognizersToDismissKeyboard(){
        // Creating Tap Gesture to dismiss Keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard(gesture:)))
        tapGesture.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapGesture)
        
        // Creating Swipe Gesture to dismiss Keyboard
        let swipDown = UISwipeGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard(gesture:)))
        swipDown.direction = .down
        view.addGestureRecognizer(swipDown)
    }
    
    
}
