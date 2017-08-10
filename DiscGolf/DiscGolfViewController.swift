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
        if isAnewCourse {
            // navigate to the other view controller to add a hole/basket
            self.performSegue(withIdentifier: "newHole", sender: self)
        } else {
            // refresh the screen with the next hole's information
        }
    }
    
    // MARK: - Variables
    
    var beaconManager = BCBeaconManager()
    let regionRadius: CLLocationDistance = 1000
    var myPlayers: [String] = []
    var startingHole: Int = 1
    var numberOfHoles: Int = 18
    var myBeacon: BCBeacon? = nil
    var locationManager = CLLocationManager()
    
    var isAnewCourse = false

    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        beaconManager = BCBeaconManager(delegate: self, queue: nil)
        BCEventManager.shared().delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "newHole" {
            let ahvc = segue.destination as! AddHoleViewController

            // fix!!
//            ahvc.teeOrBasket = "tee" // dynamic
//            ahvc.holeNumber = Int(holeNumber.text)
//            psvc.nameFirst = nameFirst
//            psvc.nameLast = nameLast
//            psvc.team = team
//            psvc.opponent = opponent
        }
    }
}

// MARK: - MapKit Extension

extension DiscGolfViewController: CLLocationManagerDelegate, MKMapViewDelegate {
    private func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        manager.startUpdatingLocation()
        
        // use this stuff!!
//         alert user if not connected as exception handling (eventually)!!
//        //    switch status {
//        case .authorizedAlways, .authorizedWhenInUse:
//        return
//        
//        case .denied, .restricted:
//        print("location access denied")
//        
//        default:
//        locationManager.requestWhenInUseAuthorization()
//    }
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        let region: MKCoordinateRegion = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 200, 200)
        self.map?.setRegion((self.map?.regionThatFits(region))!, animated: true)
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
        if beacons.count > 0 {
            for currentBeacon: BCBeacon in beacons {
                if myBeacon == currentBeacon {
                    if currentBeacon.accuracy == -1 {
                        distance.text = "Unknown (m)"
                    } else {
                        
                        distance.text = "\(String(format:"%.2f", currentBeacon.accuracy)) (m)"
                    }
                }
            }
        }
    }
}

// MARK: - TableView Extension

extension DiscGolfViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count =  myPlayers.count
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "player", for: indexPath) as! PlayerTableViewCell
        
        let player = myPlayers[(indexPath as NSIndexPath).row]
        cell.configure(player)
        
        return cell
    }
}
