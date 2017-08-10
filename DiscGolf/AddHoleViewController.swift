//
//  AddHoleViewController.swift
//  DiscGolf
//
//  Created by Connor Fitzpatrick on 8/10/17.
//  Copyright © 2017 Connor Fitzpatrick. All rights reserved.
//

import UIKit

class AddHoleViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate {
    
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
        
        //find a more clever way to do this!!
//        SQL().addHole(holecourse_id: courseID, holetee1lat: <#T##Double#>, holetee1long: <#T##Double#>, holetee2lat: <#T##Double#>, holetee2long: <#T##Double#>, holetee3lat: <#T##Double#>, holetee3long: <#T##Double#>, holebasket1lat: <#T##Double#>, holebasket1long: <#T##Double#>, holebasket2lat: <#T##Double#>, holebasket2long: <#T##Double#>, holebasket3lat: <#T##Double#>, holebasket3long: <#T##Double#>, holepar: <#T##Int#>, holetee1picPath: <#T##String#>, holetee2picPath: <#T##String#>, holetee3picPath: <#T##String#>, holebasket1picPath: <#T##String#>, holebasket2picPath: <#T##String#>, holebasket3picPath: <#T##String#>)
        
        // then navigate to the next screen!!
    }
    
    // MARK: - Variables
    
    let imagePicker = UIImagePickerController()
    let locationManager = CLLocationManager()
    var currentLongitude = 0.0
    var currentLatitude = 0.0
    var holeNumber = 1
    var teeOrBasket = "tee"
    let pickerData = ["1/A","2/B","3/C"]
    var courseID = 1
    
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
            print(paths) // add this to the database!!
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

