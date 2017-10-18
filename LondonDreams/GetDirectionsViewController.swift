//
//  GetDirectionsViewController.swift
//  LondonDreams
//
//  Created by Abhinay Varma on 10/18/17.
//  Copyright © 2017 Abhinay Varma. All rights reserved.
//

import UIKit
import AlamofireImage
import GooglePlaces


class GetDirectionsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {
    var arrPlaces = NSMutableArray(capacity: 100)
    
    @IBOutlet weak var searchresulttableview: UITableView!
    @IBOutlet weak var searchBarFromLocation: UISearchBar!
    
    @IBOutlet weak var tolocationtextfield: UITextField!
    @IBOutlet weak var noplacesfoundlabel: UILabel!
    var nameOfLocation:String = ""
    var model:LandMark!
    
    //hardcodedStrings
    let googleapikeyString = "AIzaSyDBW-fWqBRYwoLRYU3-i-1ko5AkUqLgxlQ"
    let googleTableViewCellString = "GoogleMapSuggestionTableViewCell"
    let googleCellIdentifier = "locationCell"
    let termsString = "terms"
    let valueString = "value"
    let placeIdString = "place_id"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameOfLocation = model.title
       let appDelegate = UIApplication.shared.delegate as! AppDelegate
        tolocationtextfield.text = String(appDelegate.coordinate.latitude) + "," + String(appDelegate.coordinate.longitude)
        searchBarFromLocation.text = nameOfLocation
        self.beginSearching(searchText: nameOfLocation)
        searchBarFromLocation.delegate = self
        searchresulttableview.register(UINib.init(nibName: googleTableViewCellString, bundle: nil), forCellReuseIdentifier: googleCellIdentifier)
        GMSPlacesClient.provideAPIKey(googleapikeyString)
        self.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.beginSearching(searchText: searchBar.text!)
    }
    
    func beginSearching(searchText:String) {
        if searchText.characters.count == 0 {
            self.arrPlaces.removeAllObjects()
            searchresulttableview.isHidden = true
            noplacesfoundlabel.isHidden = false
            return
        }
        
        let queue = DispatchQueue(label: "l1")
        queue.async {
            self.forwardGeoCoding(searchText: searchText)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrPlaces.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tblCell = tableView.dequeueReusableCell(withIdentifier: googleCellIdentifier) as! GoogleMapSuggestionTableViewCell
        let dict = arrPlaces.object(at: indexPath.row) as! NSDictionary
        let addressDict = dict.value(forKey: termsString) as! Array<Any>
        let onemoredict = addressDict[0] as! NSDictionary
        let twoMoreDict = addressDict[1] as! NSDictionary
        tblCell.titlePlace.text = onemoredict[valueString] as? String
        tblCell.locationPlace.text = twoMoreDict[valueString] as? String
        GMSPlacesClient.shared().lookUpPhotos(forPlaceID: (dict.value(forKey: placeIdString) as? String)!, callback: { (photos, error) -> Void in
            if let error = error {
                // TODO: handle the error.
                print("Error: \(error.localizedDescription)")
            } else {
                if let firstPhoto = photos?.results.first {
                    GMSPlacesClient.shared().loadPlacePhoto(firstPhoto, callback: {
                        (photo, error) -> Void in
                        if let error = error {
                            // TODO: handle the error.
                            print("Error: \(error.localizedDescription)")
                        } else {
                            tblCell.imagetodisplay.image = photo
                        }
                    })
                }
            }
        })
        return tblCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func forwardGeoCoding(searchText:String) {
        googlePlacesResult(input: searchText) { (result) -> Void in
            let searchResult:NSDictionary = ["keyword":searchText,"results":result]
            if result.count > 0
            {
                let features = searchResult.value(forKey: "results") as! NSArray
                self.arrPlaces = NSMutableArray(capacity: 100)
                print(features.count)
                for jk in 0...features.count-1
                {
                    let dict = features.object(at: jk) as! NSDictionary
                    self.arrPlaces.add(dict)
                }
                DispatchQueue.main.async(execute: {
                    if self.arrPlaces.count != 0
                    {
                        self.searchresulttableview.isHidden = false
                        self.noplacesfoundlabel.isHidden = true
                        self.searchresulttableview.reloadData()
                    }
                    else
                    {
                        self.searchresulttableview.isHidden = true
                        self.noplacesfoundlabel.isHidden = false
                        self.searchresulttableview.reloadData()
                    }
                });
            }
        }
    }
    
    //MARK: - Google place API request -
    func googlePlacesResult(input: String, completion: @escaping (_ result: NSArray) -> Void) {
        let searchWordProtection = input.replacingOccurrences(of: " ", with: "");        if searchWordProtection.characters.count != 0 {
            let urlString = NSString(format: "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=%@&types=establishment|geocode&location=%@,%@&radius=500&language=en&key= AIzaSyAPn9OIJ59_P1Axhk0rD9e_uzE9FYrlJn8",input,nameOfLocation)
            let url = NSURL(string: urlString.addingPercentEscapes(using: String.Encoding.utf8.rawValue)!)
            print(url!)
            let defaultConfigObject = URLSessionConfiguration.default
            let delegateFreeSession = URLSession(configuration: defaultConfigObject, delegate: nil, delegateQueue: OperationQueue.main)
            let request = NSURLRequest(url: url! as URL)
            let task =  delegateFreeSession.dataTask(with: request as URLRequest, completionHandler:
                {
                    (data, response, error) -> Void in
                    if let data = data
                    {
                        do {
                            let jSONresult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! [String:AnyObject]
                            let results:NSArray = jSONresult["predictions"] as! NSArray
                            let status = jSONresult["status"] as! String
                            if status == "NOT_FOUND" || status == "REQUEST_DENIED"
                            {
                                let userInfo:NSDictionary = ["error": jSONresult["status"]!]
                                let newError = NSError(domain: "API Error", code: 666, userInfo: userInfo as [NSObject : AnyObject])
                                let arr:NSArray = [newError]
                                completion(arr)
                                return
                            }
                            else
                            {
                                completion(results)
                            }
                        }
                        catch
                        {
                            print("json error: \(error)")
                        }
                    }
                    else if let error = error
                    {
                        print(error)
                    }
            })
            task.resume()
        }
    }
    @IBAction func routeClicked(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let url = "http://maps.apple.com/maps/?saddr=,,\(model.title.replacingOccurrences(of:" ", with:"%20"))+&daddr=\(appDelegate.coordinate.latitude),\(appDelegate.coordinate.longitude)"
        UIApplication.shared.open(URL(string:url)!, options: [:], completionHandler: {(Bool) in
        })
    }
    
    @IBAction func cancelClicked(_ sender: Any) {
       _ =  self.navigationController?.popViewController(animated: true)
    }
    
    
}
