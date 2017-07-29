//
//  BeaconDelegate.swift
//  DiscGolf
//
//  Created by Connor Fitzpatrick on 7/28/17.
//  Copyright © 2017 Connor Fitzpatrick. All rights reserved.
//

import Foundation

class BeaconDelegate: NSObject, CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
        // Called when device first enters beacon range
    }
    func locationManager(manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], inRegion region: CLBeaconRegion) {
        // Called when device is in beacons signal range and moving
    }
    func locationManager(manager: CLLocationManager, didExitRegion region: CLRegion) {
        // Called when device exits beacon range
    }
}
