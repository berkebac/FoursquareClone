//
//  DetailsVC.swift
//  ForsquareClone
//
//  Created by Berke Baç on 17.04.2022.
//

import UIKit
import MapKit
import Firebase
import SDWebImage

class DetailsVC: UIViewController, MKMapViewDelegate{

    @IBOutlet weak var detailsImageView: UIImageView!
    @IBOutlet weak var detailsPlaceName: UILabel!
    @IBOutlet weak var detailsPlaceType: UILabel!
    @IBOutlet weak var detailsPlaceAtmosphere: UILabel!
    @IBOutlet weak var detailsMapView: MKMapView!
    
    var chosenPlaceId = ""
    var chosenLatitude = Double()
    var chosenLongitude = Double()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDataFromFirebase()
        detailsMapView.delegate = self
    }
    
    func getDataFromFirebase() {
        let fireStoreDataBase = Firestore.firestore()
        
        fireStoreDataBase.collection("Places").addSnapshotListener { snapshot, error in
            if error != nil {
                print(error?.localizedDescription ?? "Error")
            }else {
                if snapshot?.isEmpty != true {
                    for document in snapshot!.documents {
                            let placeID = document.documentID
                            if self.chosenPlaceId == placeID {
                                
                                //Take objects
                                if let placeName = document.get("name") as? String{
                                    self.detailsPlaceName.text = placeName
                                }
                                if let placeType = document.get("type") as? String{
                                    self.detailsPlaceType.text = placeType
                                }
                                
                                self.detailsPlaceAtmosphere.text = document.get("atmosphere") as? String
                                
                                if let placeLatitude = document.get("latitude") as? String {
                                    if let placeLongitude = document.get("longitude") as? String{
                                        if let placeLatitudeDouble = Double(placeLatitude) {
                                            if let placeLongitudeDouble = Double(placeLongitude){
                                                self.chosenLatitude = placeLatitudeDouble
                                                self.chosenLongitude = placeLongitudeDouble
                                            }
                                        }
                                    }
                                }
                                
                                if let imageData = document.get("imageUrl") as? String{
                                    self.detailsImageView.sd_setImage(with: URL(string: imageData))
                                    
                                }
                                
                                //MAP
                                
                                let location = CLLocationCoordinate2D(latitude: self.chosenLatitude, longitude: self.chosenLongitude)
                                
                                let span = MKCoordinateSpan(latitudeDelta: 0.035, longitudeDelta: 0.035)
                                
                                let region = MKCoordinateRegion(center: location, span: span)
                                self.detailsMapView.setRegion(region, animated: true)
                                
                                let annotation = MKPointAnnotation()
                                annotation.coordinate = location
                                annotation.title = self.detailsPlaceName.text!
                                annotation.subtitle = self.detailsPlaceType.text!
                                
                                self.detailsMapView.addAnnotation(annotation)
                                
                                
                            }
                        }
                       
                    }
                      
                }
            }
            
        }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            if annotation is MKUserLocation {
                return nil
            }
            
            let reuseId = "pin"
            
            var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
            
            if pinView == nil {
                pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                pinView?.canShowCallout = true
                let button = UIButton(type: .detailDisclosure)
                pinView?.rightCalloutAccessoryView = button
            } else {
                pinView?.annotation = annotation
            }
            
            return pinView
            
        }
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if self.chosenLatitude != 0.0 && self.chosenLongitude != 0.0 {
            let requestLocation = CLLocation(latitude: self.chosenLatitude, longitude: self.chosenLongitude)
            
            CLGeocoder().reverseGeocodeLocation(requestLocation) { placemarks, error in
                if let placemark = placemarks {
                    if placemark.count > 0 {
                        let mkPlaceMark = MKPlacemark(placemark: placemark[0])
                        let mapItem = MKMapItem(placemark: mkPlaceMark)
                        mapItem.name = self.detailsPlaceName.text
                        
                        let launcOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
                        mapItem.openInMaps(launchOptions: launcOptions)
                        
                        
                        
                        
                    }
                }
            }
        }
    }
    
}


    


