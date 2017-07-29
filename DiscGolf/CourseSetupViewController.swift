//
//  CourseSetupViewController.swift
//  DiscGolf
//
//  Created by Connor Fitzpatrick on 7/29/17.
//  Copyright © 2017 Connor Fitzpatrick. All rights reserved.
//

import UIKit

class CourseSetupViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBAction func back(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func play(_ sender: UIBarButtonItem) {
    }
    
    @IBOutlet weak var numberOfPlayers: UITextField!
    @IBOutlet weak var startingHole: UITextField!
    @IBOutlet weak var numberOfHoles: UITextField!
    @IBOutlet weak var discs: UITableView!
    
    // MARK: - Variables
    
    var beaconManager = BCBeaconManager()
    var selectedDisc: BCBeacon?
    var myDiscs: [BCBeacon]

    // MARK: - Overrides

    override func viewDidLoad() {
        super.viewDidLoad()

        beaconManager = BCBeaconManager(delegate: self, queue: nil)
        BCEventManager.shared().delegate = self
        createBasicTrigger()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "play" {
            let destinationNavigationController = segue.destination as! UINavigationController
            let dgvc = destinationNavigationController.topViewController as! DiscGolfViewController
            
            dgvc.myBeacon = selectedDisc
            //dgvb.numberOfHoles = numberOfHoles
            //dgvb.startingHole = startingHole
        }
    }
}

// MARK: - iBeacon Extension

extension CourseSetupViewController:  BCBeaconManagerDelegate, BCEventManagerDelegate {
    private func beaconManager(beaconManager: BCBeaconManager!, didEnterBeacons beacons: [BCBeacon]!) {
        print("didEnterBeacons: \(beacons.count)")
    }
    
    func beaconManager(_ beaconManager: BCBeaconManager!, didExitBeacons beacons: [BCBeacon]!) {
        print("didExitBeacons: \(beacons.count)")
    }
    
    func beaconManager(_ monitor: BCBeaconManager, didRangeBeacons beacons: [BCBeacon]) {
        if beacons.count > 0 {
            for currentBeacon: BCBeacon in beacons {
                if (currentBeacon.site != nil) {
                    if !discs.contains(where: currentBeacon) {
                        myDiscs.append(currentBeacon)
                        tableView.performSelector(onMainThread: #selector(self.reloadData), with: nil, waitUntilDone: false)
                    }
                }
            }
        }
    }
}

// MARK: - TableView Extension

extension CourseSetupViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count =  myDiscs.count
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "disc", for: indexPath) as! StatPlayerTableViewCell
        
        let disc = myDiscs[(indexPath as NSIndexPath).row]
        cell.configure(disc)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedDisc = "\(myDiscs[indexPath.row]!)"
    }
}
