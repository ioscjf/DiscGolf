//
//  CourseSetupViewController.swift
//  DiscGolf
//
//  Created by Connor Fitzpatrick on 7/29/17.
//  Copyright © 2017 Connor Fitzpatrick. All rights reserved.
//

import UIKit
import Gimbal
import CoreLocation

class CourseSetupViewController: UIViewController, GMBLPlaceManagerDelegate, GMBLCommunicationManagerDelegate, CLLocationManagerDelegate {
    
    // MARK: - Outlets
    
    @IBAction func back(_ sender: UIBarButtonItem) {
        if self.presentingViewController != nil {
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    @IBAction func play(_ sender: UIBarButtonItem) {
        // check that setup is all correct!!
        self.performSegue(withIdentifier: "play", sender: sender)
    }
    
    @IBOutlet weak var numberOfPlayers: UITextField!
    @IBOutlet weak var startingHole: UITextField!
    @IBOutlet weak var numberOfHoles: UITextField!
    @IBOutlet weak var discs: UITableView!
    
    // MARK: - Variables
    
//    var beaconManager = BCBeaconManager()
//    var selectedDisc: BCBeacon? = nil
//    var myDiscs: [BCBeacon] = []
    var course_id = 1
    
//    // gimbal
//    var placeManager: GMBLPlaceManager!
//    var placeEvents : [GMBLVisit] = []
//    let communicationManager = GMBLCommunicationManager()
    
    // core location
    var locationManager: CLLocationManager!
    var selectedDisc: CLBeacon? = nil
    var selectedDiscName = ""
    var myDiscs: [String: CLBeacon] = [:]

    // MARK: - Overrides

    override func viewDidLoad() {
        super.viewDidLoad()

//        beaconManager = BCBeaconManager(delegate: self, queue: nil)
//        BCEventManager.shared().delegate = self
//        
//        // gimbal
//        placeManager = GMBLPlaceManager()
//        self.placeManager.delegate = self as GMBLPlaceManagerDelegate
//        
//        self.communicationManager.delegate = self as GMBLCommunicationManagerDelegate
        
//        Gimbal.start()
        
        // core location
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "play" {
            let dgvc = segue.destination as! DiscGolfViewController
            
            dgvc.myBeacon = selectedDisc
            dgvc.myBeaconName = "\(selectedDisc!.major).\(selectedDisc!.minor)"
            //dgvb.numberOfHoles = numberOfHoles
            //dgvb.startingHole = startingHole
        }
    }
    
//    // gimbal
//    func placeManager(_ manager: GMBLPlaceManager!, didBegin visit: GMBLVisit!) -> Void {
//        NSLog("Begin %@", visit.place.description)
//        self.placeEvents.insert(visit, at: 0)
//    }
//    
//    func placeManager(_ manager: GMBLPlaceManager!, didEnd visit: GMBLVisit!) -> Void {
//        NSLog("End %@", visit.place.description)
//        self.placeEvents.insert(visit, at: 0)
//        
//    }
    
    // core location
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    startScanning()
                    print("Scanning...")
                }
            }
        }
    }
    
    func startScanning() {
        let uuid = UUID(uuidString: "1C0E1A1D-D3BC-47B9-A815-DDFACCFE36F6")!
        let beaconRegion = CLBeaconRegion(proximityUUID: uuid, major: 0, minor: 0, identifier: "MyBeacon")
        
        locationManager.startMonitoring(for: beaconRegion)
        locationManager.startRangingBeacons(in: beaconRegion)
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        if beacons.count > 0 {
            if beacons.count > 0 {
                for beacon in beacons {
                        myDiscs["\(beacon.major).\(beacon.minor)"] = beacon
                    
                    let selectedRow = discs.indexPathForSelectedRow
                    self.discs.reloadData()
                    discs.selectRow(at: selectedRow, animated: true, scrollPosition: .none)
                }
            }
        } else {
            // alert about buying beacons!!
        }
    }
}

// MARK: - iBeacon Extension

//extension CourseSetupViewController:  BCBeaconManagerDelegate, BCEventManagerDelegate {
//    private func beaconManager(beaconManager: BCBeaconManager!, didEnterBeacons beacons: [BCBeacon]!) {
//        //print("didEnterBeacons: \(beacons.count)")
//    }
//    
//    func beaconManager(_ beaconManager: BCBeaconManager!, didExitBeacons beacons: [BCBeacon]!) {
//       // print("didExitBeacons: \(beacons.count)")
//    }
//    
//    func beaconManager(_ monitor: BCBeaconManager, didRangeBeacons beacons: [BCBeacon]) {
//        if beacons.count > 0 {
//            for currentBeacon: BCBeacon in beacons {
//                if (currentBeacon.site != nil) {
//                    if !myDiscs.contains(currentBeacon) {
//                        myDiscs.append(currentBeacon)
//                        self.discs.reloadData()
//                    }
//                }
//            }
//        }
//    }
//}

// MARK: - TableView Extension

extension CourseSetupViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count =  myDiscs.count
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "disc", for: indexPath) as! DiscTableViewCell
        
        let key   = Array(self.myDiscs.keys)[indexPath.row]
        let value = Array(self.myDiscs.values)[indexPath.row]
        cell.configure(key, beacon: value)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedDiscName = Array(self.myDiscs.keys)[indexPath.row]
        selectedDisc = Array(self.myDiscs.values)[indexPath.row]
    }
}
