//
//  DiscsViewController.swift
//  DiscGolf
//
//  Created by Connor Fitzpatrick on 7/28/17.
//  Copyright © 2017 Connor Fitzpatrick. All rights reserved.
//

import UIKit

class DiscsViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var discTable: UITableView!

    @IBAction func addDiscs(_ sender: UIButton) {
    }
    
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
