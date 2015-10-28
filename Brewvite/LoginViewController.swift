//
//  LoginViewController.swift
//  Brewvite
//
//  Created by Justin Simonelli on 10/26/15.
//  Copyright © 2015 Sims. All rights reserved.
//

import UIKit
import Parse
import SwiftKeychain

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var closeButton: UIButton!
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    private let LOGIN_SUCCESS_SEGUE = "loginSuccessSegue"
    private var hasLoginKey: Bool!
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        closeButton.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_4))
        hasLoginKey = NSUserDefaults.standardUserDefaults().valueForKey(ShareData.sharedInstance.USER_DEFAULTS_USERNAME_KEY) != nil
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userNameTextField.delegate = self
        self.passwordTextField.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginButtonAction(sender: AnyObject) {
        if( userNameTextField.text!.isEmpty ) || ( passwordTextField.text!.isEmpty  ){
            SweetAlert().showAlert("Hold up!", subTitle: "Looks like you forgot to enter your username or password!", style: AlertStyle.Warning, buttonTitle: "OK, I'll try again")
        }else{
            
            PFUser.logInWithUsernameInBackground(self.userNameTextField.text!, password: self.passwordTextField.text!) { user, error in
                if ( user != nil ) {
                    
                    //we made it. we're in brother. set save some shit to their phone so they don't have to log in every time
                    if ( self.hasLoginKey == false ){
                        NSUserDefaults.standardUserDefaults().setValue(user?.username, forKey: ShareData.sharedInstance.USER_DEFAULTS_USERNAME_KEY)
                    }
                    
                    if(  Utils.sharedInstance.getKeychainValue(ShareData.sharedInstance.SECURED_ITEM_PASS_KEY) != nil ){
                        //this should never happen...
                        //if there is a key set here, somehow it got set elsewhere, which is not good. sooooo.......
                        
                    }else{
                        let passcodeKey = GenericKey(keyName:ShareData.sharedInstance.SECURED_ITEM_PASS_KEY, value: self.passwordTextField.text!)
                        if let error = Utils.sharedInstance.sharedKeychain.add(passcodeKey) {
                            SweetAlert().showAlert("Well this is embarrassing..", subTitle: "Something seems to have gone wrong when logging you. Try again in a few seconds", style: AlertStyle.Warning, buttonTitle: "Ok...")
                            print(error)
                            return
                        }
                    }
                    
                    self.performSegueWithIdentifier(self.LOGIN_SUCCESS_SEGUE, sender: nil)
                } else if let error = error {
                    print(error)
                    //bad creds
                    if( error.code == 101){
                        SweetAlert().showAlert("Whoops!", subTitle: "Check your username and password and try again!", style: AlertStyle.Warning, buttonTitle: "Got It")
                    }else{
                        SweetAlert().showAlert("Well this is embarrassing..", subTitle: "Something seems to have gone wrong when registering you. Try again in a few seconds", style: AlertStyle.Warning, buttonTitle: "FINE")
                    }
                    
                }
            }

        }
    }
    
    @IBAction func closeAction(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
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
