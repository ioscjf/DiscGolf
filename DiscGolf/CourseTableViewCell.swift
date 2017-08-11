//
//  CourseTableViewCell.swift
//  DiscGolf
//
//  Created by Connor Fitzpatrick on 7/29/17.
//  Copyright © 2017 Connor Fitzpatrick. All rights reserved.
//

import UIKit

class CourseTableViewCell: UITableViewCell {

    // MARK: - Outlets
    
    @IBOutlet weak var courseName: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var numberOfHoles: UILabel!
    @IBOutlet weak var totalPar: UILabel!
    @IBOutlet weak var totalDistance: UILabel!
    
    
    // MARK: - Configuration
    
    func configure(_ course: Dictionary<String,AnyObject>) { // these need updated!!
        if let n = course["name"] as? String {
            courseName.text = n
        }
        if let l = course["location"] as? String {
            location.text = l
        }
        if let noh = course["numberOfHoles"] as? String {
            numberOfHoles.text = noh
        }
        if let tp = course["totalPar"] as? String {
            totalPar.text = tp
        }
        if let td = course["totalDistance"] as? String {
            totalDistance.text = td
        }
    }
}
