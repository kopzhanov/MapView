//
//  ViewController.swift
//  MapView
//
//  Created by Alikhan Kopzhanov on 20.06.2023.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var ratingLabel: UILabel!
    
    let locationManager = CLLocationManager()
    
    var hotel = Hotel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        print(hotel.lat)
        print(hotel.long)
        
        nameLabel.text = hotel.name
        image.image = UIImage(named: hotel.image)
        ratingLabel.text = "Rating: \(hotel.rating)"
        
        locationManager.requestWhenInUseAuthorization()
        
        locationManager.delegate = self
        
        locationManager.startUpdatingLocation()
        
        let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(hotel.lat, hotel.long)
        
        let annotation = MKPointAnnotation()
        
        annotation.coordinate = location
        annotation.title = hotel.name
        annotation.subtitle = hotel.address
        
        mapView.addAnnotation(annotation)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: annotation.coordinate, span: span)
        
        mapView.setRegion(region, animated: true)
        mapView.delegate = self
    }
    
    @IBAction func showRoute(_ sender: Any) {
        let fullMap = storyboard?.instantiateViewController(withIdentifier: "fullMap") as! ViewControllerFullMap
       
        fullMap.hotel = hotel
        
        navigationController?.show(fullMap, sender: self)
    }
}

