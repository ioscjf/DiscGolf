//
//  Course.swift
//  DiscGolf
//
//  Created by Connor Fitzpatrick on 7/29/17.
//  Copyright © 2017 Connor Fitzpatrick. All rights reserved.
//

import Foundation

struct Course {
    
    var courseName: String? // course name (ex. Sugar Bottom Park)
    var location: String? // place on the map (ex. Pella, IA)
    var totalDistance: Double? // the sum of all of the holes for the course
    var totalPar: Int? // the sum of all of the pars for the course
    var numberOfHoles: Int? // the number of holes on the course
}
