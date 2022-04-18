//
//  addViewController.swift
//  ForsquareClone
//
//  Created by Berke Baç on 16.04.2022.
//

import UIKit

class addPlaceVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var placeNameText: UITextField!
    
    @IBOutlet weak var placeTypeText: UITextField!
    
    @IBOutlet weak var placeAtmosphereText: UITextField!
    
    @IBOutlet weak var ImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        ImageView.isUserInteractionEnabled = true
        let imageTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectImage))
        ImageView.addGestureRecognizer(imageTapRecognizer)
        
    }
    
    @objc func selectImage() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        ImageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true)
    }
    
    @IBAction func nextButtonClicked(_ sender: Any) {
        if placeNameText.text != "" && placeTypeText.text != "" && placeAtmosphereText.text != "" {
            if let chosenImage = ImageView.image {
                let placeModel = PlaceModel.sharedInstance
                placeModel.PlaceAtmosphere = placeAtmosphereText.text!
                placeModel.placeName = placeNameText.text!
                placeModel.placeType = placeTypeText.text!
                placeModel.placeImage = chosenImage
                
                performSegue(withIdentifier: "toMapVC", sender: nil)
            }
            
        }else {
            let alert = UIAlertController(title: "Error", message: "Place Name/Type/Atmosphere ?", preferredStyle: UIAlertController.Style.alert)
            let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
            
            alert.addAction(okButton)
            present(alert, animated: true, completion: nil)
            
        }
        
    }
    

}
