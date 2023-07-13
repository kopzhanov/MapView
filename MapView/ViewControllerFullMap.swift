//
//  ViewControllerFullMap.swift
//  MapView
//
//  Created by Alikhan Kopzhanov on 25.06.2023.
//

import UIKit
import MapKit

class ViewControllerFullMap: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    @IBOutlet weak var mapView: MKMapView!
    
    var hotel = Hotel()
    let locationManager = CLLocationManager()
    var userLocation = CLLocation()
//    var ALMATY_LAT = 31.723610
//    var ALMATY_LONG = -115.348625
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        print(hotel.lat)
        print(hotel.long)
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        
        let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(hotel.lat, hotel.long)
        let annotation = MKPointAnnotation()
        
        annotation.coordinate = location
        annotation.title = hotel.name
        annotation.subtitle = hotel.address
        
        mapView.addAnnotation(annotation)
        mapView.delegate = self
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userLocation = locations[0]
        
        let request = MKDirections.Request()
                // Source
        let sourcePlaceMark = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude))
        request.source = MKMapItem(placemark: sourcePlaceMark)
                // Destination
        let destPlaceMark = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: hotel.lat, longitude: hotel.long))
        request.destination = MKMapItem(placemark: destPlaceMark)
                // Transport Types
        request.transportType = .automobile

        let directions = MKDirections(request: request)
        directions.calculate { response, error in
            guard let response = response else {
                print("Error: \(error?.localizedDescription ?? "No error specified").")
                return
            }
            
            let route = response.routes[0]
            self.mapView.addOverlay(route.polyline)
        }
        
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            // Настраиваем линию
            let renderer = MKPolylineRenderer(overlay: overlay)
            // Цвет красный
            renderer.strokeColor = UIColor.blue
            // Ширина линии
            renderer.lineWidth = 4.0
            
            return renderer
        }
        /*
         // MARK: - Navigation
         
         // In a storyboard-based application, you will often want to do a little preparation before navigation
         override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
         }
         */
}
