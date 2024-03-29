//
//  AppDelegate.swift
//  DiscGolf
//
//  Created by Connor Fitzpatrick on 7/21/17.
//  Copyright © 2017 Connor Fitzpatrick. All rights reserved.
//

import UIKit
import CoreData
import Gimbal

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        initBlueCatsSDK(appToken: "d096bcb6-f99c-4485-85fa-168656cb72fc")
        
        Gimbal.setAPIKey("d9a94eaa-b6bf-47fb-9271-3c0c214fec77", options: nil)

        
        SQL().createCourseTable()
        SQL().createHoleTable()
        SQL().createGameTable()
        SQL().createScoresTable()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "DiscGolf")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: - BlueCats SDK
    func initBlueCatsSDK(appToken: String) {
        //start the sdk using BCAppToken from our constants file AppConstants.h
        BlueCatsSDK.startPurring(withAppToken: appToken, completion: {(_ status: BCStatus) -> Void in
            if !BlueCatsSDK.isLocationAuthorized() {
                BlueCatsSDK.requestAlwaysLocationAuthorization()
                //Allows beacon ranging when the app is not in use.
                //[BlueCatsSDK requestWhenInUseLocationAuthorization]; "WhenInUse" only allows beacon ranging when the app is used.
                print("Location not authorized")
                // alert user!!
            }
            if !BlueCatsSDK.isNetworkReachable() {
                //The BlueCats SDK must have network connectivity at least once before ranging beacons.
                //If this is the only error and the SDK has never reached the network purring will occur with network connectivity.
                print("Network not reachable")
                // alert user!!
            }
            if !BlueCatsSDK.isBluetoothEnabled() {
                //Prompt user to enable bluetooth in settings.  If BLE is required for current functionality a modal is recommended.
                print("Bluetooth not enabled")
                // alert user!!
            }
        })
    }

}
