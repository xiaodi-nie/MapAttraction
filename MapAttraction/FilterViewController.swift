//
//  FilterViewController.swift
//  MapAttraction
//
//  Created by codeplus on 11/8/19.
//  Copyright © 2019 yuqiao liang. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tagFilterTableView: UITableView!
    @IBOutlet weak var distanceFilterTableView: UITableView!
    @IBOutlet weak var ratingFilterTableView: UITableView!
    
    let tags:[String] = ["Interesting places", "Accomodations", "Adult", "Amusements", "Architecture","Cultual", "Historical", "Industrial facilities", "Natural", "Other", "Religion", "Sport", "Tourist facilities", "Foods", "Shops", "Transport"]
    let ratings:[String] = [">= 1 Star", ">= 2 Stars", ">= 3 Stars"]
    let distances: [String] = ["< 500m", "< 1km", "< 3km", "< 5km"]
    let distancesNum: [Int] = [500, 1000, 3000, 5000]
    
    var filterTags:[String] = []
    var filterDistance: Int = 0
    var filterRating: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tableView == self.tagFilterTableView){
            return tags.count
            
        }
        if(tableView == self.distanceFilterTableView){
            return distances.count
        }
        else{
            return ratings.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(tableView == self.tagFilterTableView){
            let myTagCell = tableView.dequeueReusableCell(withIdentifier: "tagFilterCell", for: indexPath) as! tagFilterTableViewCell
            myTagCell.tagLabel.text = tags[indexPath.row]
            return myTagCell
            
        }
        else if(tableView == self.distanceFilterTableView){
            let myDistanceCell = tableView.dequeueReusableCell(withIdentifier: "distanceFilterCell", for: indexPath) as! distanceFilterTableViewCell
            myDistanceCell.distanceLabel.text = distances[indexPath.row]
            return myDistanceCell
            
        }
        else{
            let myRatingCell = tableView.dequeueReusableCell(withIdentifier: "ratingFilterCell", for: indexPath) as! ratingFilterTableViewCell
            myRatingCell.ratingLabel.text = ratings[indexPath.row]
            return myRatingCell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(tableView == self.tagFilterTableView){
            //print("selected one row")
            let convertedTag = tags[indexPath.row].lowercased().replacingOccurrences(of: " ", with: "_")
            filterTags.append(convertedTag)
                
            
        }
        if(tableView == self.distanceFilterTableView){
            filterDistance = distancesNum[indexPath.row]
        }
        if(tableView == self.ratingFilterTableView){
            filterRating = indexPath.row + 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        print("deselect")
        let convertedTag = tags[indexPath.row].lowercased().replacingOccurrences(of: " ", with: "_")
        filterTags.removeAll { $0 == convertedTag }
        print(filterTags)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation*/
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//        print("filter prepare function")
//        print("filter tags: \(filterTags)")
//        print("filter distance: \(filterDistance)")
//        print("filter rating: \(filterRating)")
//        
//    }
    

}
