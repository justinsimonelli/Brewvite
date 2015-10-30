//
//  BrewviteUsersX.swift
//  Brewvite
//
//  Created by Justin Simonelli on 10/29/15.
//  Copyright © 2015 Sims. All rights reserved.
//

import Foundation
import Parse

class BrewviteUsersX : PFObject, PFSubclassing {
    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
    static func parseClassName() -> String {
        return "BrewviteUsersX"
    }
    
    override init(){
        super.init()
    }
    
    @NSManaged var brewvite:PFObject!
    @NSManaged var inviteDate:NSDate!
    @NSManaged var location:PFGeoPoint!
}