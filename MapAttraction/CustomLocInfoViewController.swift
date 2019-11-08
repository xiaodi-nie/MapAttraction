//
//  CustomLocInfoViewController.swift
//  MapAttraction
//
//  Created by codeplus on 11/5/19.
//  Copyright © 2019 yuqiao liang. All rights reserved.
//

import UIKit
import Firebase

class CustomLocInfoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    var selectedTags:[String] = []
    var selectedRating:Int = 0
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    
    @IBOutlet weak var tagsTableView: UITableView!
    @IBOutlet weak var ratingTableView: UITableView!
    
    let tags:[String] = ["Interesting places", "Accomodations", "Adult", "Amusements", "Architecture","Cultual", "Historical", "Industrial facilities", "Natural", "Other", "Religion", "Sport", "Tourist facilities", "Foods", "Shops", "Transport"]
    let ratings:[String] = ["1 Star", "2 Stars", "3 Stars"]
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(tableView == self.tagsTableView){
            print("selected one row")
            let convertedTag = tags[indexPath.row].lowercased().replacingOccurrences(of: " ", with: "_")
            selectedTags.append(convertedTag)
                print("added: \(selectedTags)")
            
        }
        if(tableView == self.ratingTableView){
            selectedRating = indexPath.row + 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        print("deselect")
        let convertedTag = tags[indexPath.row].lowercased().replacingOccurrences(of: " ", with: "_")
        selectedTags.removeAll { $0 == convertedTag }
        print(selectedTags)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tableView == self.tagsTableView){
            return tags.count
            
        }
        else{
            return ratings.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(tableView == self.tagsTableView){
            let myCell = tableView.dequeueReusableCell(withIdentifier: "myTagCell", for: indexPath) as! myTagTableViewCell
            myCell.tagLabel.text = tags[indexPath.row]
            return myCell
            
        }
        else{
            let myRatingCell = tableView.dequeueReusableCell(withIdentifier: "myRatingCell", for: indexPath) as! myRatingTableViewCell
            myRatingCell.ratingLabel.text = ratings[indexPath.row]
            return myRatingCell
            
        }
        
    }
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(CustomLocInfoViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CustomLocInfoViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        // Do any additional setup after loading the view.
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        let textField = UIResponder.firstResponder as? UITextField
        if(textField == self.descriptionTextField){
            guard let userInfo = notification.userInfo else {return}
            guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
            let keyboardFrame = keyboardSize.cgRectValue
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardFrame.height
            }
        }
    }
    
    
    @objc func keyboardWillHide(notification: NSNotification) {
        let textField = UIResponder.firstResponder as? UITextField
        if(textField == self.descriptionTextField){
            guard let userInfo = notification.userInfo else {return}
            guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
            let keyboardFrame = keyboardSize.cgRectValue
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardFrame.height
                }
            
        }
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
    
    
    func saveToDB (name: String, tag: [String], x: Double, y: Double, description: String){
        
    }
    //todo
    //check if data is valid to be added to the database, i.e coordinates can't repeat, same entry can't be entered twice
    func submitToDb()->Bool{
        
        print("latitude: \(latitude)")
        print("longitude: \(longitude)")
        print("tags: \(selectedTags)")
        print("name: \(String(describing: nameTextField.text))")
        print("description: \(String(describing: descriptionTextField.text))")
        print("rating:  \(selectedRating)")
        
        let ref = Database.database().reference(fromURL: "https://mapattraction.firebaseio.com/")
        ref.child("locations").child(nameTextField.text!).updateChildValues(["tag": selectedTags, "x": latitude,"y": longitude, "description": descriptionTextField.text!])
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
