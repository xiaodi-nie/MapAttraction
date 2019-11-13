//
//  PinDetailViewController.swift
//  MapAttraction
//
//  Created by codeplus on 11/11/19.
//  Copyright © 2019 yuqiao liang. All rights reserved.
//

import UIKit

class PinDetailViewController: UIViewController {

    //passed from UserPinViewController
    var xid:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("passed xid: \(xid)")
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
