//
//  MainViewController.swift
//  BarberShop
//
//  Created by Daniel Radshun on 17/06/2019.
//  Copyright © 2019 Neighbors. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    let barberPhone = "0544533616"
    let userName =  "daniel_radshun"
    
    @IBOutlet weak var imageRounded: UIImageView!
    @IBOutlet weak var whatsupp: UIImageView!
    @IBOutlet weak var instagram: UIImageView!
    @IBAction func whatsuppTapped(_ sender: UITapGestureRecognizer) {
        let urlWhats = "whatsapp://send?phone=(\(barberPhone))"
        if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed){
            if let whatsappURL = URL(string: urlString) {
                if UIApplication.shared.canOpenURL(whatsappURL){
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(whatsappURL, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(whatsappURL)
                    }
                }
                else {
                    print("Install Whatsapp")
                }
            }
        }
    }
    @IBAction func instagramTapped(_ sender: UITapGestureRecognizer) {
        let appURL = NSURL(string: "instagram://user?screen_name=\(userName)")!
        let webURL = NSURL(string: "https://instagram.com/\(userName)")!
        
        if UIApplication.shared.canOpenURL(appURL as URL) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(appURL as URL, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(appURL as URL)
            }
        } else {
            //redirect to safari because the user doesn't have Instagram
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(webURL as URL, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(webURL as URL)
            }
        }
    }
    
    let blurEffect = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    
    @IBOutlet var menuView: UIView!
    @IBAction func openMenu(_ sender: UIBarButtonItem) {
        menuView.center = CGPoint(x: view.frame.midX, y: -view.frame.midY)
        
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let midX = self?.view.frame.midX,
                let midY = self?.view.frame.midY else {return}
            
            self?.menuView.center = CGPoint(x: midX, y: 0.8*midY)
        }
        
        self.view.addSubview(menuView)
        
        menuView.isHidden = false
        
        menuView.alpha = 1
        
        menuView.layer.shadowColor = UIColor.black.cgColor
        menuView.layer.shadowOffset = CGSize(width: 1, height: 1)
        menuView.layer.shadowOpacity = 0.5
        menuView.layer.masksToBounds = false
        menuView.layer.shadowRadius = 10
        menuView.layer.cornerRadius = 30
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        blurEffect.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //setting the background color
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
        self.navigationController?.navigationBar.setBackgroundImage(#imageLiteral(resourceName: "background"), for: .default)
        
        //setting the menu background color
        menuView.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
        
        //change the navigation title color
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        //change the navigation item color
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        //setting the "getting an appoinment" image to rounded
        imageRounded.layer.cornerRadius = 42
        imageRounded.layer.masksToBounds = true
        
        addBlurView()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        releaseMenu()
    }
    
 
    func addBlurView(){
 
        self.view.addSubview(blurEffect)
        
        blurEffect.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([blurEffect.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0),
                                     blurEffect.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0),
                                     blurEffect.topAnchor.constraint(equalTo: self.view.superview?.topAnchor ?? self.view.topAnchor, constant: 0),
                                     blurEffect.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0)])
        
        blurEffect.isHidden = true
    }
    
    func releaseMenu(){
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        UIView.animate(withDuration: 0.1, animations: { [weak self] in
            self?.menuView.alpha = 0
        }) { (isCompleted) in
            self.blurEffect.isHidden = true
            self.menuView.removeFromSuperview()
        }
    }
    
}
