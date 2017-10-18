//
//  UploadLandmarkDataViewController.swift
//  LondonDreams
//
//  Created by Abhinay Varma on 10/12/17.
//  Copyright © 2017 Abhinay Varma. All rights reserved.
//

import UIKit
import Toast_Swift


class UploadLandmarkDataViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var landmarkTextField: UITextField!
    @IBOutlet weak var uploadedImageView: UIImageView!
    
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var coordinateTextField: UITextField!
    @IBOutlet weak var addressText: UITextField!
    var imageData:Data?
    
    var landmarkImagePicker: UIImagePickerController = UIImagePickerController()
    
    //hardcoded strings
    let controllerTitle = "Upload New Landmark"
    let imageUploadMessage = "Choose your source"
    let cameraAction = "Camera"
    let noCameraString = "No Camera"
    let photoLibraryString = "Photo library"
    let locationErrorMessage = "please enter lat long with format lat,long"
    let landmarkErrorMessage = "please enter valid landmark name"
    let imageErrorMessage = "please enter valid image"
    let descriptionErrorMessage = "Please enter valid description"
    let addressErrorMessage = "please enter valid address"
    let successLandmarkPostedMessage = "Landmark Added Successfully"
    let defaultUploadImageName = "unnamed"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.topItem?.title = ""
        self.title = controllerTitle
        landmarkImagePicker.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func uploadImageClicked(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: imageUploadMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: cameraAction, style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.landmarkImagePicker.allowsEditing = true
                self.landmarkImagePicker.setEditing(true, animated: true)
                self.landmarkImagePicker.sourceType = UIImagePickerControllerSourceType.camera
                self.landmarkImagePicker.cameraCaptureMode = .photo
                
                self.present(self.landmarkImagePicker,animated: true,completion: nil)
            }else {
                self.parent?.view.makeToast(self.noCameraString, duration: 3.0, position: CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height - 100) )
                
            }
        })
        alert.addAction(UIAlertAction(title: photoLibraryString, style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
            self.landmarkImagePicker.allowsEditing = true
            self.landmarkImagePicker.sourceType = .photoLibrary
            self.landmarkImagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
            
            self.present(self.landmarkImagePicker, animated: true, completion: nil)
        })
        self.present(alert, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //when image is picked
        var  chosenImage = UIImage()
        chosenImage = info[UIImagePickerControllerEditedImage] as! UIImage //2
        
        self.imageData = UIImageJPEGRepresentation(chosenImage, 0.8)
        uploadedImageView.image = chosenImage
        self.dismiss(animated:true, completion: nil)
    }
    
    @IBAction func addNodeInFirebase(_ sender: Any) {
        
        let manager = NetworkManager.shared
        
        if(!(coordinateTextField.text?.contains(","))!) {
            view.makeToast(locationErrorMessage)
        }else if(landmarkTextField.text?.isEmpty)!{
            view.makeToast(landmarkErrorMessage)
        }else if(imageData?.isEmpty)!{
             view.makeToast(imageErrorMessage)
        }else if(descriptionText.text.isEmpty) {
            view.makeToast(descriptionErrorMessage)
        }else if(addressText.text?.isEmpty)! {
            view.makeToast(addressErrorMessage)
        }else{
            manager.postLandmark(title: landmarkTextField.text!,coordinates: coordinateTextField.text!,imageData: imageData!,address:addressText.text!,descriptionText:descriptionText.text)
            view.makeToast(successLandmarkPostedMessage)
            self.imageData = Data()
            landmarkTextField.text = ""
            descriptionText.text = ""
            addressText.text = ""
            coordinateTextField.text = ""
            uploadedImageView.image = UIImage(named: defaultUploadImageName)
        }
    }

    @IBAction func chooseLocation(_ sender: Any) {
        
        
    }
}
