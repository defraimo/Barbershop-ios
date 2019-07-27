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
        
        //load all data
        let _ = AllBarbers.shared

        //setting the background color
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
        self.navigationController?.navigationBar.setBackgroundImage(#imageLiteral(resourceName: "background"), for: .default)
        
        startAnimating()
        
        NotificationCenter.default.addObserver(forName: .dataWereLoaded, object: nil, queue: .main) { [weak self] (notification) in
            
            guard let isLoaded = notification.userInfo?["isLoaded"] as? Bool else {return}
            
            if isLoaded{
                self?.performSegue(withIdentifier: "goToApp", sender: nil)
            }
        }
    }
    
    fileprivate func startAnimating(){
        UIView.animate(withDuration: 0.6, delay: 0, options: [.repeat, .autoreverse], animations: {
            
            self.loadingImage.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        })
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: .dataWereLoaded, object: nil)
        
        loadingImage.layer.removeAllAnimations()
    }

}
