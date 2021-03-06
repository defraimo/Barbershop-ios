//
//  MainViewController.swift
//  BarberShop
//
//  Created by Daniel Radshun on 17/06/2019.
//  Copyright © 2019 Neighbors. All rights reserved.
//

import UIKit
import FirebaseAuth
import ImageSlideshow

class MainViewController: UIViewController {
    
    var user:User?
    var userPhoneNum:String?
    
    lazy var blurEffect = {
        return UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    }()
    
    @IBOutlet weak var imageSlideShow: ImageSlideshow!
    //view that pops when a message from the barber exists
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var messageImg: UIImageView!
    
    @IBOutlet weak var roundedView: UIView!
    @IBOutlet weak var roundedViewHeight: NSLayoutConstraint!
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
        UIView.animate(withDuration: 0.2, animations: {
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
                
                if let barberPhone = ContactUs.shared?.whatsupp{
                    let whatsappURL = URL(string: "https://api.whatsapp.com/send?phone=\(barberPhone)")
                    if UIApplication.shared.canOpenURL(whatsappURL!) {
                        UIApplication.shared.open(whatsappURL!, options: [:])
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
                
                if let userName = ContactUs.shared?.instagramName{
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
                
            })
        }) { (_) in
            self.instagramButton.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
    }
    
    //alert for logging in or going to the sign up page:
    @IBOutlet var loginOrSignupView: UIView!
    //outlet for animation:
    @IBOutlet weak var appointmentBtn: UIButton!
    
    @IBOutlet weak var signInLabel1: UILabel!
    @IBOutlet weak var signInSendCodeBtn: UIButton!
    @IBOutlet weak var newCustomer: UILabel!
    @IBOutlet weak var signUpHereBtn: UIButton!
    
    @IBOutlet weak var makeAppointmentIndicator: UIActivityIndicatorView!
    //when ״הזמן תור״ is pressed:
    @IBAction func makeAppointment(_ sender: UIButton) {
        
        makeAppointmentIndicator.startAnimating()
        
        if !Reachability.isConnectedToNetwork(){
            let alert = AlertService().alert(title: "אין חיבור אינטרנט", body: "אנא בדוק אם הינך מחובר לרשת האינטרנט", btnAmount: 1, positive: "אשר", negative: nil, positiveCompletion: {
                self.openWifiSettings()
            }, negativeCompletion: nil)
            
            present(alert, animated: true)
        }else{
        //if there is a signed in user, it will go straight to haircuts:
        let user = Auth.auth().currentUser
        if user != nil {
            DAO.shared.getAppointment(userId: user!.uid) { [weak self] (appointment, isExist) in
                if isExist{
                    self?.makeAppointmentIndicator.stopAnimating()
                    self?.performSegue(withIdentifier: "toManageAppointment", sender: appointment)
                }
                else{
                    self?.makeAppointmentIndicator.stopAnimating()
                    
                    //init the storyboard because it is in another file now
                    let storyBoard =  UIStoryboard(name: "Schedule", bundle: nil)
                    
                    //init the viewController:
                    guard let scheduleVc = storyBoard.instantiateViewController(withIdentifier: "toHaircuts") as? ChooseHaircutViewController else {return}
                    
                    self?.navigationController?.pushViewController(scheduleVc, animated: true)
                }
            }
            
        }else{
            self.makeAppointmentIndicator.stopAnimating()
            loginOrSignUpFunc()
            }
        }
    }
    
    @IBOutlet weak var loginLabelForCheck: UILabel!
    @IBOutlet weak var loginActivityIndicator: UIActivityIndicatorView!
    fileprivate func loginOrSignUpFunc() {
        //placed above screen
        loginOrSignupView.center = CGPoint(x: view.frame.midX, y: -view.frame.midY)
        //setting up the size:
        var frm = loginOrSignupView.frame
        frm.size.width = self.view.frame.width*0.8
        loginOrSignupView.frame = frm
        
        newCustomer.adjustsFontSizeToFitWidth = true
        newCustomer.minimumScaleFactor = 0.4
        signUpHereBtn.titleLabel!.adjustsFontSizeToFitWidth = true
        signUpHereBtn.titleLabel!.minimumScaleFactor = 0.4
        signInLabel1.adjustsFontSizeToFitWidth = true
        signInLabel1.minimumScaleFactor = 0.4
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
    
    //when "הירשם" is pressed:
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
    
    @IBOutlet weak var phoneNumberField: UITextField!
    //listener of the phone field to check the correct phone number is inserted:
    @IBAction func phoneNumCheck(_ sender: UITextField) {
        let count = sender.text!.count
        if !sender.text!.elementsEqual("+16505553434") || count != 10 {
            sender.setError(hasError: true)
            if count == 0{
                sender.setError(hasError: false)
            }
        }else{
            sender.setError(hasError: false)
        }
    }
  
    @IBAction func signInSendCode(_ sender: UIButton) {
        if let count = phoneNumberField.text?.count{
            if count == 0{
            phoneNumberField.placeholder = "שדה זה הוא חובה"
            phoneNumberField.setError(hasError: true )
            }else {
                userPhoneNum = phoneNumberField.text! as String
                loginActivityIndicator.alpha = 1
                loginActivityIndicator.startAnimating()
                
                if phoneNumberField.text!.elementsEqual("+16505553434"){
                    self.releaseLoginOrSignupMenu()
                    self.presentAuthCodeView()
                    return
                }
                //phone number was already checked, it's ok to explicitly unwrap it:
                //checking if the user already exists:
                DAO.shared.checkUserExists(number: userPhoneNum!, completion: {[weak self] (exists)  in
                    if exists{
                        //releasing the previous view:
                        self?.releaseLoginOrSignupMenu()
                        self?.presentAuthCodeView()
                    }else{
                        //TODO: add animation to text!
                        self?.loginLabelForCheck.text = "משתמש לא קיים, נא הירשם"
                        
                        self?.loginActivityIndicator.stopAnimating()
                        self?.loginActivityIndicator.alpha = 0
                    }
                })
            
            }
        }
       
    }
  
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var codeField: UITextField!
    @IBOutlet weak var authCodeViewLabel: UILabel!
    //a func for presenting AuthCode view,
    //makes it easier to present it from other view controllers
    //the alert view that recieves the auth code from firebase:
    @IBOutlet var authCodeView: UIView!
    func presentAuthCodeView(){
        //placed under the screen:
        authCodeView.center = CGPoint(x: view.frame.midX, y: 2*view.frame.midY)
        
        //animation displaying the loginOrSingup View:
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 20, options: [], animations: { [weak self] in
            guard let center = self?.view.center else {return}
            self?.authCodeView.center = center
            
            self?.view.layoutIfNeeded()
        })
        self.view.addSubview(self.authCodeView)
        
        //getting the verification id:
        DAO.shared.getVerificationId(userPhoneNum!)
        
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
            guard let textField = view as? UITextField else {continue}

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
    
    @IBAction func sendCodeBtn(_ sender: UIButton) {
        activityIndicator.alpha = 1
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        if codeField.text == ""{
            codeField.setError(hasError: true)
            return
        }else{
            codeField.setError(hasError: false)
           let code = codeField.text!
            DAO.shared.verifyUser(code, completion: { [weak self] (result ,success) in
                //checks of the auth code is correct and the process
                //of verification succeeded, if not will notify user
                if (success){
                guard let uid = Auth.auth().currentUser?.uid else {return}
                if let user = self?.user{
                    DAO.shared.saveNewUser(user, uid: uid)
                }
                DAO.shared.writeToken(userId: uid, token: AppDelegate.token!)
                
                DAO.shared.getAppointment(userId: uid) { [weak self] (appointment, isExist) in
                    if isExist{
                        self?.activityIndicator.stopAnimating()
                        self?.activityIndicator.isHidden = true
                        
                        self?.releaseCodeAuthMenu()
                        
                        self?.performSegue(withIdentifier: "toManageAppointment", sender: appointment)
                    }
                    else{
                        //init the storyboard because it is in another file now
                        let storyBoard =  UIStoryboard(name: "Schedule", bundle: nil)
                        
                        //init the viewController:
                        guard let scheduleVc = storyBoard.instantiateViewController(withIdentifier: "toHaircuts") as? ChooseHaircutViewController else {return}
                        
                        self?.activityIndicator.stopAnimating()
                        self?.activityIndicator.isHidden = true
                        
                        self?.releaseCodeAuthMenu()
                        
                        self?.navigationController?.pushViewController(scheduleVc, animated: true)
                    }
                    }
                }
                else{
                    self?.activityIndicator.stopAnimating()
                    self?.activityIndicator.isHidden = true
                   self?.authCodeViewLabel.text = "הקוד שהוכנס היה שגוי, אנא נסו שנית"
                }
            })
        }
    }

    @IBAction func signOut(_ sender: UIButton) {
        //checks internet connection:
        if !Reachability.isConnectedToNetwork(){
            let alert = AlertService().alert(title: "אין חיבור אינטרנט", body: "אנא בדוק אם הינך מחובר לרשת האינטרנט", btnAmount: 1, positive: "אשר", negative: nil, positiveCompletion: {
                self.openWifiSettings()
            }, negativeCompletion: nil)
            
            present(alert, animated: true)
        }else{
        releaseMenu()
        let alert:AlertViewController?
        if(Auth.auth().currentUser == nil){
             alert = AlertService().alert(title: "אינך מחובר", body: "לא זיהינו משתמש מחובר לכן לא ניתן לבצע התנתקות", btnAmount: 1, positive: "אשר", negative: nil, positiveCompletion: {}, negativeCompletion: {})
        }else{
            alert = AlertService().alert(title: "התנתקות", body: "האם אתה בטוח שברצונך להתנתק?", btnAmount: 2, positive: "כן", negative: "בטל", positiveCompletion: {
                self.navigationItem.title = "שלום, אורח"
                let firebaseAuth = Auth.auth()
                do {
                    try firebaseAuth.signOut()
                } catch let signOutError as NSError {
                    print ("Error signing out: %@", signOutError)
                }
            }, negativeCompletion: nil)
        }
        present(alert!, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
//        DAO.shared.writeSchedule()
        
        setUpImageSlider()
        
        //setting the background color
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
        self.navigationController?.navigationBar.setBackgroundImage(#imageLiteral(resourceName: "background"), for: .default)
        
        //setting the menu background color
        menuView.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
        
        //change the navigation title color
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        //change the navigation item color
        self.navigationController?.navigationBar.tintColor = UIColor.white

        addBlurView()
        
        roundedView.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
        roundedView.layer.cornerRadius = 14
        
        //setting the label size to be responsive
        adjustsButtonFont(appointmentBtn)
        adjustsButtonFont(pricesButton)
        adjustsButtonFont(aboutUsButton)
        adjustsButtonFont(howWeGetThereButton)
        
        checkingIfRewritingTokenRequired()
        
    }
    
    fileprivate func checkingIfRewritingTokenRequired() {
        //when downloading the app for the second time
        //checks if user logged and if true writes his new token to the database
        if UserDefaults.isFirstLaunch(){
            if Auth.auth().currentUser != nil{
                guard let uid = Auth.auth().currentUser?.uid else {return}
                DAO.shared.writeToken(userId: uid, token: AppDelegate.token!)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(forName: .singUp, object: nil, queue: .main) { [weak self] (notification) in
            guard let openView = notification.userInfo?["authCodeView"] as? Bool else {return}
            
            if let user = notification.userInfo?["user"] as? User {
                self?.user = user
                self?.userPhoneNum = user.number
            }
            if openView{
                //change it back to false
                NotificationCenter.default.post(name: .singUp, object: nil, userInfo: ["authCodeView":false])
                self?.presentAuthCodeView()
            }
        }
        //sets the title above according to a user, or writes hello, guest
        navigationTitle()
        
        //sets the message if there is one:
        setMessageView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: .singUp, object: nil)
    }
    
    func navigationTitle(){
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            self.navigationItem.title = "שלום, אורח"
            return
        }
        DAO.shared.getUser(currentUserID) { [weak self](user) in
            if let user = user {
                self?.navigationItem.title = " שלום, \(user.fullName)"
            }
        }
    }
    
    func setMessageView(){
        let barberMessage = BarberMessage.shared
        guard let message = barberMessage?.message, let messageLabel =  messageLabel else {return}
        
            messageLabel.text = message
            messageView.isHidden = false

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                UIView.animate(withDuration: 0.5){[weak self] in
                    self?.messageView.alpha = 1
                }
        }
    }
    
    @IBAction func releaseMessageView(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2, animations: {
            self.messageView.alpha = 0.5
        }) { (isSucceed) in
            self.messageView.isHidden = true
            self.messageView.removeFromSuperview()
        }

    }
    
    func setUpImageSlider(){
        //get images from firebase
        DAO.shared.loadSliderImages { (sliderImages) in
            var imagesSource:[SDWebImageSource] = []
            for sliderImage in sliderImages{
                if let image = SDWebImageSource(urlString: sliderImage.imagePath){
                    imagesSource.append(image)
                }
            }
            //set the images to the slider
            self.imageSlideShow.setImageInputs(imagesSource)
            //set the sontent mode to fill the hole screen
            self.imageSlideShow.contentScaleMode = UIViewContentMode.scaleAspectFill
            //set the intervals between each pic
            self.imageSlideShow.slideshowInterval = 5
            //set the  indicator
            self.imageSlideShow.activityIndicator = DefaultActivityIndicator(style: .white, color: nil)
        }
        
    }
    
    func adjustsButtonFont(_ button:UIButton){
        //setting the label size to be responsive
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.minimumScaleFactor = 0.2
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
       
        //releases the keyboard when done editing:
        self.view.endEditing(true)
        
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
        self.loginLabelForCheck.text = "הזינו מספר פלאפון להזדהות"

        loginActivityIndicator.stopAnimating()
        loginActivityIndicator.alpha = 0
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
            self.codeField.text = ""
            self.codeField.setError(hasError: false)
            self.authCodeViewLabel.text = "קוד אימות ישלח בעוד מספר שניות"
            self.blurEffect.isHidden = true
            self.authCodeView.removeFromSuperview()
        }
    }
    
    //MENU
    
    //manage appointment
    @IBOutlet weak var manageAppointmentIndicator: UIActivityIndicatorView!
    
    @IBAction func manageAppointmentButton(_ sender: UIButton) {
        manageAppointmentIndicator.startAnimating()

        //check internet connection:
        if !Reachability.isConnectedToNetwork(){
            let alert = AlertService().alert(title: "אין חיבור אינטרנט", body: "אנא בדוק אם הינך מחובר לרשת האינטרנט", btnAmount: 1, positive: "אשר", negative: nil, positiveCompletion: {
                self.openWifiSettings()
            }, negativeCompletion: nil)
            
            self.manageAppointmentIndicator.stopAnimating()
            present(alert, animated: true)
        }
        else{
        if let uid = Auth.auth().currentUser?.uid{
            
            DAO.shared.getAppointment(userId: uid) { [weak self] (appointment, isExist) in
                if isExist{
                    
                    self?.manageAppointmentIndicator.stopAnimating()
                    self?.releaseMenu()
                    
                    self?.performSegue(withIdentifier: "toManageAppointment", sender: appointment)
                    
                }
                else{
                    self?.manageAppointmentIndicator.stopAnimating()
                    self?.releaseMenu()
                    let alert = AlertService().alert(title: "לא נקבעו תורים", body: "יש להזמין תחילה תור על מנת להיכנס לאפשרות זו", btnAmount: 2, positive: "הזמנת תור", negative: "ביטול", positiveCompletion: {
                        
                        //init the storyboard because it is in another file now
                        let storyBoard =  UIStoryboard(name: "Schedule", bundle: nil)
                        
                        //init the viewController:
                        guard let scheduleVc = storyBoard.instantiateViewController(withIdentifier: "toHaircuts") as? ChooseHaircutViewController else {return}
                        
                        self?.navigationController?.pushViewController(scheduleVc, animated: true)
                        
                    }, negativeCompletion: nil)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.15, execute: {
                        self?.present(alert, animated: true)
                    })
                }
            }
            
        }
        else{
            self.manageAppointmentIndicator.stopAnimating()
            self.releaseMenu()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.loginOrSignUpFunc()
            }
            }
        }
    }
    
    @IBAction func menuLogin(_ sender: UIButton) {
        //check internet connection:
        if !Reachability.isConnectedToNetwork(){
            let alert = AlertService().alert(title: "אין חיבור אינטרנט", body: "אנא בדוק אם הינך מחובר לרשת האינטרנט", btnAmount: 1, positive: "אשר", negative: nil, positiveCompletion: {
                self.openWifiSettings()
            }, negativeCompletion: nil)
            
            present(alert, animated: true)
        }
        else{
            releaseMenu()
            if Auth.auth().currentUser != nil{
                let alert = AlertService().alert(title: "הנך כבר מחובר", body: "אין צורך להתחבר שנית", btnAmount: 1, positive: "אישור", negative: nil, positiveCompletion: {
                    
                }, negativeCompletion: nil)
                self.present(alert, animated: true)
            }
            else{
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self.loginOrSignUpFunc()
                }
            }
        }
    }
    
    @IBAction func menuContactUs(_ sender: UIButton) {
        self.releaseMenu()
        self.performSegue(withIdentifier: "toAboutUs", sender: true)
    }
    
    @IBAction func menuPrivacyPolicy(_ sender: UIButton) {
        releaseMenu()
        guard let url = URL(string: "https://www.freeprivacypolicy.com/privacy/view/abc9d091521fca9bbaa40d2b6d075995") else {return}
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let id = segue.identifier else {return}
        if let dest = segue.destination as? ManageAppointmentViewController,
            id == "toManageAppointment", let appointment = sender as? Appointment{
            dest.appointment = appointment
        }
        else if let dest = segue.destination as? AboutUsViewController,
            id == "toAboutUs", let showContactUs = sender as? Bool{
            dest.scrollToContactUs = showContactUs
        }
    }
}


extension MainViewController: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let invalidCharacters = CharacterSet(charactersIn: "+0123456789").inverted
//        let text = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        return string.rangeOfCharacter(from: invalidCharacters) == nil
    }
}
