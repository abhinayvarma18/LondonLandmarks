//
//  LandMarkDescriptionViewController.swift
//  LondonDreams
//
//  Created by Abhinay Varma on 10/14/17.
//  Copyright © 2017 Abhinay Varma. All rights reserved.
//

import UIKit
import MapKit
import AlamofireImage

class LandMarkDescriptionViewController: UIViewController {

    @IBOutlet weak var landmarkImage: UIImageView!
    @IBOutlet weak var landmarkName: UILabel!
    @IBOutlet weak var landmarkAddress: UILabel!
    @IBOutlet weak var landmarkDescription: UITextView!
    @IBOutlet weak var mapview: MKMapView!
    var model:LandMark!
    
    let directionViewControllerName = "GetDirectionsViewController"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateUi()
    }
    
    func openMap(coordinate:CLLocationCoordinate2D) {
        let storyboard = UIStoryboard(name: FirstScreenViewController.mainStoryboardName, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: directionViewControllerName) as! GetDirectionsViewController
        vc.navigationController?.navigationBar.isHidden = true
        vc.model = model
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func updateUi() {
        let noLocation = CLLocationCoordinate2D(latitude: Double(model.latitude)!, longitude: Double(model.longitude)!)
        let viewRegion = MKCoordinateRegionMakeWithDistance(noLocation, 100, 100)
        self.mapview.setRegion(viewRegion, animated: false)
        landmarkImage.af_setImage(withURL: URL(string:model.image)!)
        landmarkName.text = model.title
        landmarkAddress.text = model.address
        landmarkDescription.text = model.descriptionText
        self.navigationController?.navigationBar.topItem?.title = ""
        
        let CLLCoordType = CLLocationCoordinate2D(latitude: Double(model.latitude)!,
                                                  longitude: Double(model.longitude)!)
        let anno = MKPointAnnotation();
        anno.coordinate = CLLCoordType;
        mapview.addAnnotation(anno);
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        landmarkDescription.setContentOffset(CGPoint.zero, animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func directionClicked(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.openMap(coordinate: appDelegate.coordinate)
    }
}
