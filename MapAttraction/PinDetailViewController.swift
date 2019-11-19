//
//  PinDetailViewController.swift
//  MapAttraction
//
//  Created by codeplus on 11/11/19.
//  Copyright © 2019 yuqiao liang. All rights reserved.
//

import UIKit
import CoreLocation
import Firebase

class PinDetailViewController: UIViewController {
    //passed from UserPinViewController
    var xid:String = ""
    var imageUrl:String = ""
    
    @IBOutlet weak var pinImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UITextView!
    @IBOutlet weak var tagsLabel: UILabel!
    
    
    
    
    
    
    
    func getDetailsFromDB(xid : String){
        let ref = Database.database().reference(fromURL: "https://mapattraction.firebaseio.com/")
        ref.child("locations").observeSingleEvent(of: .value, with: { (snapshot) in
            for child in snapshot.children{
                let snap = child as! DataSnapshot
                let key = snap.key
                let value = snap.value!
                let info = value as! NSDictionary
                let id :String  = info["xid"] as! String
                let tags : [String] = info["tag"] as! [String]
                let description : String = info["description"] as! String
                let rating : Int = info["rating"] as! Int
                let x :Double = Double(info["x"] as! Double)
                let y :Double = Double(info["y"] as! Double)
                if (id == xid){
                    print("name ", key, "tag ", tags, "des ", description, "rate ", rating)
                    self.nameLabel.text = key
                    var tagstring = ""
                    for tag in tags{
                        tagstring.append(tag)
                        tagstring.append(", ")
                    }
                    self.tagsLabel.text = String(tagstring.replacingOccurrences(of: "_", with: " ").dropLast().dropLast())
                    self.addressLabel.text = "(\(x), \(y))"
                    self.ratingLabel.text = "\(rating) Star(s)"
                    self.descriptionLabel.text = description
                }
            }
        })
        { (error) in
            print(error.localizedDescription)
        }
    }
    func getDetailsFromAPI (xid : String){
        let headers = [
            "x-rapidapi-host": "opentripmap-places-v1.p.rapidapi.com",
            "x-rapidapi-key": "8af0d82f43msh34e53305797a0cbp197d01jsnac77d9f76adc"
        ]
        let request = NSMutableURLRequest(url: NSURL(string: "https://opentripmap-places-v1.p.rapidapi.com/en/places/xid/" + xid)! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error ?? "error")
            } else {
                do {
                  let json: NSDictionary = try JSONSerialization.jsonObject(with: data!, options: []) as! NSDictionary
                    print("name: ", json["name"]!)
                    
                    OperationQueue.main.addOperation {
                        //update name label
                        self.nameLabel.text = (json["name"] as! String)
                        //update address label
                        if let address : NSDictionary = json["address"] as? NSDictionary {
                            print("address ", address["house_number"],address["road"],address["city"],address["state"],address["country"])
                            let addrstring = "\(address["house_number"] ?? "") \(address["road"] ?? ""), \(address["city"] ?? "") \(address["state"] ?? ""), \(address["country"] ?? "")"
                            self.addressLabel.text = addrstring
                        }
                        //update tags label
                        print("kinds ", json["kinds"]!)
                        if let tags: String = json["kinds"] as? String{
                            self.tagsLabel.text = tags.replacingOccurrences(of: ",", with: ", ").replacingOccurrences(of: "_", with: " ")
                        }
                        //update description textview
                        if let wiki : NSDictionary = json["wikipedia_extracts"] as? NSDictionary {
                            print("description ", wiki["text"] ?? "")
                            self.descriptionLabel.text = (wiki["text"] as! String)
                        }else{
                            self.descriptionLabel.text = "No available descriptions."
                        }
                        //update rating label
                        print("rate ", json["rate"] ?? "0")
                        if let rate: String = json["rate"] as? String{
                            if rate == "0"{
                                self.ratingLabel.text = "No available ratings"
                            }else{
                                self.ratingLabel.text = "\(rate) Star(s)"
                            }
                        }
                    }

                    if let preview: NSDictionary = json["preview"] as? NSDictionary{
                        let url = URL(string: preview["source"] as! String)!
                        self.pinImage.load(url: url)
                    }
                   
               } catch {
                   print("JSON error: \(error.localizedDescription)")
               }
            }
        })
        dataTask.resume()
    }
    
    func isNumeric(a: String) -> Bool {
      return Double(a) != nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("passed xid: \(xid)")
        
        if (isNumeric(a: xid)){
            getDetailsFromDB(xid: xid)
        }
        else{
            getDetailsFromAPI(xid: xid)
        }
        
        self.pinImage.contentMode = .scaleAspectFit
        //self.pinImage.image = UIImage(named: "poke house")
        
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

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
