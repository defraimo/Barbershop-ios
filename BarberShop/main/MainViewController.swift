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
    
    lazy var blurEffect = {
        return UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    }()
    
    @IBOutlet var menuView: UIView!
    @IBAction func openMenu(_ sender: UIBarButtonItem) {
        menuView.center = CGPoint(x: view.frame.midX, y: -view.frame.midY)
                
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 20, options: [], animations: { [weak self] in
            guard let midX = self?.view.frame.midX,
                let midY = self?.view.frame.midY else {return}
            
            self?.menuView.center = CGPoint(x: midX, y: 0.8*midY)
            self?.view.layoutIfNeeded()
        })
        
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
    
    //pressing effects
    @IBOutlet weak var pricesButton: UIButton!
    @IBAction func showPrices(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 50, options: [], animations: {
            self.pricesButton.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                self.pricesButton.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
                self.performSegue(withIdentifier: "toPrices", sender: nil)
            })
        }) { (_) in
            self.pricesButton.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
    }
    @IBOutlet weak var aboutUsButton: UIButton!
    @IBAction func showAboutUs(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 50, options: [], animations: {
            self.aboutUsButton.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                self.aboutUsButton.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
                self.performSegue(withIdentifier: "toAboutUs", sender: nil)
            })
        }) { (_) in
            self.aboutUsButton.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
    }
    @IBOutlet weak var howWeGetThereButton: UIButton!
    @IBAction func showHowWeGetThere(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 50, options: [], animations: {
            self.howWeGetThereButton.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                self.howWeGetThereButton.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
                self.performSegue(withIdentifier: "toHowWeGetThere", sender: nil)
            })
        }) { (_) in
            self.howWeGetThereButton.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
    }
    @IBOutlet weak var whatsupButton: UIButton!
    @IBAction func goToWhatsUp(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 50, options: [], animations: {
            self.whatsupButton.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                self.whatsupButton.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
                
                let urlWhats = "whatsapp://send?phone=(\(self.barberPhone))"
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
                
            })
        }) { (_) in
            self.whatsupButton.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
    }
    @IBOutlet weak var instagramButton: UIButton!
    @IBAction func goToInstagram(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 50, options: [], animations: {
            self.instagramButton.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                self.instagramButton.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
                
                let appURL = NSURL(string: "instagram://user?screen_name=\(self.userName)")!
                let webURL = NSURL(string: "https://instagram.com/\(self.userName)")!
                
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
                
            })
        }) { (_) in
            self.instagramButton.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
    }
    
    @IBOutlet var loginOrSignupView: UIView!
    @IBOutlet weak var appointmentBtn: UIButton!
    @IBAction func makeAppointment(_ sender: UIButton) {
        //placed above screen
        loginOrSignupView.center = CGPoint(x: view.frame.midX, y: -view.frame.midY)

        //animation of the button press
        UIView.animate(withDuration: 0.1, animations: {
            self.appointmentBtn.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
        }) { (b) in
            UIView.animate(withDuration: 0.1, animations: {
                self.appointmentBtn.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
        }
        //animation displaying the loginOrSingup View:
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 20, options: [], animations: { [weak self] in
            
            guard let center = self?.view.center else {return}
            self?.loginOrSignupView.center = center
            
            self?.view.layoutIfNeeded()
            })
        
        self.view.addSubview(loginOrSignupView)
        
        //setting up the menu:
        loginOrSignupView.alpha = 1
        loginOrSignupView.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
        loginOrSignupView.layer.shadowColor = UIColor.black.cgColor
        loginOrSignupView.layer.shadowOffset = CGSize(width: 1, height: 1)
        loginOrSignupView.layer.shadowOpacity = 0.5
        loginOrSignupView.layer.masksToBounds = false
        loginOrSignupView.layer.cornerRadius = 25
        loginOrSignupView.layer.shadowRadius = 10
        
        //hiding the nav bar
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        //blur effect for the background
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
       
        guard let touch = touches.first else {return}
        
        
        
        if loginOrSignupView.frame.contains(touch.location(in: self.view)){
            return
        }else if menuView.frame.contains(touch.location(in: self.view)){
            return
        }
        releaseMenu()
        releaseLoginOrSignupMenu()

        
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
    
    func releaseLoginOrSignupMenu(){
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            self?.loginOrSignupView.alpha = 0
        }) { (isCompleted) in
            self.blurEffect.isHidden = true
            self.loginOrSignupView.removeFromSuperview()
        }
    }
    
}
