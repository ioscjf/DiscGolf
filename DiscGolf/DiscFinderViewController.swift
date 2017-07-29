//
//  DiscFinderViewController.swift
//  DiscGolf
//
//  Created by Connor Fitzpatrick on 7/28/17.
//  Copyright © 2017 Connor Fitzpatrick. All rights reserved.
//

import UIKit

class DiscFinderViewController: UIViewController, BCBeaconManagerDelegate, BCEventManagerDelegate {
    
    // MARK: - Outlets
        
    @IBOutlet weak var proximity: UILabel!
    
    // MARK: - Variables

    var nearbyAttendees = [AnyObject]()
    var attendeesTable = [AnyHashable: Any]()
    var beaconManager = BCBeaconManager()
    var currentRoom: String = ""
    var sightedBeaconTable = [AnyHashable: Any]()
    var vipNotifications = [Any]()
    var vipSightings = [Any]()
    
    // MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create an instance of the BCBeaconManager object
        
        beaconManager = BCBeaconManager(delegate: self, queue: nil)
        // Get the shared BCEventManager and set delegate to self to use delegate methods and refer to self for various event methods
        BCEventManager.shared().delegate = self
        
//        // Register the event(s)
//        self.monitorVenueEntry()
//        // This registers the event filter for Venue Entry with the delegate
//        self.monitorNearbyVIPs()
//        // This registers the event filter for VIPs with the delegate }
        createBasicTrigger()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - BCBeaconManagerDelegate classes
    
    private func beaconManager(beaconManager: BCBeaconManager!, didEnterBeacons beacons: [BCBeacon]!) {
        print("didEnterBeacons: \(beacons.count)")
    }
    
    func beaconManager(_ beaconManager: BCBeaconManager!, didExitBeacons beacons: [BCBeacon]!) {
        print("didExitBeacons: \(beacons.count)")
    }
    
    func beaconManager(_ monitor: BCBeaconManager, didRangeBeacons beacons: [BCBeacon]) {
        //    This delegate method is going to show how you can add items to an array by getting the detail on your beacons by hand - showing the difference from EvenFilters.
        // Note you have to manually check the site, and the category - so you're searching through each beacon ranged to do this - eventfilters get rid of the need to do this.
        if beacons.count > 0 {
            for currentBeacon: BCBeacon in beacons {
                if (currentBeacon.site != nil) {
                    // We need to check the site because we can see all beacons within the beacon team - especially if beacons and site aren't in private mode.
                    if currentBeacon.categories.count > 0 {
                        var myCATegories = currentBeacon.categories
                        for currentCategory in myCATegories! {
                            if ((currentCategory as AnyObject).name == "Attendee") {
//                                if !nearbyAttendees.contains(where: currentBeacon) {
//                                    // Get current beacon details and create an attendee object
//                                    nearbyAttendees.append(currentBeacon)
////                                    tableView.performSelector(onMainThread: #selector(self.reloadData), with: nil, waitUntilDone: false)
//                                    // Only reload table data on new beacons - don't forget beacon sightings happen a lot!
//                                    print("Added \(currentBeacon.name)")
//                                }
                                print("Added \(currentBeacon.name)")

                            }
                        }
                    }
                }
            }
        }
        print(beacons[0].accuracy)
        print(beacons[0].batteryStatus)
        print(beacons[0].beaconMode)
        print(beacons[0].mapPoint)
        print(beacons[0].proximity.rawValue)
        print(beacons[0].proximity.hashValue)
        print(beacons[0].rssi)
        print("\n\n\n\n")
    }
    
    func createBasicTrigger(){
        
        //generates a trigger with a random identifier
        let trigger: BCTrigger! = BCTrigger()
        
        //add your filters
        //filter by site
        trigger.add(BCEventFilter.bySitesNamed(["DiscFinder"]))
        //filter to within 10cm
//        trigger.add(BCEventFilter.byAccuracyRange(from: 0.0, to: 0.1))
        
        
        //repeat indefinitely, or however many times you want
        trigger.repeatCount = NSIntegerMax
        
        //add your trigger to the event manager
        BCEventManager.shared().monitorEvent(with: trigger)
    }
    
    func eventManager(_ eventManager: BCEventManager!, triggeredEvent: BCTriggeredEvent!) {
        //do something with the filtered micro-location here when the trigger is fired

    }
}
