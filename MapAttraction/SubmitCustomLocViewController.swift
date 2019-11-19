//
//  SubmitCustomLocViewController.swift
//  MapAttraction
//
//  Created by codeplus on 11/6/19.
//  Copyright © 2019 yuqiao liang. All rights reserved.
//

import UIKit

class SubmitCustomLocViewController: UIViewController {

    var selectedTags:[String] = []
    var name: String = ""
    var locDescription: String = ""
    

    @IBAction func btnGoToFirstVCTapped(_ sender: UIButton) {
            performSegue(withIdentifier: "unwindFromSubmitVC", sender: nil)
        }

    
    override func viewDidLoad() {
        super.viewDidLoad()
//        print("custom location:")
//        print("name: \(name)")
//        print("description: \(locDescription)")
//        print("tags: \(selectedTags)")
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
