//
//  LocateMeViewController.swift
//  LondonDreams
//
//  Created by Abhinay Varma on 10/17/17.
//  Copyright © 2017 Abhinay Varma. All rights reserved.
//

import UIKit
import MapKit

class LocateMeViewController: UIViewController {

   
    @IBOutlet weak var locatememapview: MKMapView!
    @IBOutlet weak var standardButton: UIButton!
    @IBOutlet weak var satteliteButton: UIButton!
    @IBOutlet weak var hubridButton: UIButton!
    
    let locateMeTitle = "Locate Me"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadCurrentCoordinates()
        self.layoutButtons()
        self.standardButton.tintColor = UIColor.white

        self.navigationController?.navigationBar.topItem?.title = ""
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let CLLCoordType = CLLocationCoordinate2D(latitude: appDelegate.coordinate.latitude,
                                                  longitude: appDelegate.coordinate.longitude)
        let anno = MKPointAnnotation()
        anno.coordinate = CLLCoordType
        locatememapview.addAnnotation(anno)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.title = locateMeTitle
    }

    func loadCurrentCoordinates() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let noLocation = CLLocationCoordinate2D(latitude: appDelegate.coordinate.latitude, longitude: appDelegate.coordinate.longitude)
        let viewRegion = MKCoordinateRegionMakeWithDistance(noLocation, 100, 100)
        self.locatememapview.setRegion(viewRegion, animated: false)
    }
    
    func layoutButtons() {
        self.standardButton.layer.cornerRadius = 5.0
        self.standardButton.layer.borderColor =  (UIColor.init(colorLiteralRed: 48/256, green: 131/256, blue: 251/256, alpha: 1.0)).cgColor
        self.hubridButton.layer.borderColor = (UIColor.init(colorLiteralRed: 48/256, green: 131/256, blue: 251/256, alpha: 1.0)).cgColor
        self.satteliteButton.layer.borderColor = (UIColor.init(colorLiteralRed: 48/256, green: 131/256, blue: 251/256, alpha: 1.0)).cgColor
        self.hubridButton.layer.cornerRadius = 5.0
        self.satteliteButton.layer.borderWidth = 1.0
        self.hubridButton.layer.borderWidth = 1.0
        self.standardButton.layer.borderWidth = 1.0
        self.satteliteButton.layer.cornerRadius = 1.0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func satelliteClicked(_ sender: Any) {
        locatememapview.mapType = .satellite
        locatememapview.reloadInputViews()
        self.satteliteButton.backgroundColor = UIColor.init(colorLiteralRed: 48/256, green: 131/256, blue: 251/256, alpha: 1.0)
        self.hubridButton.backgroundColor = UIColor.clear
        self.standardButton.backgroundColor = UIColor.clear
        self.hubridButton.tintColor = UIColor.init(colorLiteralRed: 48/256, green: 131/256, blue: 251/256, alpha: 1.0)
        self.standardButton.tintColor = UIColor.init(colorLiteralRed: 48/256, green: 131/256, blue: 251/256, alpha: 1.0)
        self.satteliteButton.tintColor = UIColor.white
    }
    
    @IBAction func maptypeClicked(_ sender: Any) {
        locatememapview.mapType = .standard
         locatememapview.reloadInputViews()
        self.satteliteButton.backgroundColor = UIColor.clear
        self.hubridButton.backgroundColor = UIColor.clear
        self.standardButton.backgroundColor =  UIColor.init(colorLiteralRed: 48/256, green: 131/256, blue: 251/256, alpha: 1.0)
        
        self.hubridButton.tintColor = UIColor.init(colorLiteralRed: 48/256, green: 131/256, blue: 251/256, alpha: 1.0)
        self.standardButton.tintColor = UIColor.white
        self.satteliteButton.tintColor = UIColor.init(colorLiteralRed: 48/256, green: 131/256, blue: 251/256, alpha: 1.0)
        
    }
    @IBAction func hybridClicked(_ sender: Any) {
        locatememapview.mapType = .hybrid
         locatememapview.reloadInputViews()
        self.satteliteButton.backgroundColor = UIColor.clear
        self.hubridButton.backgroundColor =  UIColor.init(colorLiteralRed: 48/256, green: 131/256, blue: 251/256, alpha: 1.0)
        self.hubridButton.tintColor = UIColor.white
        self.standardButton.tintColor = UIColor.init(colorLiteralRed: 48/256, green: 131/256, blue: 251/256, alpha: 1.0)
        self.satteliteButton.tintColor = UIColor.init(colorLiteralRed: 48/256, green: 131/256, blue: 251/256, alpha: 1.0)
        self.standardButton.backgroundColor = UIColor.clear
    }
    
    @IBAction func locatemeClicked(_ sender: Any) {
        self.loadCurrentCoordinates()
    }
    
    @IBAction func directionsClicked(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate

        let url = "http://maps.apple.com/maps/?ll=\(appDelegate.coordinate.latitude),\(appDelegate.coordinate.longitude)"
        UIApplication.shared.open(URL(string:url)!, options: [:], completionHandler: {(Bool) in

        })
    }
}
