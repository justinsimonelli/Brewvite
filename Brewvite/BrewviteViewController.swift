//
//  ViewController.swift
//  Brewvite
//
//  Created by Justin Simonelli on 10/13/15.
//  Copyright © 2015 Sims. All rights reserved.
//

import UIKit
import MapKit
import SwiftAddressBook
import AddressBook
import BAFluidView

class BrewviteViewController: UIViewController, UIViewControllerTransitioningDelegate {
    
    @IBOutlet weak var inviteButton: UIButton!
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var searchLocationsButton: UIButton!
    @IBOutlet weak var submitInviteButton: UIButton!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    let shareData = ShareData.sharedInstance
    
    @IBAction func tapVenueLabel(sender: UIGestureRecognizer) {
        transition.startingPoint = (sender.view?.center)!
        transition.bubbleColor = UIColor.whiteColor()
        performSegueWithIdentifier("venueSearchSegue", sender: nil)

    }
    
    @IBAction func tapDateLabel(sender: UIGestureRecognizer) {
        transition.startingPoint = (sender.view?.center)!
        transition.bubbleColor = UIColor.whiteColor()
        performSegueWithIdentifier("dateSelectSegue", sender: nil)
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
        
        let _view:BAFluidView = BAFluidView(frame:self.view.frame)
        _view.fillColor = UIColor(red:0.98, green:0.69, blue:0.09, alpha:1.0)
        _view.fillAutoReverse = false
        _view.fillDuration = 3
        _view.fillRepeatCount = 1
        _view.alpha = 0.3
        
        UIView.animateWithDuration(2.6, animations: {
            _view.alpha = 1.0;
            }, completion: { (_) in
                self.delay(1.0, closure: {
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
    
    func delay(delay:Double, closure:()->()) {
        
        dispatch_after(
            dispatch_time( DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), closure)
        
    }
    
    let dateFormatter:NSDateFormatter = NSDateFormatter(),
        timeFormatter:NSDateFormatter = NSDateFormatter()
    
    let transition = BubbleTransition()
    
    var userLat: Double = 0.0,
        userLong: Double = 0.0;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationLabel.hidden = true
        dateLabel.hidden = true
        //generateButtonBorders(self.dateButton, borderColor: UIColor.whiteColor())
        //generateButtonBorders(self.whoButton, borderColor: UIColor.whiteColor())
       //generateButtonBorders(self.locationButton, borderColor: UIColor.whiteColor())
        
        attemptToRetrieveUserLocation()
        
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
        handleDismissedTransition(shareData.selectedTransition)
        return transition
    }
    
    private func handleDismissedTransition( selectedAction: String?){
        if( selectedAction != nil ){
            print("dismissedTransition = \(selectedAction)")
            switch selectedAction!{
            case shareData.TRANSITION_ACTIONS.date:
                print("date")
                dateLabel.text = generateButtonTitleForDate(shareData.selectedDate!)
                dateButton.hidden = true
                dateLabel.hidden = false
            case shareData.TRANSITION_ACTIONS.invites:
                print("invites")
            case shareData.TRANSITION_ACTIONS.venues:
                print("venues")
                locationLabel.text = shareData.selectedVenue as? String
                searchLocationsButton.hidden = true
                locationLabel.hidden = false
            default:
                print("none")
            }
        }
    }

    /*
    @IBAction func selectDate(sender: AnyObject) {
        DatePickerDialog().show("Select Time", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: UIDatePickerMode.DateAndTime, minuteInterval: 5) {
            (date) -> Void in
                let buttonTitle = self.generateButtonTitleForDate(date, dateFormatter: self.dateFormatter, timeFormatter: self.timeFormatter)
                self.dateButton.setTitle(buttonTitle, forState: UIControlState.Normal)
        }
    }
    */
    
    private func generateButtonTitleForDate(date:NSDate) -> String{
        var buttonTileForDate = ""
        self.dateFormatter.dateFormat = "MMMM dd"
        self.timeFormatter.dateFormat = "hh:mm a"
        
        let formattedDate:String = dateFormatter.stringFromDate(date),
            formattedTime:String = timeFormatter.stringFromDate(date)
        
        buttonTileForDate = formattedDate + " at " + formattedTime;
        
        return buttonTileForDate
    }
    
    
    /**
        Attempts to retrieve the users location.
        The user will be prompted for their location, and depending on their choice,
        this may or may not start tracking their location.
    */
    private func attemptToRetrieveUserLocation(){
        
        LocationManager.sharedInstance.showVerboseMessage = true
        LocationManager.sharedInstance.autoUpdate = true
        LocationManager.sharedInstance.startUpdatingLocationWithCompletionHandler { (latitude, longitude, status, verboseMessage, error) -> () in
            
            if( status == LocationManager.sharedInstance.PERMISSION_AUTHORIZED ){
                self.userLat = latitude
                self.userLong = longitude
            }else{
                print(verboseMessage)

            }
        }

        
    }

}

