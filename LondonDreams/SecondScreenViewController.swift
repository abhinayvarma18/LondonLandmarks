//
//  SecondScreenViewController.swift
//  LondonDreams
//
//  Created by Abhinay Varma on 10/11/17.
//  Copyright © 2017 Abhinay Varma. All rights reserved.
//

import UIKit
import AlamofireImage

class SecondScreenViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var landmarkTable: UITableView!
    
    //hardcoded strings
    let identifier = "landmarkCell"
    let landmarknibname = "LandmarkTableViewCell"
    let loaderText = "Loading London Landmarks Data"
    let titleOfController = "London Landmarks"
    let landmarkDescrptionVc = "LandMarkDescriptionViewController"
    var landmarksArray:[LandMark] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        landmarkTable.register(UINib.init(nibName: landmarknibname, bundle: nil), forCellReuseIdentifier:identifier)
        
        EZLoadingActivity.show(text: loaderText, disableUI: true)
        self.fetchDataFromFirebase()
        self.navigationController?.navigationBar.topItem?.title = ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = titleOfController
    }
    
    
    func fetchDataFromFirebase() {
        let networkManager = NetworkManager.shared
        networkManager.getLandMarks(reloadUI: {(landmarks) in
          self.landmarksArray = landmarks
          DispatchQueue.main.async() {
            self.landmarkTable.reloadData()
          }
        })
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return landmarksArray.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! LandmarkTableViewCell
        cell.landmarkTitle.text = landmarksArray[indexPath.row].title
        cell.landmarkAddress.text = landmarksArray[indexPath.row].title
        cell.landmarkImage.af_setImage(withURL: URL(string:landmarksArray[indexPath.row].image)!, placeholderImage: UIImage(named:"default"), filter: nil, progress: nil, progressQueue: DispatchQueue.main, imageTransition: .noTransition, runImageTransitionIfCached: true, completion: {(image) in
            if(indexPath.row == self.landmarksArray.count - 1) {
                EZLoadingActivity.hide()
                
            }
        })
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: FirstScreenViewController.mainStoryboardName, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: landmarkDescrptionVc) as! LandMarkDescriptionViewController
        vc.title = landmarksArray[indexPath.row].title
        vc.model = landmarksArray[indexPath.row]
        vc.navigationItem.leftBarButtonItem?.title = ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
