//
//  RegisterViewController.swift
//  Brewvite
//
//  Created by Justin Simonelli on 10/26/15.
//  Copyright © 2015 Sims. All rights reserved.
//

import UIKit
import Parse
import SwiftKeychain

class RegisterViewController: UIViewController, UITextFieldDelegate {

    private let REGISTER_SUCCESS_SEGUE = "registerSuccessSegue"
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField1: UITextField!
    @IBOutlet weak var passwordTextField2: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        closeButton.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_4))
        emailTextField.delegate = self
        usernameTextField.delegate = self
        passwordTextField1.delegate = self
        passwordTextField2.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeAction(sender: AnyObject) {
        self.view.endEditing(true)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func registerAction(sender: AnyObject) {
        //one of the fields was empy
        if( usernameTextField.text!.isEmpty || passwordTextField1.text!.isEmpty || passwordTextField2.text!.isEmpty ){
            SweetAlert().showAlert("Whoa there partner", subTitle: "Looks like you forgot to enter all your info.", style: AlertStyle.Warning, buttonTitle: "OK, I'll try again")
        }//passwords don't match
        else if(passwordTextField1.text! != passwordTextField2.text!){
            SweetAlert().showAlert("So close..", subTitle: "Almost there! Just make sure your passwords match!", style: AlertStyle.Warning, buttonTitle: "Got it")
        }//we are good!
        else{
            
            let user = PFUser()
            let _username = self.usernameTextField.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()),
                _password = self.passwordTextField1.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()),
                _email = self.emailTextField.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()).lowercaseString
            
            user.username = _username
            user.password = _password
            user.email = _email
            
            //we don't have any dups! add this motherfucker!
            user.signUpInBackgroundWithBlock { succeeded, error in
                if (succeeded) {
                    //The registration was successful, attempt to log them in and go
                    PFUser.logInWithUsernameInBackground(self.usernameTextField.text!, password: self.passwordTextField1.text!) { user, error in
                        if ( user != nil ) {
                            //we made it. we're in brother. set save some shit to their phone so they don't have to log in every time
                            
                            if ( NSUserDefaults.standardUserDefaults().boolForKey(ShareData.sharedInstance.HAS_LOGIN_KEY) == false ){
                                NSUserDefaults.standardUserDefaults().setValue(_username, forKey: ShareData.sharedInstance.USER_DEFAULTS_USERNAME_KEY)
                            }
                            
                            if( Utils.sharedInstance.getKeychainValue(ShareData.sharedInstance.SECURED_ITEM_PASS_KEY) != nil ){
                                //this should never happen...
                                //if there is a key set here, somehow it got set elsewhere, which is not good. sooooo.......
                                
                            }else{
                                let passcodeKey = GenericKey(keyName:ShareData.sharedInstance.SECURED_ITEM_PASS_KEY, value: _password)
                                if let error = Utils.sharedInstance.sharedKeychain.add(passcodeKey) {
                                    SweetAlert().showAlert("Well this is embarrassing..", subTitle: "Something seems to have gone wrong when registering you. Try again in a few seconds", style: AlertStyle.Warning, buttonTitle: "Ok...")
                                    print(error)
                                    return
                                }
                            }
                            
                            self.performSegueWithIdentifier(self.REGISTER_SUCCESS_SEGUE, sender: nil)
                        } else if let error = error {
                            SweetAlert().showAlert("Well this is embarrassing..", subTitle: "Something seems to have gone wrong when registering you. Try again in a few seconds", style: AlertStyle.Warning, buttonTitle: "FINE")
                            print(error)
                        }
                    }
                    
                } else if let error = error {
                    //username is taken
                    if( error.code == 202 ){
                        SweetAlert().showAlert("Yikes!", subTitle: "Someone already has that username. Maybe try another one?", style: AlertStyle.Warning, buttonTitle: "Let's do that again")
                        return
                    }//email is taken
                    else if( error.code == 203 ){
                        //password reset flow!
                        SweetAlert().showAlert("Yikes!", subTitle: "Someone already has that email address registered. Did you forget your password?", style: AlertStyle.Warning, buttonTitle: "I might have..")
                        return
                    }
                }
            }
        }
        
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if( textField == emailTextField ){
            usernameTextField.becomeFirstResponder()
        }else if(textField == usernameTextField){
            passwordTextField1.becomeFirstResponder()
        }else if( textField == passwordTextField1 ){
            passwordTextField2.becomeFirstResponder()
        }else if(textField == passwordTextField2){
            textField.resignFirstResponder()
        }
        
        return true
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
