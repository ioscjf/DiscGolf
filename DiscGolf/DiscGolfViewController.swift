//
//  DiscGolfViewController.swift
//  DiscGolf
//
//  Created by Connor Fitzpatrick on 7/29/17.
//  Copyright © 2017 Connor Fitzpatrick. All rights reserved.
//

import UIKit
import MapKit

class DiscGolfViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var holeNumber: UILabel!
    @IBOutlet weak var par: UILabel!
    @IBOutlet weak var beaconName: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var players: UITableView!
    
    @IBAction func nextHole(_ sender: UIButton) {
    }
    
    // MARK: - Variables
    
    var beaconManager = BCBeaconManager()
    let regionRadius: CLLocationDistance = 1000
    let players: [String] = []
    let startingHole: Int = 1
    let numberOfHoles: Int = 18

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
        
        centerMapOnLocation(location: initialLocation)
        
        beaconManager = BCBeaconManager(delegate: self, queue: nil)
        BCEventManager.shared().delegate = self
        createBasicTrigger()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: - MapKit Extension

extension DiscGolfViewController {
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius, regionRadius)
        map.setRegion(coordinateRegion, animated: true)
    }
}

// MARK: - iBeacon Extension

extension DiscGolfViewController: BCBeaconManagerDelegate, BCEventManagerDelegate {
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
