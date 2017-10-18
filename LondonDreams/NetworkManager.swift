//
//  NetworkManager.swift
//  LondonDreams
//
//  Created by Abhinay Varma on 10/12/17.
//  Copyright © 2017 Abhinay Varma. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class NetworkManager: NSObject {
    static let shared = NetworkManager()
    
    func uploadLandmark(model:LandMark) {
        
        
    }
    
    func postLandmark(title:String, coordinates:String, imageData:Data, address:String, descriptionText:String) {
        let filePath = title.replacingOccurrences(of: " ", with: "")
        let metaData = StorageMetadata()
        metaData.contentType = "jpg"
        let storageRef = Storage.storage().reference()
        storageRef.child(filePath).putData(imageData, metadata: metaData){(metaData,error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }else{
                //store downloadURL
                let downloadURL = metaData!.downloadURL()!.absoluteString
                let ref = Database.database().reference()
                let object = ["title":title,"coordinates":coordinates,"image_url":downloadURL,"address":address,"descriptionText":descriptionText]
                ref.child("landmarks").childByAutoId().updateChildValues(object)
            }
        }
    
    }
    
    func getLandMarks(reloadUI : @escaping(_ val:[LandMark])->()) {
         let ref = Database.database().reference()
        ref.child("landmarks").observeSingleEvent(of: .value, with: {(snapshot) in
            let landmarkArray = snapshot.value as? Dictionary<String,Any> ?? [:]
            
            var modelArray:[LandMark] = []
            for object in landmarkArray {
                let model = LandMark()
                let value = object.value as? Dictionary<String,Any> ?? [:]
                var coordinateArray = (value["coordinates"] as! String).components(separatedBy: ",")
                model.longitude = coordinateArray[1]
                model.latitude = coordinateArray[0]
                model.image = value["image_url"] as! String
                model.title = value["title"] as! String
                model.address = value["address"] as! String
                model.descriptionText = value["descriptionText"] as! String
                modelArray.append(model)
            }
            reloadUI(modelArray)
        })
    
    }
    
    
}
