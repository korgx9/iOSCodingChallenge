//
//  PoiDetailsViewController.swift
//  iOSCodingChallenge
//
//  Created by Kesh Pola on 10/22/17.
//  Copyright © 2017 KeshPola. All rights reserved.
//

import UIKit
import Mapbox
import MapboxGeocoder

class PoiDetailsViewController: UIViewController {
    
    @IBOutlet weak var mapView: MGLMapView!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    var poi = Poi()
    var locationManager: CLLocationManager!
    
    private let geocoder = Geocoder.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.setCenter(poi.getCoordinates(), animated: true)
        mapView.logoView.isHidden = true
        mapView.setCenter(poi.getCoordinates(), zoomLevel: 16, animated: true)
        
        let poiAnnotation = MGLPointAnnotation()
        poiAnnotation.coordinate = poi.getCoordinates()
        poiAnnotation.title = nil
        poiAnnotation.subtitle = nil
        mapView.addAnnotation(poiAnnotation)
        
        typeLabel.text = "Type: \(poi.type): \(poi.id)"
        statusLabel.text = "Status: \(poi.state)"
        addressLabel.text = ""
        distanceLabel.text = getDistanceText()
        
        reversGeoCoding()
    }
    
    func getDistanceText() -> String {
        
        let notAllowedText = NSLocalizedString("Please, enable location service", comment: "Ditance label text if no GPS enabled")
        
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted, .denied:
                return notAllowedText
            case .authorizedWhenInUse:
                guard let locationManager = locationManager else {return notAllowedText}
                guard let location = locationManager.location else {return notAllowedText}
                return NSLocalizedString("Distance from you:", comment: "Label text distance from")  + " "
                    + String(format: "%.2f", poi.distanceFrom(point: location))
                    + NSLocalizedString(" meters", comment: "Label text distance measure")
            default: return notAllowedText
            }
        }
        else {
            return notAllowedText
        }
    }
    
    func reversGeoCoding() {
        let options = ReverseGeocodeOptions(coordinate: poi.getCoordinates())
        
        let _ = geocoder.geocode(options) { [weak self] (placemarks, attribution, error) in
            guard let selfNotNill = self else {return}
            guard let placemark = placemarks?.first else {return}
            
            selfNotNill.addressLabel.text = placemark.qualifiedName
        }
    }
}
