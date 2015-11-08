//
//  Utils.swift
//  Brewvite
//
//  Created by Justin Simonelli on 10/23/15.
//  Copyright © 2015 Sims. All rights reserved.
//

import Foundation
import MapKit
import SwiftKeychain
import Parse

class Utils {
    class var sharedInstance: Utils {
        struct Static {
            static var instance: Utils?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = Utils()
        }
        
        return Static.instance!
    }
    
    private let dateFormatter:NSDateFormatter = NSDateFormatter()
    private let timeFormatter:NSDateFormatter = NSDateFormatter()
    private var location:CLLocation!
    let sharedKeychain:Keychain = Keychain()
    let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    
    func formatDate(date:NSDate) -> String{
        var formattedDateString = ""
        self.dateFormatter.dateFormat = "MMMM dd"
        self.timeFormatter.dateFormat = "hh:mm a"
        
        let formattedDate:String = dateFormatter.stringFromDate(date),
        formattedTime:String = timeFormatter.stringFromDate(date)
        
        formattedDateString = formattedDate + " at " + formattedTime;
        
        return formattedDateString
    }
    
    /**
     Attempts to retrieve the users location.
     The user will be prompted for their location, and depending on their choice,
     this may or may not start tracking their location.
     */
    func attemptToRetrieveUserLocation() -> CLLocation{
        var userLocation = CLLocation()
        
        LocationManager.sharedInstance.showVerboseMessage = true
        LocationManager.sharedInstance.autoUpdate = true
        LocationManager.sharedInstance.startUpdatingLocationWithCompletionHandler { (latitude, longitude, status, verboseMessage, error) -> () in
            
            if( status == LocationManager.sharedInstance.PERMISSION_AUTHORIZED ){
                self.location = LocationManager.sharedInstance.location
            }else{
                print(verboseMessage)
                
            }
        }
        
        if(self.location != nil){
            userLocation = self.location
        }
        
        return userLocation
        
    }
    
    func delay(delay:Double, closure:()->()) {
        
        dispatch_after(
            dispatch_time( DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), closure)
        
    }
    
    func getKeychainValue(keyName:String) -> AnyObject?{
        let passcodeKey = GenericKey(keyName: keyName) ,
        hasPasscodeKey = Utils.sharedInstance.sharedKeychain.get(passcodeKey)
        
        if( hasPasscodeKey.item?.value != nil){
            return hasPasscodeKey.item?.value;
        }
        
        return nil
    }
    
    func removeKeychainValue(keyName:String) ->  Void{
        Utils.sharedInstance.sharedKeychain.remove(GenericKey(keyName: keyName))
    }
    
    /**
     Return a list of PFUser objects given the provided query.
     **/
    func findUsersByQuery(query:PFQuery, completion: ((results: [PFObject]) -> Void)) {
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                // Do something with the found objects
                if let objects = objects as [PFObject]! {
                    completion(results: objects)
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
    }
    
}