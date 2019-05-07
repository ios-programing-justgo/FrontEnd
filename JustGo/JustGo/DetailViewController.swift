//
//  DetailViewController.swift
//  JustGo
//
//  Created by Ronan Chang on 2019/5/5.
//  Copyright © 2019 ios.nyu.edu. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import FirebaseDatabase

var reviewArr = [rating]()

class customPin: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(pinTitle:String, pinSubTitle:String, location:CLLocationCoordinate2D) {
        self.title = pinTitle
        self.subtitle = pinSubTitle
        self.coordinate = location
    }
}



class DetailViewController: UIViewController,MKMapViewDelegate  {
    
    
    var item: Item?
    //set up for map
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 10000
    var lat:Double = 0.0
    var lon:Double = 0.0
    var pin:String = ""
    var count:String = "0"
    

    
    @IBOutlet weak var detailNameLabel: UILabel!
    @IBOutlet weak var detailPriceLabel: UILabel!
    @IBOutlet weak var detailStoreAddressLabel: UILabel!
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var itemImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = item?.name
        
    
        //get store coords
        for store in storeArr{
            if store.storeID == item?.storeID{
                lat = Double(store.lat)!
                lon = Double(store.lon)!
                pin = store.name
                count = store.count
                print(count)
                
            }
        }
        
        let ref = Database.database().reference().child(count).child("Ratings")
        ref.observe(.value) { (snapshot) in
            for eachReview in snapshot.children.allObjects as! [DataSnapshot] {
                let reviewObject = eachReview.value as? [String: AnyObject]
                let reviewStar = reviewObject?["rating"]
                let reviewComment = reviewObject?["comment"]
                let reviewCount = reviewObject?["count"]
                let new_Review = rating(rating: reviewStar as! String, comment: reviewComment as! String, count:reviewCount as! String )
                reviewArr.append(new_Review)
            }
        }
        
        //set up for mapView
        checkLocationServices()

        print("printing data")
        print(locationManager.location?.coordinate.latitude)


        let userlocation_lat = locationManager.location?.coordinate.latitude ?? 40.7287
        let userlocation_long = locationManager.location?.coordinate.longitude ?? -73.9957

        //setting up current location
        let sourceLocation = CLLocationCoordinate2D(latitude:userlocation_lat , longitude: userlocation_long)
        //set up destination based on store coords
        let destinationLocation = CLLocationCoordinate2D(latitude:lat , longitude: lon)

        let sourcePin = customPin(pinTitle: "User Location", pinSubTitle: "", location: sourceLocation)
        let destinationPin = customPin(pinTitle:pin , pinSubTitle: "", location: destinationLocation)
        self.mapView.addAnnotation(sourcePin)
        self.mapView.addAnnotation(destinationPin)

        let sourcePlaceMark = MKPlacemark(coordinate: sourceLocation)
        let destinationPlaceMark = MKPlacemark(coordinate: destinationLocation)

        let directionRequest = MKDirections.Request()
        directionRequest.source = MKMapItem(placemark: sourcePlaceMark)
        directionRequest.destination = MKMapItem(placemark: destinationPlaceMark)
        directionRequest.transportType = .automobile

        let directions = MKDirections(request: directionRequest)
        directions.calculate { (response, error) in
            guard let directionResonse = response else {
                if let error = error {
                    print("we have error getting directions==\(error.localizedDescription)")
                }
                return
            }

            let route = directionResonse.routes[0]
            self.mapView.addOverlay(route.polyline, level: .aboveRoads)

            let rect = route.polyline.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
        }

        self.mapView.delegate = self
        
        
        //setting up other UI
        self.setUI()
    }
    
    
    //setting up labels
    func setUI(){
        
        detailNameLabel.text = item?.name
        detailPriceLabel.text = item?.price
        itemImageView.image = item?.image
        
        for store in storeArr{
            if store.storeID == item?.storeID{
                detailStoreAddressLabel.text = store.address
            }
        }
    }
    
    //passing data to commentVC
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailToComment"{
            let destination = segue.destination as! CommentViewController
            
            destination.commentArr = reviewArr
    
        }
    }
    
    
    //MARK:- MapKit delegates

    func setUpLocationManager(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
        }
    }

    func checkLocationServices(){
        if CLLocationManager.locationServicesEnabled(){
            setUpLocationManager()
            checkLocationAuthorization()
        }
        else{

        }
    }

    func checkLocationAuthorization(){
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            centerViewOnUserLocation()
            locationManager.startUpdatingLocation()
            break
        case .denied:
            // Show alert instructing them how to turn on permissions
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            // Show an alert letting them know what's up
            break
        case .authorizedAlways:
            break
        }
    }




    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 4.0
        return renderer
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }




}

extension DetailViewController: CLLocationManagerDelegate{

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let region = MKCoordinateRegion.init(center: location.coordinate, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        mapView.setRegion(region, animated: true)
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // we'll be back
    }

}
//
