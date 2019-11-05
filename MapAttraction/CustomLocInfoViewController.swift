//
//  CustomLocInfoViewController.swift
//  MapAttraction
//
//  Created by codeplus on 11/5/19.
//  Copyright © 2019 yuqiao liang. All rights reserved.
//

import UIKit

class CustomLocInfoViewController: UIViewController {

    var latitude: Double = 0.0
    var longitude: Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("passed x: \(latitude)")
        print("passed y: \(longitude)")
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         Get the new view controller using segue.destination.
         Pass the selected object to the new view controller.
    }
    */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        
    }

}
