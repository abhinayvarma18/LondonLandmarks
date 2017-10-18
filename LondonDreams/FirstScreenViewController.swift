//
//  ViewController.swift
//  LondonDreams
//
//  Created by Abhinay Varma on 10/11/17.
//  Copyright © 2017 Abhinay Varma. All rights reserved.
//

import UIKit
import MapKit

class FirstScreenViewController: UIViewController {
    
    
    //hardcoded strings
    static let titleChoose = "Choose an option!"
    static let mainStoryboardName = "Main"
    let secondVcName = "SecondScreenViewController"
    let locateVcName = "LocateMeViewController"
    let uploadVcName = "UploadLandmarkDataViewController"
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0.258, green: 0.4431, blue: 0.6157, alpha: 1.0)
        
        self.navigationController?.navigationBar.tintColor = .white
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = FirstScreenViewController.titleChoose
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func showPlaces(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: FirstScreenViewController.mainStoryboardName, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: secondVcName) as! SecondScreenViewController
        vc.navigationItem.leftBarButtonItem?.title = ""
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
    @IBAction func locateMeClicked(_ sender: Any) {
        let storyboard = UIStoryboard(name: FirstScreenViewController.mainStoryboardName, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: locateVcName) as! LocateMeViewController
        vc.navigationController?.navigationBar.isHidden = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func uploadLandmarkClicked(_ sender: Any) {
        let storyboard = UIStoryboard(name: FirstScreenViewController.mainStoryboardName, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: uploadVcName) as! UploadLandmarkDataViewController
        vc.navigationItem.leftBarButtonItem?.title = ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

