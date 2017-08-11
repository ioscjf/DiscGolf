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
    @IBOutlet weak var holeDistance: UILabel!
    @IBOutlet weak var driveDistance: UILabel!
    
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
    var activeTextField = UITextField()
    
    var isAnewCourse = false
    
    var holeNum = 0
    var course_id = 0
    var hole_id = 0
    var teeNum = 1
    var holePar = 3
    var teeOrBasket = "tee"
    
    // MARK: - Overrides

    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        beaconManager = BCBeaconManager(delegate: self, queue: nil)
        BCEventManager.shared().delegate = self
        
        holeNumber.text = "Hole \(holeNum)  Tee \(teeNum)" // include basket if course is not new!!
        par.text = "Par: \(holePar)"
        holeDistance.text = "Distance: unknown" // set this if course is not new!!
        
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

            if teeOrBasket == "tee" {// fix this!!
                
            } else { // must be a basket
            }
            // fix!!
//            ahvc.teeOrBasket = "tee" // dynamic
//            ahvc.holeNumber = Int(holeNumber.text)
//            psvc.nameFirst = nameFirst
//            psvc.nameLast = nameLast
//            psvc.team = team
//            psvc.opponent = opponent
        } else if segue.identifier == "switchPadBasket" {
            // pass the current pad/basket
        } else if segue.identifier == "switchBeacon" {
            // pass the current beacon, have it show up as selected.  There should always be a selected beacon
        }
    }
}

// MARK: - Text Field Extension

extension DiscGolfViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.activeTextField = textField
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        self.activeTextField = textField
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.activeTextField = textField
        textField.resignFirstResponder()
        return true
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

// use that one function (like for battery level) to show the distance of the drive!!

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
