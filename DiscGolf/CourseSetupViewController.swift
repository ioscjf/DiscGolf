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
    
    var beaconManager = BCBeaconManager()
    var selectedDisc: BCBeacon? = nil
    var myDiscs: [BCBeacon] = []
    var course_id = 1

    // MARK: - Overrides

    override func viewDidLoad() {
        super.viewDidLoad()

        beaconManager = BCBeaconManager(delegate: self, queue: nil)
        BCEventManager.shared().delegate = self
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
                    if !myDiscs.contains(currentBeacon) {
                        myDiscs.append(currentBeacon)
                        self.discs.reloadData()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "disc", for: indexPath) as! DiscTableViewCell
        
        let disc = myDiscs[(indexPath as NSIndexPath).row]
        cell.configure(disc)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedDisc = myDiscs[indexPath.row]
    }
}
