//
//  HowToGetThereViewController.swift
//  BarberShop
//
//  Created by Daniel Radshun on 21/06/2019.
//  Copyright © 2019 Neighbors. All rights reserved.
//

import UIKit
import MapKit

class HowToGetThereViewController: UIViewController {
    var address:Address?

    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var howToGetThereLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBAction func waze(_ sender: UIButton) {
        navigateToWaze(toLatitude: address!.latitude, longitude: address!.longitude)
    }
    @IBAction func googleMaps(_ sender: UIButton) {
        navigateToGoogle(toLatitude: address!.latitude, longitude: address!.longitude)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        //setting the background
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
        
        //example address:
        address = Address(streetNum: "1", streetName: "יצחק בן צבי", city: "באר שבע", shopName: "barbershop", latitude: 31.2441326, longitude: 34.7967736)
        
        guard let address = address else {return}
        //coordinates:
        let cl2d = address.location.coordinate
        //region of barbershop
        let region = MKCoordinateRegion(center: cl2d, latitudinalMeters: 200, longitudinalMeters: 200)
        //setting the mapview on the region:
        mapView.setRegion(region, animated: true)
        //show info of the barbershop on map:
        let annotation = AddressAnotation(title: address.shopName, subtitle: address.description, coordinate: cl2d)
        //adding the annotation:
        mapView.addAnnotation(annotation)
        
        //setting the label size to be responsive
        howToGetThereLabel.adjustsFontSizeToFitWidth = true
        howToGetThereLabel.minimumScaleFactor = 0.2
        
        locationLabel.text = address.description
    }
    func navigateToWaze(toLatitude latitude: Double , longitude: Double) {
        if UIApplication.shared.canOpenURL(URL(string: "waze://")!) {
            // Waze is installed. Launch Waze and start navigation
            let url = URL(string: "waze://?ll=\(latitude),\(longitude)&navigate=yes")!
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        else {
            // Waze is not installed. Launch AppStore to install Waze app
            UIApplication.shared.open(URL(string: "https://apps.apple.com/gy/app/waze-navigation-live-traffic/id323229106")!)
        }
    }
    func navigateToGoogle(toLatitude latitude: Double , longitude: Double){
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
            UIApplication.shared.open(URL(string:"comgooglemaps://?saddr=&daddr=\(latitude),\(longitude)&directionsmode=driving")!)
        } else {
            UIApplication.shared.open(URL(string: "https://www.google.co.il/maps/dir///@\(latitude),\(longitude),12z")!)
        }
    }
}

extension HowToGetThereViewController: MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? AddressAnotation else {return nil}
        
        //reuse id:
        var view = mapView.dequeueReusableAnnotationView(withIdentifier: "barbershop")
        
        //init the view:
        if view == nil{
            view = BarbershopAnnotationView(annotation: annotation, reuseIdentifier: "barbershop")
        }
        return view
    }
}
