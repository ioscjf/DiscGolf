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
            name = courseName.text!
            if let cid = SQL().addCourses(courseName: name, courseLatitude: lat, courseLongitude: long, courseTotalDistance: distance, courseTotalPar: totalpar, courseNumberOfHoles: holeCount, courseRating: rating, courseIsUploaded: uploaded) {
                
                courseID = cid
                
                self.performSegue(withIdentifier: "newCourse", sender: sender)
            } else {
                alert(title: "Oops!", body: "There was an issue creating the course.  Please try again later.")
            }
        }
    }
    
    // MARK: - Variables
    
    var activeTextField = UITextField()
    
    // course info to pass to next view controller
    var courseID = 0
    var name = ""
    var lat = 0.0
    var long = 0.0
    var distance = 0.0
    var totalpar = 54
    var holeCount = 18
    var rating = 0.0
    var uploaded = false
    
    
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
            ahvc.course_id = courseID
            
            ahvc.teeOrBasket = "tee"
            
            if startingHole.text == "" || startingHole.text == nil {
                ahvc.startingHole = 1
            } else {
                ahvc.startingHole = Int(startingHole.text!)!
            }
            
            if numberOfHoles.text == "" || startingHole.text == nil {
                ahvc.numberOfHoles = 18
            } else {
                ahvc.numberOfHoles = Int(numberOfHoles.text!)!
            }
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
