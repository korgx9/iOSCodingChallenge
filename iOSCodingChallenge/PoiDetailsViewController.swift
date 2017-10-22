//
//  PoiDetailsViewController.swift
//  iOSCodingChallenge
//
//  Created by Kesh Pola on 10/22/17.
//  Copyright © 2017 KeshPola. All rights reserved.
//

import UIKit
import Mapbox

class PoiDetailsViewController: UIViewController {
    
    @IBOutlet weak var mapView: MGLMapView!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    var poi = Poi()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.setCenter(poi.getCoordinates(), animated: true)
        mapView.showsUserLocation = true
        mapView.logoView.isHidden = true
        mapView.setCenter(poi.getCoordinates(), zoomLevel: 15, animated: true)
        
        let poiAnnotation = MGLPointAnnotation()
        poiAnnotation.coordinate = poi.getCoordinates()
        poiAnnotation.title = nil
        poiAnnotation.subtitle = nil
        mapView.addAnnotation(poiAnnotation)
        
        typeLabel.text = "Type: \(poi.type)"
        statusLabel.text = "Status: \(poi.state)"
        addressLabel.text = ""
        distanceLabel.text = ""
    }
}
