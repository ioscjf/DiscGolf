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
    let myPlayers: [String] = []
    let startingHole: Int = 1
    let numberOfHoles: Int = 18
    let myBeacon: BCBeacon?

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
        if beacons.count > 0 {
            for currentBeacon: BCBeacon in beacons {
                if myBeacon == currentBeacon {
                    distance.text = "\(currentBeacon.accuracy)"
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "player", for: indexPath) as! StatPlayerTableViewCell
        
        let player = myPlayers[(indexPath as NSIndexPath).row]
        cell.configure(player)
        
        return cell
    }
}
