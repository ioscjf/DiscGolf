//
//  HistoryViewController.swift
//  DiscGolf
//
//  Created by Connor Fitzpatrick on 7/29/17.
//  Copyright © 2017 Connor Fitzpatrick. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        // Testing SQLite!!
        SQL().createCourseTable()
        SQL().addCourses(courseName: "Lake Iowa County Recreation Area", courseLatitude: 41.640664, courseLongitude: -92.178412, courseTotalDistance: 6306, courseTotalPar: 59, courseNumberOfHoles: 18, courseRating: 4.0)
        SQL().getCourses()
        
        SQL().createHoleTable()
        SQL().addHole(holecourse_id: 1, holetee1lat: 41.640664, holetee1long: -92.178412, holetee2lat: 0.0, holetee2long: 0.0, holetee3lat: 0.0, holetee3long: 0.0, holebasket1lat: 41.641590, holebasket1long: -92.179256, holebasket2lat: 0.0, holebasket2long: 0.0, holebasket3lat: 0.0, holebasket3long: 0.0, holepar: 4)
        SQL().getHoles()
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
