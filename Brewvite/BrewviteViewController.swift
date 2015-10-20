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

class BrewviteViewController: UIViewController {
    
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var whoButton: UIButton!
    @IBOutlet weak var locationButton: UIButton!
    
    let dateFormatter:NSDateFormatter = NSDateFormatter(),
        timeFormatter:NSDateFormatter = NSDateFormatter()
    
    var userLat: Double = 0.0,
        userLong: Double = 0.0;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        generateButtonBorders(self.dateButton, borderColor: UIColor.whiteColor())
        generateButtonBorders(self.whoButton, borderColor: UIColor.whiteColor())
        generateButtonBorders(self.locationButton, borderColor: UIColor.whiteColor())
        
        attemptToRetrieveUserLocation()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    @IBAction func selectDate(sender: AnyObject) {
        DatePickerDialog().show("Select Time", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: UIDatePickerMode.DateAndTime, minuteInterval: 5) {
            (date) -> Void in
                let buttonTitle = self.generateButtonTitleForDate(date, dateFormatter: self.dateFormatter, timeFormatter: self.timeFormatter)
                self.dateButton.setTitle(buttonTitle, forState: UIControlState.Normal)
        }
    }
    
    private func generateButtonTitleForDate(date:NSDate, dateFormatter:NSDateFormatter, timeFormatter: NSDateFormatter) -> String{
        var buttonTileForDate = ""
        self.dateFormatter.dateFormat = "MMMM dd"
        self.timeFormatter.dateFormat = "hh:mm a"
        
        let formattedDate:String = dateFormatter.stringFromDate(date),
            formattedTime:String = timeFormatter.stringFromDate(date)
        
        buttonTileForDate = formattedDate + " at " + formattedTime;
        
        return buttonTileForDate
    }
    
    /**
        Create a bottom border for the supplied button, and color.
    */
    private func generateButtonBorders( button:UIButton, borderColor: UIColor ){
        let borderAlpha : CGFloat = 0.7
        let cornerRadius : CGFloat = 5.0
        let lineView = UIView(frame: CGRectMake(0, whoButton.frame.size.height - 1, whoButton.frame.size.width, 1))
        lineView.backgroundColor = borderColor
        
        button.addSubview(lineView)
        button.layer.cornerRadius = cornerRadius
        //button.layer.borderColor = UIColor(white: 1.0, alpha: borderAlpha).CGColor
        
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

