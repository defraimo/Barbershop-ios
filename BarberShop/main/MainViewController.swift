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
    
    var user:User?
    var userPhoneNum:String?
    
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
    

    @IBAction func signUp(_ sender: UIButton) {
        //init the storyboard because it is in another file now
        let storyBoard =  UIStoryboard(name: "SignUp", bundle: nil)
        
        //init the viewController:
        guard let signUpVc = storyBoard.instantiateViewController(withIdentifier: "toSignUp") as? SingUPViewController else {return}
        //presenting the controller modally:
        present(signUpVc, animated: true, completion: nil)
        
        //releasing the view:
        releaseLoginOrSignupMenu()
    }
    //listener to 
    @IBOutlet weak var phoneNumberField: UITextField!
    @IBAction func phoneNumCheck(_ sender: UITextField) {
        let count = sender.text!.count
        if count != 10{
            sender.setError(hasError: true)
            if count == 0{
                sender.setError(hasError: false)
            }
        }else{
            sender.setError(hasError: false)
        }
    }
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBAction func signInSendCode(_ sender: UIButton) {
        if let count = phoneNumberField.text?.count{
            if count == 0{
            phoneNumberField.placeholder = "שדה זה הוא חובה"
            phoneNumberField.setError(hasError: true )
            }else {
                //phone number was already checked, it's ok to explicitly unwrap it:
                userPhoneNum = phoneNumberField.text!
                //releasing the previous view:
                releaseLoginOrSignupMenu()
                presentAuthCodeView()
            }
        }
       
    }
    //a func for presenting AuthCode view,
    //makes it easier to present it from other view controllers
    @IBAction func sendCodeBtn(_ sender: UIButton) {
        activityIndicator.startAnimating()
    }
    func presentAuthCodeView(){
        //placed under the screen:
        authCodeView.center = CGPoint(x: view.frame.midX, y: 2*view.frame.midY)
        
        //animation displaying the loginOrSingup View:
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 20, options: [], animations: { [weak self] in
            
            guard let center = self?.view.center else {return}
            self?.authCodeView.center = center
            
            self?.view.layoutIfNeeded()
        })
        self.view.addSubview(authCodeView)
        
        //setting up the menu:
        authCodeView.alpha = 1
        authCodeView.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
        authCodeView.layer.shadowColor = UIColor.black.cgColor
        authCodeView.layer.shadowOffset = CGSize(width: 1, height: 1)
        authCodeView.layer.shadowOpacity = 0.5
        authCodeView.layer.masksToBounds = false
        authCodeView.layer.cornerRadius = 25
        authCodeView.layer.shadowRadius = 10
        
        //hiding the nav bar
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        //blur effect for the background
        blurEffect.isHidden = false
        
        //textfield placeholder in white:
        for view in authCodeView.subviews{
            guard let textField = view as? UITextField else {return}
            
            if textField.responds(to: #selector(setter: textField.attributedPlaceholder)) {
                let color = UIColor.lightGray
                textField.attributedPlaceholder = NSAttributedString(string: textField.placeholder!, attributes: [
                    NSAttributedString.Key.foregroundColor: color
                    ])
            } else {
                print("Cannot set placeholder text's color, because deployment target is earlier than iOS 6.0")
            }
        }
    }
    
    //the alert view that recieves the auth code from firebase:
    @IBOutlet var authCodeView: UIView!
    //alert for logging in or going to the sign up page:
    @IBOutlet var loginOrSignupView: UIView!
    //outlet for animation:
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
        
        
        
        if !loginOrSignupView.frame.contains(touch.location(in: self.view)) && loginOrSignupView.isDescendant(of: view){
            releaseLoginOrSignupMenu()
        }else if !menuView.frame.contains(touch.location(in: self.view)) && menuView.isDescendant(of: view){
            releaseMenu()
        }else if !authCodeView.frame.contains(touch.location(in: self.view)) && authCodeView.isDescendant(of: view){
            releaseCodeAuthMenu()
        }

        
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
            guard let midX = self?.view.frame.midX , let midY = self?.view.frame.midY else {return}
            self?.loginOrSignupView.center = CGPoint(x: midX, y: -midY)
            self?.blurEffect.isHidden = true
        }) { (isCompleted) in
            self.phoneNumberField.text = ""
            self.phoneNumberField.setError(hasError: false)
            self.loginOrSignupView.removeFromSuperview()
        }
    }
    
    func releaseCodeAuthMenu(){
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            guard let midX = self?.view.frame.midX , let midY = self?.view.frame.midY else {return}
            self?.authCodeView.center = CGPoint(x: midX, y: -midY)
        }) { (isCompleted) in
            self.blurEffect.isHidden = true
            self.authCodeView.removeFromSuperview()
        }
    }
    
}
extension MainViewController: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let invalidCharacters = CharacterSet(charactersIn: "0123456789").inverted
        let text = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        return string.rangeOfCharacter(from: invalidCharacters) == nil && text.first == "0"
    }
}
