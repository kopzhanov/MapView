//
//  ViewController.swift
//  MapView
//
//  Created by Alikhan Kopzhanov on 20.06.2023.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate, UIGestureRecognizerDelegate, MKMapViewDelegate {
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var ratingLabel: UILabel!
    
    let locationManager = CLLocationManager()
    
    var userLocation = CLLocation()
    
    var followMe = false
    
    var hotel = Hotel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        nameLabel.text = hotel.name
        image.image = UIImage(named: hotel.image)
        ratingLabel.text = "Rating: \(hotel.rating)"
        
        locationManager.requestWhenInUseAuthorization()
        
        locationManager.delegate = self
        
        locationManager.startUpdatingLocation()
        
        let mapDragRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.didDragMap))
        
        mapDragRecognizer.delegate = self
        
        mapView.addGestureRecognizer(mapDragRecognizer)
        
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

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        userLocation = locations[0]
        
        print(userLocation)
            
        if followMe{
            let latDelta:CLLocationDegrees = 0.01
            let longDelta:CLLocationDegrees = 0.01
            
            let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: longDelta)
            let region = MKCoordinateRegion(center: userLocation.coordinate, span: span)
            
            mapView.setRegion(region, animated: true)
        }

    }

    @IBAction func showMyLocation(_ sender: Any) {
        followMe.toggle()
    }
    
    @objc func didDragMap(gestureRecognizer: UIGestureRecognizer){
        if (gestureRecognizer.state == UIGestureRecognizer.State.began){
            followMe = false
            
            print("Map drag began")
        }
        
        if (gestureRecognizer.state == UIGestureRecognizer.State.ended){
            print("Map drag ended")
        }
    }
    
    // MARK: -  MapView delegate
    // Вызывается когда нажали на метку на карте
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
//        // Получаем координаты метки
//        let location:CLLocation = CLLocation(latitude: (view.annotation?.coordinate.latitude)!, longitude: (view.annotation?.coordinate.longitude)!)
        
//        // Считаем растояние до метки от нашего пользователя
//        let meters:CLLocationDistance = location.distance(from: userLocation)
//        distanceLabel.text = String(format: "Distance: %.2f m", meters)
        
        
        // Routing - построение маршрута
        // 1 Координаты начальной точки А и точки B
        let sourceLocation = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        
        let destinationLocation = CLLocationCoordinate2D(latitude: (view.annotation?.coordinate.latitude)!, longitude: (view.annotation?.coordinate.longitude)!)
        
        // 2 упаковка в Placemark
        let sourcePlacemark = MKPlacemark(coordinate: sourceLocation, addressDictionary: nil)
        let destinationPlacemark = MKPlacemark(coordinate: destinationLocation, addressDictionary: nil)
        
        // 3 упаковка в MapItem
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        
        // 4 Запрос на построение маршрута
        let directionRequest = MKDirections.Request()
        // указываем точку А, то есть нашего пользователя
        directionRequest.source = sourceMapItem
        // указываем точку B, то есть метку на карте
        directionRequest.destination = destinationMapItem
        // выбираем на чем будем ехать - на машине
        directionRequest.transportType = .automobile
        
        // Calculate the direction
        let directions = MKDirections(request: directionRequest)
        
        // 5 Запускаем просчет маршрута
        directions.calculate {
            (response, error) -> Void in
            
            // Если будет ошибка с маршрутом
            guard let response = response else {
                if let error = error {
                    print("Error: \(error)")
                }
                
                return
            }
            
            // Берем первый машрут
            let route = response.routes[0]
            // Рисуем на карте линию маршрута (polyline)
            self.mapView.addOverlay((route.polyline), level: MKOverlayLevel.aboveRoads)
            
            // Приближаем карту с анимацией в регион всего маршрута
            let rect = route.polyline.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
        }
        
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        // Настраиваем линию
        let renderer = MKPolylineRenderer(overlay: overlay)
        // Цвет красный
        renderer.strokeColor = UIColor.red
        // Ширина линии
        renderer.lineWidth = 4.0
        
        return renderer
    }
}

