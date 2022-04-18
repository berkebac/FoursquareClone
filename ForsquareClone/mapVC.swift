//
//  mapVC.swift
//  ForsquareClone
//
//  Created by Berke Baç on 17.04.2022.
//

import UIKit
import MapKit
import Firebase

class mapVC: UIViewController, MKMapViewDelegate,CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager = CLLocationManager()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(title: "Save", style: UIBarButtonItem.Style.plain, target: self, action: #selector(saveButtonClicked))
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(cancelButtonClicked))
        
        
        
        
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        
        let recognizer = UILongPressGestureRecognizer(target: self, action: #selector(chooseLocation(gestureRecognizer:)))
        recognizer.minimumPressDuration = 3
        mapView.addGestureRecognizer(recognizer)
        
    }
    
    @objc func chooseLocation(gestureRecognizer : UIGestureRecognizer){
        if gestureRecognizer.state == UIGestureRecognizer.State.began {
            let touches = gestureRecognizer.location(in: self.mapView)
            let coordinates = self.mapView.convert(touches, toCoordinateFrom: self.mapView)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinates
            annotation.title = PlaceModel.sharedInstance.placeName
            annotation.subtitle = PlaceModel.sharedInstance.placeType
            
            self.mapView.addAnnotation(annotation)
            
            PlaceModel.sharedInstance.placeLatitude  = String(coordinates.latitude)
            PlaceModel.sharedInstance.placeLongitude  = String(coordinates.longitude)
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locations = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: locations, span: span)
        mapView.setRegion(region, animated: true)
        
    }
    
    func MakeAlert (tittleInput : String, messageInput : String){
        let alert = UIAlertController(title: tittleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @objc func saveButtonClicked() {
        //save
        let storage = Storage.storage()
        let storageRef = storage.reference()
        
        let mediaFolder = storageRef.child("media")
        
        if let data = PlaceModel.sharedInstance.placeImage.jpegData(compressionQuality: 0.5){
            let uuid = UUID().uuidString
            
            let imageReference = mediaFolder.child("\(uuid).jpeg")
            imageReference.putData(data, metadata: nil) { metadata, error in
                if error != nil {
                    self.MakeAlert(tittleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                }else {
                    imageReference.downloadURL { url, error in
                        let imageurl = url?.absoluteString
                        print(imageurl)
                        //Database
                        
                        let fireStoreDatabase = Firestore.firestore()
                        var fireStoreReferance : DocumentReference? = nil
                        
                        let fireStorePlace = ["imageUrl" : imageurl!,
                                              "name" : PlaceModel.sharedInstance.placeName,
                                              "type" : PlaceModel.sharedInstance.placeType,
                                              "atmosphere" : PlaceModel.sharedInstance.PlaceAtmosphere,
                                              "latitude" : PlaceModel.sharedInstance.placeLatitude,
                                              "longitude" : PlaceModel.sharedInstance.placeLongitude
                        ]
                        
                        fireStoreReferance = fireStoreDatabase.collection("Places").addDocument(data: fireStorePlace, completion: { error in
                            if error != nil {
                                self.MakeAlert(tittleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                            }else {
                                
                                self.performSegue(withIdentifier: "mapViewVCtoPlacesVC", sender: nil)
                            }
                        })
                        
                        
                    }
                }
            }
            
        }
        
        
    }
    @objc func cancelButtonClicked() {
        //cancel
        self.dismiss(animated: true)
        performSegue(withIdentifier: "toPlacesVC", sender: nil)
        
        
    }

}
