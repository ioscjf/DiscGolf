//
//  DiscTableViewCell.swift
//  DiscGolf
//
//  Created by Connor Fitzpatrick on 7/29/17.
//  Copyright © 2017 Connor Fitzpatrick. All rights reserved.
//

import UIKit

class DiscTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var beaconName: UILabel!
    @IBOutlet weak var serialNumber: UILabel!
    
    // MARK: - Configuration
    
    func configure(_ name: String, beacon: CLBeacon) {
        
        beaconName.text = name
        serialNumber.text = "\(String(format:"%.2f", beacon.accuracy)) (m)"
    }
}
