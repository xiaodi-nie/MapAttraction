//
//  CustomLocInfoViewController.swift
//  MapAttraction
//
//  Created by codeplus on 11/5/19.
//  Copyright © 2019 yuqiao liang. All rights reserved.
//

import UIKit

class CustomLocInfoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    var selectedTags:[String] = []
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    
    
    let tags:[String] = ["Interesting places", "Accomodations", "Adult", "Amusements", "Architecture","Cultual", "Historical", "Industrial facilities", "Natural", "Other", "Religion", "Sport", "Tourist facilities", "Foods", "Shops", "Transport"]
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected one row")
        let convertedTag = tags[indexPath.row].lowercased().replacingOccurrences(of: " ", with: "_")
        selectedTags.append(convertedTag)
        print("added: \(selectedTags)")
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        print("deselect")
        let convertedTag = tags[indexPath.row].lowercased().replacingOccurrences(of: " ", with: "_")
        selectedTags.removeAll { $0 == convertedTag }
        print(selectedTags)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tags.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myCell = tableView.dequeueReusableCell(withIdentifier: "myTagCell", for: indexPath) as! myTagTableViewCell
        myCell.tagLabel.text = tags[indexPath.row]
        return myCell
    }
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print("passed x: \(latitude)")
        //print("passed y: \(longitude)")
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
    }
    
    
    //this one is called after the shouldPerformSegue function and it's only called
    //when shouldPerformSegue returns true
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
//        if segue.destination is CustomLocInfoViewController
//        {
//            let vc = segue.destination as? SubmitCustomLocViewController
//
//            vc?.name = nameTextField.text
//            vc?.longitude = name
//        }
        print("prepare")
    }
    
    //todo
    //check if data is valid to be added to the database, i.e coordinates can't repeat, same entry can't be entered twice
    func submitToDb()->Bool{
        
        print("latitude: \(latitude)")
        print("longitude: \(longitude)")
        print("tags: \(selectedTags)")
        print("name: \(String(describing: nameTextField.text))")
        print("description: \(String(describing: descriptionTextField.text))")
        return true
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {

        if identifier == "submitSegue" {
            if nameTextField.text!.isEmpty || descriptionTextField.text!.isEmpty || selectedTags.isEmpty {
                let alertController = UIAlertController(
                    title: "Empty Fields",
                    message: "Name, Tags and Description can't be empty, please fill them in",
                    preferredStyle: .alert
                )
                alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in}))

                present(alertController, animated: true, completion: nil)
                return false
            }
        }
        
        if !submitToDb(){
            let dbAlertController = UIAlertController(
                title: "Invalid Data",
                message: "Coordinates already exists, please choose another spot",
                preferredStyle: .alert
            )
            dbAlertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in}))

            present(dbAlertController, animated: true, completion: nil)
            return false
        }

        
        return true
    }

}
