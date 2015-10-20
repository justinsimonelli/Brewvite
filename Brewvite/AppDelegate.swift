//
//  AppDelegate.swift
//  Brewvite
//
//  Created by Justin Simonelli on 10/13/15.
//  Copyright © 2015 Sims. All rights reserved.
//

import UIKit
import CoreData
//import Parse

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    enum ShortcutIdentifier: String {
        case CreateInvite
        case ViewLists
        case ViewInvites
        
        init?(fullIdentifier: String) {
            guard let shortIdentifier = fullIdentifier.componentsSeparatedByString(".").last else {
                return nil
            }
            self.init(rawValue: shortIdentifier)
        }
        
        var type: String{
            return NSBundle.mainBundle().bundleIdentifier! + ".\(self.rawValue)"
        }
    }
    
    let shortcutViewControllers = (create:"CreateView", invites:"InvitesView", lists:"ListsView" )

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        //Parse.setApplicationId("rWu8TjmSH2OlM33SjNfVHeQ0umpBe0m5mNy6orif", clientKey: "DT1aEIRGWx6QLeDAT5qImcl6rN8iiyHTPBnldmsV")
        
        
        if let shortcutItem = launchOptions?[UIApplicationLaunchOptionsShortcutItemKey] as? UIApplicationShortcutItem {
            handleShortcut(shortcutItem)
            return false
        }
        
        return true
    }
    
    func application(application: UIApplication,
        performActionForShortcutItem shortcutItem: UIApplicationShortcutItem,
        completionHandler: (Bool) -> Void) {
            
            completionHandler(handleShortcut(shortcutItem))
    }
    
    private func handleShortcut(shortcutItem: UIApplicationShortcutItem) -> Bool {

        var handled = false
        
        guard ShortcutIdentifier(fullIdentifier: shortcutItem.type) != nil else { return false }
        
        guard let shortCutType = shortcutItem.type as String? else { return false }
        
        let storyBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        var vc:UIViewController = UIViewController()
        
        switch (shortCutType) {
        case ShortcutIdentifier.CreateInvite.type:
            vc = storyBoard.instantiateViewControllerWithIdentifier(shortcutViewControllers.create)
            handled = true
            break
        case ShortcutIdentifier.ViewInvites.type:
            vc = storyBoard.instantiateViewControllerWithIdentifier(shortcutViewControllers.invites)
            handled = true
            break
        case ShortcutIdentifier.ViewLists.type:
            vc = storyBoard.instantiateViewControllerWithIdentifier(shortcutViewControllers.lists)
            handled = true
            break
        default:
            break
        }
        
        self.window?.rootViewController = vc
        self.window?.makeKeyAndVisible()
        
        return handled
    }
    

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        //UIApplication.sharedApplication().applicationIconBadgeNumber = 0
        
    }

    

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.

    }


}

