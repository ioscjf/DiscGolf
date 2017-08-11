//
//  AddHoleViewController.swift
//  DiscGolf
//
//  Created by Connor Fitzpatrick on 8/10/17.
//  Copyright © 2017 Connor Fitzpatrick. All rights reserved.
//

import UIKit

class AddHoleViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate { // this file should only be used for new holes on new courses.  Use a different file to update holes on courses (and add more tee pads/baskets to existing holes on existing courses)
    
    // MARK: - Outlets
    
    @IBOutlet weak var instructions: UILabel!
    @IBOutlet weak var selectedImage: UIImageView!
    @IBOutlet weak var holeLetter: UILabel!
    @IBOutlet weak var holeLetterPicker: UIPickerView!
    @IBOutlet weak var par: UITextField!
    
    @IBAction func takePhoto(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            imagePicker.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            alert(title: "There seems to be an issue with your camera", body: "Please check that the camera is working on your device, and that DiscFinder has permission to use it in your settings")
        }
    }
    
    @IBAction func submit(_ sender: UIButton) {
        var h1lat = 0.0
        var h1long = 0.0
        var h2lat = 0.0
        var h2long = 0.0
        var h3lat = 0.0
        var h3long = 0.0
        var b1lat = 0.0
        var b1long = 0.0
        var b2lat = 0.0
        var b2long = 0.0
        var b3lat = 0.0
        var b3long = 0.0
        var holePar = 0
        var h1picPath = ""
        var h2picPath = ""
        var h3picPath = ""
        var b1picPath = ""
        var b2picPath = ""
        var b3picPath = ""
        
        let uuid = NSUUID().uuidString
        let imagePath = "\(course_id)\(uuid).jpg" // can't access the hole_id (hasn't always been created).  Using a uuid instead so each path is unique
        
        let courseInfo = SQL().getCourse(courseID: course_id)
        
        if teeOrBasket == "tee" {
            switch selectedPadNumberLetter {
            case 1:
                h1lat = currentLatitude
                h1long = currentLongitude
                h1picPath = imagePath
            case 2:
                h2lat = currentLatitude
                h2long = currentLongitude
                h2picPath = imagePath
            case 3:
                h3lat = currentLatitude
                h3long = currentLongitude
                h3picPath = imagePath
            default:
                print("ERROR: TOO MANY TEE PADS")
            }
            
            let p = par.text
            if p != "" && p != nil {
                holePar = Int(p!)!
            }
            if let hid = SQL().addHole(holecourse_id: course_id, holetee1lat: h1lat, holetee1long: h1long, holetee2lat: h2lat, holetee2long: h2long, holetee3lat: h3lat, holetee3long: h3long, holebasket1lat: b1lat, holebasket1long: b1long, holebasket2lat: b2lat, holebasket2long: b2long, holebasket3lat: b3lat, holebasket3long: b3long, holepar: holePar, holetee1picPath: h1picPath, holetee2picPath: h2picPath, holetee3picPath: h3picPath, holebasket1picPath: b1picPath, holebasket2picPath: b2picPath, holebasket3picPath: b3picPath) {
                hole_id = hid
            } else {
                alert(title: "Oops!", body: "There was an error adding the hole.  Please try again later.")
                return
            }
            
            if holeNumber == 1 {
                let newpar = (courseInfo["totalPar"] as! Int) + holePar
                SQL().updateCourse(idNum: course_id, courseName: courseInfo["name"] as! String, courseLatitude: currentLatitude, courseLongitude: currentLongitude, courseRating: courseInfo["rating"] as! Double, courseTotalPar: newpar, courseNumberOfHoles: courseInfo["numberOfHoles"] as! Int, courseTotalDistance: courseInfo["totalDistance"] as! Double, courseIsUploaded: courseInfo["isUploaded"] as! Bool)
            } else {
                let newpar = (courseInfo["totalPar"] as! Int) + holePar
                SQL().updateCourse(idNum: course_id, courseName: courseInfo["name"] as! String, courseLatitude: courseInfo["latitude"] as! Double, courseLongitude: courseInfo["longitude"] as! Double, courseRating: courseInfo["rating"] as! Double, courseTotalPar: newpar, courseNumberOfHoles: courseInfo["numberOfHoles"] as! Int, courseTotalDistance: courseInfo["totalDistance"] as! Double, courseIsUploaded: courseInfo["isUploaded"] as! Bool)
            }
        } else { // should be a basket, in which case the hole should already exist, so update it
            switch selectedPadNumberLetter {
            case 1:
                b1lat = currentLatitude
                b1long = currentLongitude
                b1picPath = imagePath
                teeNumberForDistance = 1
            case 2:
                b2lat = currentLatitude
                b2long = currentLongitude
                b2picPath = imagePath
                teeNumberForDistance = 2
            case 3:
                b3lat = currentLatitude
                b3long = currentLongitude
                b3picPath = imagePath
                teeNumberForDistance = 3
            default:
                print("ERROR: TOO MANY BASKETS")
            }
            
            let holeInfo = SQL().getHole(holeId: hole_id)
            
            SQL().updateHole(idNum: hole_id, holecourse_id: holeInfo["courseID"] as! Int, holetee1lat: holeInfo["tee1lat"] as! Double, holetee1long: holeInfo["tee1long"] as! Double, holetee2lat: holeInfo["tee2lat"] as! Double, holetee2long: holeInfo["tee2long"] as! Double, holetee3lat: holeInfo["tee3lat"] as! Double, holetee3long: holeInfo["tee3long"] as! Double, holebasket1lat: b1lat, holebasket1long: b1long, holebasket2lat: b2lat, holebasket2long: b2long, holebasket3lat: b3lat, holebasket3long: b3long, holepar: holeInfo["par"] as! Int, holetee1picPath: holeInfo["tee1picPath"] as! String, holetee2picPath: holeInfo["tee2picPath"] as! String, holetee3picPath: holeInfo["tee3picPath"] as! String, holebasket1picPath: b1picPath, holebasket2picPath: b2picPath, holebasket3picPath: b3picPath)
            
            var coordinate0 = CLLocation(latitude: 0.0, longitude: 0.0)

            switch teeNumberForDistance {
            case 1:
                coordinate0 = CLLocation(latitude: holeInfo["tee1lat"]! as! CLLocationDegrees, longitude: holeInfo["tee1long"] as! CLLocationDegrees)
            case 2:
                coordinate0 = CLLocation(latitude: holeInfo["tee2lat"]! as! CLLocationDegrees, longitude: holeInfo["tee2long"] as! CLLocationDegrees)
            case 3:
                coordinate0 = CLLocation(latitude: holeInfo["tee3lat"]! as! CLLocationDegrees, longitude: holeInfo["tee3long"] as! CLLocationDegrees)
            default:
                print("ERROR: TOO MANY TEES")
            }
            
            let coordinate1 = CLLocation(latitude: currentLatitude, longitude: currentLongitude)
            let holeDistance = coordinate0.distance(from: coordinate1) * 3.28084
            let distance = (courseInfo["totalDistance"] as! Double) + holeDistance
            SQL().updateCourse(idNum: course_id, courseName: courseInfo["name"] as! String, courseLatitude: courseInfo["latitude"] as! Double, courseLongitude: courseInfo["longitude"] as! Double, courseRating: courseInfo["rating"] as! Double, courseTotalPar: courseInfo["totalPar"] as! Int, courseNumberOfHoles: courseInfo["numberOfHoles"] as! Int, courseTotalDistance: distance, courseIsUploaded: courseInfo["isUploaded"] as! Bool)
        }
        
        saveImageDocumentDirectory(imageName: imagePath)
        
        self.performSegue(withIdentifier: "backToPlaying", sender: sender)
    }
    
    // MARK: - Variables
    
    var activeTextField = UITextField()
    let imagePicker = UIImagePickerController()
    let locationManager = CLLocationManager()
    var currentLongitude = 0.0
    var currentLatitude = 0.0
    var holeNumber = 1
    var teeOrBasket = "tee"
    let pickerData = ["A","B","C"]
    var selectedPadNumberLetter = 1
    var teeNumberForDistance = 1 // use the last selected pad number.  This variable should be passed to this view controller
    
    // hole info
    var hole_id = 0

    // course info
    var course_id = 0
    
    // game info
    var numberOfHoles = 18
    var startingHole = 1
    var currentHoleNum = 0
    
    // MARK: - Overrides

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        if teeOrBasket == "tee" {
            instructions.text = "While standing on the teepad, take a picture of the fareway"
        } else { // must be a basket
            instructions.text = "While standing as close as possible to the basket, take a picture of it.  Include the number if possible"
        }
        
        par.enablesReturnKeyAutomatically = true // this should have been set in the storyboard but had issues with it
        par.delegate = self
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
        
        // pass holeID and course info!!
        if segue.identifier == "backToPlaying" {
            let dgvc = segue.destination as! DiscGolfViewController
            dgvc.course_id = course_id
            dgvc.hole_id = hole_id
            
            if currentHoleNum == 0 {
                dgvc.holeNum = startingHole
            } else {
                dgvc.holeNum = currentHoleNum + 1
                
                // wrap around to 1 after 18?!!
                // keep track of this from an array instead of an int so users
                // can add as many holes as they want and start at the hole they
                // select in the table view (to be added)
            }
            
            dgvc.numberOfHoles = numberOfHoles
            
            if teeOrBasket == "tee" {
                dgvc.teeNum = selectedPadNumberLetter
                dgvc.teeOrBasket = "basket"
            } else { // must be a basket
                // can't set dgvc.basketNum because it is not known until after the hole is complete
                dgvc.teeOrBasket = "tee"
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            selectedImage.image = image
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func saveImageDocumentDirectory(imageName: String) {
        let fileManager = FileManager.default
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(imageName)
        let image = selectedImage.image
        
        if let i = image { // compress the image!!
            // print(paths)
            let imageData = UIImageJPEGRepresentation(i, 0.5)
            fileManager.createFile(atPath: paths as String, contents: imageData, attributes: nil)
        } else {
            alert(title: "Oops!", body: "You need to take a picture of the \(teeOrBasket) before submitting the hole")
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
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        currentLatitude = locValue.latitude
        currentLongitude = locValue.longitude
    }
}

// MARK: - Text Field Extension

extension AddHoleViewController: UITextFieldDelegate {
    
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

// MARK: - Picker View Extension

extension AddHoleViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    }
}

