//
//  PlayerTableViewCell.swift
//  DiscGolf
//
//  Created by Connor Fitzpatrick on 7/29/17.
//  Copyright © 2017 Connor Fitzpatrick. All rights reserved.
//

import UIKit

class PlayerTableViewCell: UITableViewCell {

    // MARK: - Outlets
    
    @IBOutlet weak var playerName: UILabel!
    @IBOutlet weak var playerScore: UITextField!
    
    // MARK: - Configuration

    func configure(_ name: String) {
        
        playerName.text = name
    }
    
    // add a function to get the score!!
}
