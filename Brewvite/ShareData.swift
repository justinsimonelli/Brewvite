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
    
    let TRANSITION_ACTIONS = (invites: "INVITES", date:"DATE", venues: "VENUES" )
    let HAS_LOGIN_KEY = "h4s_l0g1n_k3y",
        USER_DEFAULTS_USERNAME_KEY = "u53rn4m3",
        SECURED_ITEM_PASS_KEY = "7h3_p455w0rd_i5";
    
    var selectedVenue : JSONParameters?
    var selectedTransition: String?
    var selectedDate: NSDate?
    

}