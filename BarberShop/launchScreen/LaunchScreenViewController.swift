//
//  LaunchScreenViewController.swift
//  BarberShop
//
//  Created by Daniel Radshun on 26/07/2019.
//  Copyright © 2019 Neighbors. All rights reserved.
//

import UIKit

class LaunchScreenViewController: UIViewController {
        
    @IBOutlet weak var loadingImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setting the background color
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
        self.navigationController?.navigationBar.setBackgroundImage(#imageLiteral(resourceName: "background"), for: .default)
        
        self.startAnimating()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //checks internet connection:
        if !Reachability.isConnectedToNetwork(){
            let alert = AlertService().alert(title: "אין חיבור אינטרנט", body: "אנא בדוק אם הינך מחובר לרשת האינטרנט", btnAmount: 1, positive: "אשר", negative: nil, positiveCompletion: {
                self.openWifiSettings()
            }, negativeCompletion: nil)
            
            present(alert, animated: true) { [weak self] in
                self?.loadingImage.layer.removeAllAnimations()
            }
        }else{
            //load the aboutUs data
            AboutUs.fetchData()
            
            //load descriptionAboveBarbers line
            DescriptionAboveBarbers.fetchData()
            
            //load the barbershop contact details
            ContactUs.fetchData()
            
            //load
            
            //load the barbers and the prices
            let _ = AllBarbers.shared
            
            
            
            NotificationCenter.default.addObserver(forName: .dataWereLoaded, object: nil, queue: .main) { [weak self] (notification) in
                
                guard let isLoaded = notification.userInfo?["isLoaded"] as? Bool else {return}
                
                if isLoaded{
                    self?.performSegue(withIdentifier: "goToApp", sender: nil)
                }
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: .dataWereLoaded, object: nil)
        
        loadingImage.layer.removeAllAnimations()
    }
    
    fileprivate func startAnimating(){
        UIView.animate(withDuration: 0.6, delay: 0, options: [.repeat, .autoreverse], animations: {
            
            self.loadingImage.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
        })
    }
}
