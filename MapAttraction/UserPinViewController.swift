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

class UserPinViewController: UIViewController,UISearchBarDelegate, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var coordinates:[(Double,Double)] = []
    
    //variables passed from the filterViewController
    var passedFilterTags:[String] = []
    var passedFilterDistance:Int = 0
    var passedFilterRating:Int = 1
    
    let annotationLocations = [
        ["title": "location 1", "latitude": 37.33627815, "longitude": -122.03096498],
        ["title": "location 2", "latitude": 37.33198570, "longitude": -122.02952778]
    ]
    
    var lastLat:Double = 0
    var lastLong:Double = 0
    
    
    
    @IBOutlet weak var myMap: MKMapView!
    let locationManager = CLLocationManager()
    

    @IBOutlet weak var searchBar: UISearchBar!
    
    //destination of the unwind segue linked to the cancel button on the filterViewController
    @IBAction func cancel(_ unwindSegue: UIStoryboardSegue) {
        // Use data from the view controller which initiated the unwind segue
    }
    
    //destination of the unwind segue linked to the Apply button on the filterViewController
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
        myMap.delegate = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        // after showing the permission dialog, the program will continue executing the next line before the user has tap 'Allow' or 'Disallow'
        
        // if previously user has allowed the location permission, then request location
        if(CLLocationManager.authorizationStatus() == .authorizedWhenInUse || CLLocationManager.authorizationStatus() == .authorizedAlways){
            locationManager.requestLocation()
        }
        
        pinLocations(locations: annotationLocations)
        
        //the following code snippet is used to enable touching anywhere on the screen to dismiss keyboard
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
    }

    
    //update db
    func saveToDB (name: String, tag: [String], x: Double, y: Double, description: String, rating: Int){
        let ref = Database.database().reference(fromURL: "https://mapattraction.firebaseio.com/")
        ref.child("locations").child(name).updateChildValues(["tag": tag, "x": x,"y": y, "description": description,"rating": rating])
    }
    
    //called after the search button on keyboard is pressed
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
            }
        })
        { (error) in
            print(error.localizedDescription)
        }
    }
    
    //pin annotations to the map
    func pinLocations(locations:[[String:Any]]){
        
        for location in locations{
            let coord = CLLocationCoordinate2DMake(location["latitude"] as! CLLocationDegrees, location["longitude"] as! CLLocationDegrees)
            let annotation = MKPointAnnotation()
            annotation.coordinate = coord
            annotation.title = location["title"] as? String
            //annotation.subtitle = "Pin your place"
            myMap.addAnnotation(annotation)
            
        }
        
        
        
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations:[CLLocation]){
        if let userLocation = locations.last{
            self.lastLat = userLocation.coordinate.latitude
            self.lastLong = userLocation.coordinate.longitude
        
            let currCoords = CLLocationCoordinate2D(latitude: lastLat, longitude: lastLong)
            let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            let region = MKCoordinateRegion(center: currCoords, span: span)
            myMap.setRegion(region, animated: true)
        
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // might be that user didn't enable location service on the device
        // or there might be no GPS signal inside a building
      
        // might be a good idea to show an alert to user to ask them to walk to a place with GPS signal
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
