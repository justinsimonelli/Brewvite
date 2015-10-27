//
//  AfterSplashViewController.swift
//  Brewvite
//
//  Created by Justin Simonelli on 10/21/15.
//  Copyright © 2015 Sims. All rights reserved.
//

import UIKit
//import BAFluidView
import Parse

class AfterSplashViewController: UIViewController {
    
    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
    private let LOGIN_SUCCESS_SEGUE = "splashLoginSuccessSegue"
    private var hasLoginKey: Bool!
    let successViewController = Utils.sharedInstance.storyboard.instantiateViewControllerWithIdentifier("brewViewController")

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    
    override func viewDidAppear(animated: Bool) {
        var shouldAttemptLoginWithNSUserDefaults: Bool = false
        //their session is still good, let 'em on in
        //try logging them in with a current session
        if let user = PFUser.currentUser() {
            if user.isAuthenticated() {
                self.view.hidden = true
                self.performSegueWithIdentifier(LOGIN_SUCCESS_SEGUE, sender: nil)
            }
            else{
                shouldAttemptLoginWithNSUserDefaults = true
            }
        }
        
        if( shouldAttemptLoginWithNSUserDefaults == true){
            hasLoginKey = NSUserDefaults.standardUserDefaults().valueForKey(ShareData.sharedInstance.USER_DEFAULTS_USERNAME_KEY) != nil
            if( hasLoginKey == true ){
                //they have some stuff saved in the keychain, let's log em in
                let _username = NSUserDefaults.standardUserDefaults().valueForKey(ShareData.sharedInstance.USER_DEFAULTS_USERNAME_KEY) as! String,
                _password = Utils.sharedInstance.getKeychainValue(ShareData.sharedInstance.SECURED_ITEM_PASS_KEY) as? String
                if( _username.isEmpty == false || _password?.isEmpty == false ){
                    //we got the password from the keychain
                    PFUser.logInWithUsernameInBackground(_username, password: _password!) { user, error in
                        if ( user != nil ) {
                            self.view.hidden = true
                            self.presentViewController(self.successViewController, animated: true, completion: nil)
                            
                        }else if let error = error {
                            print(error)
                            //empty out nsdefaults
                            NSUserDefaults.standardUserDefaults().removeObjectForKey(ShareData.sharedInstance.USER_DEFAULTS_USERNAME_KEY)
                            Utils.sharedInstance.removeKeychainValue(ShareData.sharedInstance.SECURED_ITEM_PASS_KEY)
                            SweetAlert().showAlert("Well this is embarrassing..", subTitle: "Something seems to have gone wrong when registering you. Try again in a few seconds", style: AlertStyle.Warning, buttonTitle: "FINE")
                        }
                    }
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
