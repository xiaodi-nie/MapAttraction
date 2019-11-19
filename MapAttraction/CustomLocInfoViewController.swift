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
    var dbIndex:Int = 0
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    
    @IBOutlet weak var tagsTableView: UITableView!
    @IBOutlet weak var ratingTableView: UITableView!
    
    //data source for tags and ratings tableView
    let tags:[String] = ["Interesting places", "Accomodations", "Adult", "Amusements", "Architecture","Cultual", "Historical", "Industrial facilities", "Natural", "Other", "Religion", "Sport", "Tourist facilities", "Foods", "Shops", "Transport"]
    let ratings:[String] = ["1 Star", "2 Stars", "3 Stars"]
    
    //called every time user select a row in any tableView, update user selected data accordingly
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
    
    //called every time user deselect a row in any tableView, remove entry from selected tags array
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
    
    //use different identifier to populate different tableViews
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
        
        //the following code snippet is used to enable touching on screen to dismiss keyboard
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        //the following code snippet is used to register keyboardWillShow and keyboardWillHide notification to move the view up or down, it can prevent keyboard from blocking the text field on the view
        NotificationCenter.default.addObserver(self, selector: #selector(CustomLocInfoViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CustomLocInfoViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        // Do any additional setup after loading the view.
    }
    
    //move view up the height of the keyboard when descriptionTextField is the first responder
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
    
    //move view back down the height of the keyboard when descriptionTextField is the first responder
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
    //override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    //{
//        if segue.destination is CustomLocInfoViewController
//        {
//            let vc = segue.destination as? SubmitCustomLocViewController
//
//            vc?.name = nameTextField.text
//            vc?.longitude = name
//        }
        //print("prepare")
    //}
    
    
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
        
//        let ref = Database.database().reference(fromURL: "https://mapattraction.firebaseio.com/")
//        ref.child("locations").child(nameTextField.text!).updateChildValues(["tag": selectedTags, "x": latitude,"y": longitude, "description": descriptionTextField.text!])
        
        let ref = Database.database().reference(fromURL: "https://mapattraction.firebaseio.com/")
        let id = String(Int(NSDate.timeIntervalSinceReferenceDate*1000))
        
        ref.child("locations").child(nameTextField.text!).updateChildValues(["xid": id,"tag": selectedTags, "x": latitude,"y": longitude, "description": descriptionTextField.text!,"rating": selectedRating])
        return true
    }
    
    //check if the user input is valid before performing the segue
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {

        if identifier == "submitSegue" {
            if nameTextField.text!.isEmpty || descriptionTextField.text!.isEmpty || selectedTags.isEmpty || selectedRating == 0 {
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
