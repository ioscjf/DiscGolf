//
//  CoursesViewController.swift
//  DiscGolf
//
//  Created by Connor Fitzpatrick on 7/28/17.
//  Copyright © 2017 Connor Fitzpatrick. All rights reserved.
//

import UIKit

class CoursesViewController: UIViewController {
    
    // MARK: - Outlets
    
    
    @IBAction func filter(_ sender: UIButton) {
    }
    
    @IBOutlet weak var courses: UITableView!
    
    // MARK: - Variables
    
    let myCourses: [Dictionary<String, AnyObject>]  = [[:]] // preload these into sqlite
    var selectedCourse: Dictionary<String, AnyObject> = [:]

    // MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
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

// MARK: - TableView Extension

extension CoursesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count =  myCourses.count
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "course", for: indexPath) as! CourseTableViewCell
        
        let course = myCourses[(indexPath as NSIndexPath).row]
        cell.configure(course)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCourse = myCourses[indexPath.row]
    }
}
