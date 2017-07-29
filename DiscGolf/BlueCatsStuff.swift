////
////  BlueCatsStuff.swift
////  DiscGolf
////
////  Created by Connor Fitzpatrick on 7/28/17.
////  Copyright © 2017 Connor Fitzpatrick. All rights reserved.
////
//
//import Foundation
//
//var beaconManager = BCBeaconManager()
//
//beaconManager = BCBeaconManager.init(delegate: self, queue: nil)
//// location detection...
//// BlueCatsSDK.requestAlwaysLocationAuthorization()
//
//private func beaconManager(beaconManager: BCBeaconManager!, didEnterBeacons beacons: [BCBeacon]!) {
//    print("didEnterBeacons: \(beacons.count)")
//}
//
//func beaconManager(_ beaconManager: BCBeaconManager!, didRangeBeacons beacons: [BCBeacon]!) {
//    print("didRangeBeacons: \(beacons.count)")
//}
//
//func beaconManager(_ beaconManager: BCBeaconManager!, didExitBeacons beacons: [BCBeacon]!) {
//    print("didExitBeacons: \(beacons.count)")
//}
//
//func searchForBeacons() {
//    var appManagedRegion = BCBeaconRegion()
//    appManagedRegion.proximityUUIDString = "24212d3c-7cc5-4844-bcf6-5ecba50b5aa9"
//    
//    func addAppManagedRegion() {
//        beaconManager.startMonitoringBeaconRegion(appManagedRegion)
//    }
//    
//    func beaconManager(monitor: BCBeaconManager!, didRangeIBeacons iBeacons: [BCBeacon]!) {
//        for beacon in iBeacons {
//            if beacon.proximityUUIDString == appManagedRegion.proximityUUIDString {
//                print("Found beacon in app managed region!")
//            }
//        }
//    }
//}
//
//func createBasicTrigger(){
//    
//    //generates a trigger with a random identifier
//    let trigger: BCTrigger! = BCTrigger()
//    
//    //add your filters
//    //filter by site
//    trigger.add(BCEventFilter.bySitesNamed(["Cat Cafe"]))
//    //filter to within 10cm
//    trigger.addFilter(BCEventFilter.BCEventFilter.filterByAccuracyRangeFrom(0.0, to: 0.1))
//    
//    //repeat indefinitely, or however many times you want
//    trigger.repeatCount = NSIntegerMax
//    
//    //add your trigger to the event manager
//    BCEventManager.shared().monitorEvent(with: trigger)
//}
//
//func eventManager(eventManager: BCEventManager!, triggeredEvent: BCTriggeredEvent!) {
//    //do something with the filtered micro-location here when the trigger is fired
//}
//
//// Before you will receive micro-location updates, you must send startUpdatingMicroLocation() to your BCMicroLocationManager. To stop receiving updates, call stopUpdatingMicroLocation().
