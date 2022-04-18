//
//  PlaceModel.swift
//  ForsquareClone
//
//  Created by Berke Baç on 17.04.2022.
//

import Foundation
import UIKit
class PlaceModel {
    
    static let sharedInstance = PlaceModel()
    
    var placeName = ""
    var placeType = ""
    var PlaceAtmosphere = ""
    var placeImage = UIImage()
    var placeLongitude = ""
    var placeLatitude = ""
    
    
    private init(){}
}
