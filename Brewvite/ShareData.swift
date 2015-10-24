//
//  ShareData.swift
//  Brewvite
//
//  Created by Justin Simonelli on 10/21/15.
//  Copyright © 2015 Sims. All rights reserved.
//

import Foundation

typealias JSONParameters = [String: AnyObject]

class ShareData {
    class var sharedInstance: ShareData {
        struct Static {
            static var instance: ShareData?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = ShareData()
        }
        
        return Static.instance!
    }
    
    var TRANSITION_ACTIONS = (invites: "INVITES", date:"DATE", venues: "VENUES" )
    
    var selectedVenue : JSONParameters?
    var selectedTransition: String?
    var selectedDate: NSDate?
    

}