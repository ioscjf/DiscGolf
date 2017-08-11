//
//  AddCourseViewController.swift
//  DiscGolf
//
//  Created by Connor Fitzpatrick on 8/10/17.
//  Copyright © 2017 Connor Fitzpatrick. All rights reserved.
//

import UIKit

class AddCourseViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var courseName: UITextField!
    @IBOutlet weak var numberOfHoles: UITextField!
    @IBOutlet weak var startingHole: UITextField!
    
    @IBAction func back(_ sender: UIBarButtonItem) {
        if self.presentingViewController != nil {
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    @IBAction func play(_ sender: UIBarButtonItem) {
        
        if courseName.text == "" {
            alert(title: "Oops!", body: "Every course must have a name")
        } else {
            SQL().addCourses(courseName: courseName.text!, courseLatitude: 0.0, courseLongitude: 0.0, courseTotalDistance: 0.0, courseTotalPar: 54, courseNumberOfHoles: 18, courseRating: 0.0, courseIsUploaded: false)
            
            // navigate via segue!!
            // pass course name in segue for retrieval from database to update lat/long/distance/etc
        }
    }
    
    

//    let name = Expression<String>("name")
//    let latitude = Expression<Double>("latitude")
//    let longitude = Expression<Double>("longitude")
//    let rating = Expression<Double>("rating")
//    let totalPar = Expression<Int>("totalPar")
//    let numberOfHoles = Expression<Int>("numberOfHoles")
//    let totalDistance = Expression<Double>("totalDistance")
//    let isUploaded = Expression<Bool>("isUploaded")
    
    // MARK: - Variables
    
    var activeTextField = UITextField()
    
    // MARK: - Overrides

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
        
        if segue.identifier == "newCourse" {
            let ahvc = segue.destination as! AddHoleViewController
            // fix!!
//            ahvc.teeOrBasket = "tee" // dynamic
//            ahvc.holeNumber = Int(holeNumber.text)
//            psvc.nameFirst = nameFirst
//            psvc.nameLast = nameLast
//            psvc.team = team
//            psvc.opponent = opponent
        }
    }

    func alert(title: String, body: String) {
        let alertController = UIAlertController(title: title, message: body, preferredStyle: UIAlertControllerStyle.alert)
        
        let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            (result : UIAlertAction) -> Void in
        }
        
        alertController.addAction(ok)
        self.present(alertController, animated: true, completion: nil)
    }
}

// MARK: - Text Field Extension

extension AddCourseViewController: UITextFieldDelegate {
    
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
