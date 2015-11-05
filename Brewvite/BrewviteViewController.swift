//
//  ViewController.swift
//  Brewvite
//
//  Created by Justin Simonelli on 10/13/15.
//  Copyright © 2015 Sims. All rights reserved.
//

import UIKit
import MapKit
import AddressBook
import BAFluidView
import Parse
import SwiftKeychain

class BrewviteViewController: UIViewController, UIViewControllerTransitioningDelegate {
    
    @IBOutlet weak var inviteButton: UIButton!
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var searchLocationsButton: UIButton!
    @IBOutlet weak var submitInviteButton: UIButton!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    
    @IBAction func logoutAction(sender: AnyObject) {
        PFUser.logOutInBackgroundWithBlock{ error in
            if let error = error{
                SweetAlert().showAlert(Constants.ALERT_EMBARRASSING_TITLE, subTitle: Constants.ALERT_LOGOUT_ERROR , style: AlertStyle.Warning, buttonTitle: Constants.ALERT_BUTTON_OK )
                print(error)
            }else{
                NSUserDefaults.standardUserDefaults().removeObjectForKey(ShareData.sharedInstance.HAS_LOGIN_KEY)
                NSUserDefaults.standardUserDefaults().removeObjectForKey(ShareData.sharedInstance.USER_DEFAULTS_USERNAME_KEY)
                let passKey = GenericKey(keyName:ShareData.sharedInstance.SECURED_ITEM_PASS_KEY),
                    hasStoredPasscode = Utils.sharedInstance.sharedKeychain.get(passKey).item?.value
                var shouldPresentLandingViewController = true
                if( hasStoredPasscode != nil )
                {
                    if let error = Utils.sharedInstance.sharedKeychain.remove(passKey) {
                        SweetAlert().showAlert(Constants.ALERT_EMBARRASSING_TITLE, subTitle: Constants.ALERT_LOGOUT_ERROR, style: AlertStyle.Warning, buttonTitle: Constants.ALERT_BUTTON_OK)
                        shouldPresentLandingViewController = false
                        print(error)
                    }
                }
                
                if( shouldPresentLandingViewController == true ){
                    let storyboard = UIStoryboard(name: Constants.STORYBOARD_NAME, bundle: nil)
                    let vc = storyboard.instantiateViewControllerWithIdentifier(Constants.VC_NAME_AFTER_SPLASH)
                    self.presentViewController(vc, animated: true, completion: nil)
                }
                
            }
            
        }
    }
    @IBAction func tapVenueLabel(sender: UIGestureRecognizer) {
        transition.startingPoint = (sender.view?.center)!
        transition.bubbleColor = UIColor.whiteColor()
        performSegueWithIdentifier(Constants.SEGUE_VENUE_SEARCH, sender: nil)

    }
    
    @IBAction func tapDateLabel(sender: UIGestureRecognizer) {
        transition.startingPoint = (sender.view?.center)!
        transition.bubbleColor = UIColor.whiteColor()
        performSegueWithIdentifier(Constants.SEGUE_DATE_SELECT, sender: nil)
    }
    
    
    @IBAction func selectDateAction(sender: UIButton) {
        transition.startingPoint = sender.center
        transition.bubbleColor = (sender.titleLabel?.textColor)!
    }
    
    @IBAction func selectInviteAction(sender: UIButton) {
        transition.startingPoint = sender.center
        transition.bubbleColor = (sender.titleLabel?.textColor)!
        
    }
    
    @IBAction func searchLocationsAction(sender: UIButton) {
        transition.startingPoint = sender.center
        transition.bubbleColor = (sender.titleLabel?.textColor)!
    }
    
    @IBAction func drinkUpAction(sender: UIButton) {
        
        if( ShareData.sharedInstance.selectedDate == nil ||
            ShareData.sharedInstance.selectedVenue == nil ||
            (ShareData.sharedInstance.invitedUsers == nil ||
                ShareData.sharedInstance.invitedUsers?.count == 0) )
        {
            SweetAlert().showAlert(Constants.ALERT_MISSING_INFO_TITLE, subTitle: Constants.ALERT_MISSING_INFO_ERROR , style: AlertStyle.Warning, buttonTitle: Constants.ALERT_BUTTON_GOT_IT )
        }
        else{
        
        let _view:BAFluidView = BAFluidView(frame:self.view.frame)
        _view.fillColor = UIColor(red:0.99, green:0.56, blue:0.15, alpha:1.0)
        _view.fillAutoReverse = false
        _view.fillDuration = 3
        _view.fillRepeatCount = 1
        _view.alpha = 0.3
        
        UIView.animateWithDuration(2.6, animations: {
            _view.alpha = 1.0;
            }, completion: { (_) in
                Utils.sharedInstance.delay(1.0, closure: {
                    UIView.animateWithDuration(1, animations: {
                        _view.alpha = 0.0;
                        }, completion: { (_) in
                            _view.removeFromSuperview()
                    })
                    
                })
        })
        
        _view.fillTo(1.0)
        _view.startAnimation()
        
        self.view.insertSubview(_view, aboveSubview: self.view)
            
        }

    }

    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    
    let transition = BubbleTransition()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationLabel.hidden = true
        dateLabel.hidden = true
        
        Utils.sharedInstance.attemptToRetrieveUserLocation()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let controller = segue.destinationViewController
        controller.transitioningDelegate = self
        controller.modalPresentationStyle = .Custom
    }
    
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .Present
        transition.duration = 0.34
        return transition
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .Dismiss
        transition.bubbleColor = (inviteButton.titleLabel?.textColor)!
        handleDismissedTransition(ShareData.sharedInstance.selectedTransition)
        return transition
    }
    
    private func handleDismissedTransition( selectedAction: String?){
        if( selectedAction != nil ){
            print("dismissedTransition = \(selectedAction)")
            switch selectedAction!{
            case ShareData.sharedInstance.TRANSITION_ACTIONS.date:
                print("date")
                dateLabel.adjustsFontSizeToFitWidth = true
                dateLabel.text = Utils.sharedInstance.formatDate(ShareData.sharedInstance.selectedDate!)
                dateButton.hidden = true
                dateLabel.hidden = false
            case ShareData.sharedInstance.TRANSITION_ACTIONS.invites:
                print("invites")
            case ShareData.sharedInstance.TRANSITION_ACTIONS.venues:
                print("venues")
                locationLabel.adjustsFontSizeToFitWidth = true
                let venueName = (ShareData.sharedInstance.selectedVenue!["name"])!,
                    venueAddress = (ShareData.sharedInstance.selectedVenue!["location"]!["address"]!)!
                locationLabel.text = venueName as? String
                addressLabel.text = venueAddress as? String
                searchLocationsButton.hidden = true
                locationLabel.hidden = false
            default:
                print("none")
            }
        }
    }

}

