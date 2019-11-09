//
//  UserPinViewController.swift
//  MapAttraction
//
//  Created by Yijie Yan on 11/2/19.
//  Copyright © 2019 yuqiao liang. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Firebase

class UserPinViewController: UIViewController,UISearchBarDelegate {
    
    var coordinates:[(Double,Double)] = []
    var passedFilterTags:[String] = []
    var passedFilterDistance:Int = 0
    var passedFilterRating:Int = 1
    
    @IBOutlet weak var myMap: MKMapView!
    let locationManager = CLLocationManager()
    

    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBAction func cancel(_ unwindSegue: UIStoryboardSegue) {
        // Use data from the view controller which initiated the unwind segue
    }
    
    @IBAction func unwindFromFilterVC(_ sender: UIStoryboardSegue){
        if sender.source is FilterViewController{
            if let senderVC = sender.source as? FilterViewController{
                passedFilterTags = senderVC.filterTags
                passedFilterDistance = senderVC.filterDistance
                passedFilterRating = senderVC.filterRating
                print("\(passedFilterTags) \(passedFilterDistance) \(passedFilterRating)")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pinLocation(a: 36.001678, b: -78.939767)
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)

        searchBar.showsScopeBar = true
        searchBar.delegate = self
        saveToDB(name: "Jamba juice", tag: ["Restaurant", "water bar"], x: 111, y: 222, description: "Juicy juice", rating: 3)

        // Do any additional setup after loading the view.
    }
    

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        getData(name: searchBar.text! )
       // print("searchText \(searchBar.text)")
    }

    
    
    
    
    func saveToDB (name: String, tag: [String], x: Double, y: Double, description: String, rating: Int){
        let ref = Database.database().reference(fromURL: "https://mapattraction.firebaseio.com/")
        ref.child("locations").child(name).updateChildValues(["tag": tag, "x": x,"y": y, "description": description,"rating": rating])
    }
    
    func getData(name :String){
         let ref = Database.database().reference(fromURL: "https://mapattraction.firebaseio.com/")
    ref.child("locations").child(name).observeSingleEvent(of: .value, with: { (snapshot) in
    
        for child in snapshot.children{
            let snap = child as! DataSnapshot
            let key = snap.key
            let value = snap.value!
            if (key == "tag"){
                print(value);
            }
//            print(key," : ",value)
        }
    }) { (error) in
      print(error.localizedDescription)
    }
    }
    
    func pinLocation(a: Double , b: Double){
        let chapelCoords = CLLocationCoordinate2DMake(a, b)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1 )
        let region = MKCoordinateRegion(center: chapelCoords, span: span)
        myMap.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = chapelCoords
        annotation.title = "Your Place"
        annotation.subtitle = "Pin your place"
        myMap.addAnnotation(annotation)
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations:[CLLocation]){
        if let userLocation = locations.first{
            print("latitude = \(userLocation.coordinate.latitude)")
            print("latitude = \(userLocation.coordinate.longitude)")
            
        }
        
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
