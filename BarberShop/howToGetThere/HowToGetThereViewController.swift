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
    }
    @IBAction func googleMaps(_ sender: UIButton) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        //setting the background
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
        
        //example address:
        address = Address(streetNum: "1", streetName: "יצחק בן צבי", city: "באר שבע", shopName: "barbershop", latitude: 31.2441326, longitude: 34.7967733)
        
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

}
