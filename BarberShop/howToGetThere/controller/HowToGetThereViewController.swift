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
    var coordinate:CLLocationCoordinate2D?

    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var howToGetThereLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBAction func waze(_ sender: UIButton) {
        navigateToWaze(address: address!)
    }
    @IBAction func googleMaps(_ sender: UIButton) {
        navigateToGoogle(toLatitude: coordinate!.latitude, longitude: coordinate!.longitude)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        //setting the background
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
        
        DAO.shared.getLocation {[weak self] (address) in
            self?.address = address
        
        address!.addressToCLLocation(completion: { [weak self](location) in
            self?.coordinate = location.coordinate
            guard let coordinates = self?.coordinate else {print("SHIT2");return}
            
            guard let address = self?.address else {return}
            //region of barbershop
            let region = MKCoordinateRegion(center: coordinates, latitudinalMeters: 500, longitudinalMeters: 500)
            //setting the mapview on the region:
            self?.mapView.setRegion(region, animated: true)
            //show info of the barbershop on map:
            let annotation = AddressAnotation(title: address.shopName, subtitle: address.description, coordinate: coordinates)
            //adding the annotation:
            self?.mapView.addAnnotation(annotation)
            
            self?.locationLabel.text = address.description
        })
        }
        //setting the label size to be responsive
        howToGetThereLabel.adjustsFontSizeToFitWidth = true
        howToGetThereLabel.minimumScaleFactor = 0.2
        
    }
    func navigateToWaze(address:Address) {
        if UIApplication.shared.canOpenURL(URL(string: "waze://")!) {
            // Waze is installed. Launch Waze and start navigation
            let url = URL(string: "waze:///ul?q=\(address.streetNum)%20\(address.streetName)%20\(address.city)")!
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        else {
            address.addressToCLLocation { (location) in
                let lat = location.coordinate.latitude
                let lng = location.coordinate.longitude
                UIApplication.shared.open(URL(string:"https://www.waze.com/en/livemap/directions?latlng=\(lat)%2C\(lng)&zoom=16")!)
            }
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

