//
//  DAO.swift
//  BarberShop
//
//  Created by Daniel Fraimovich on 09/07/2019.
//  Copyright © 2019 Neighbors. All rights reserved.
//


import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage
import SDWebImage

class DAO{
    static var shared = DAO()
    //database ref:
    var ref:DatabaseReference!
    //storage ref:
    let storageRef = Storage.storage().reference()
    var verId:String?
    
    
    private init(){
        Auth.auth().languageCode = "il"
        ref = Database.database().reference()
    }
    
    func saveNewUser(_ user: User, uid:String){
        ref.child("Users").child(uid).setValue(user.dict)
    
    }

    func getUser(_ uid:String) -> User?{
        var user:User?
        
        ref.child("Users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            guard let value = snapshot.value as? NSDictionary else {return}
            
            user = User(dict: value)
        
        }) { (error) in
           print(error.localizedDescription)
        }
        return user
    }
    
    func getVerificationId(_ userNumber:String){
        //IL number:
        let number = "+972\(userNumber)"
        
        PhoneAuthProvider.provider().verifyPhoneNumber(number, uiDelegate: nil) { (verId, err) in
            //saving the verification id for if the user breaks the verification flow:
            UserDefaults.standard.set(verId, forKey: "authVerificationID")
        }
    }
    
    func verifyUser(_ code:String, completion: @escaping ()-> Void){
        //verification id: (not verification code!)
        guard let verificationID = UserDefaults.standard.string(forKey: "authVerificationID") else{return}
        
        //setting up the credential for signing in:
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID,
            verificationCode: code)
        
        Auth.auth().signIn(with: credential) { (result, error) in
            completion()
        }
        
    }
    
    func getPicsForShop(){
        let photosRef = storageRef.child("shopPhotos").fullPath
    }
    
    
    fileprivate func writingBarbersToData() {
        var barber = Barber(name: "דניאל", id: 0, description: "ספר גברים, 3 שנים ניסיון בתחום. מתמקצע בדירוגים ובשלל התספורות השונות המודרניות והחדשניות ביותר.", image: nil, imagePath:"0")
        ref.child("Barbers").childByAutoId().setValue(barber.dict)
        
        barber = Barber(name: "דניאל", id: 1, description: "ספר גברים ונשים, שנתיים ניסיון בתחום. יודע לעבוד עם כל סוגי השיער, התאמה אישית של תספורת וצבע לכל לקוח.", image: nil, imagePath:"1")
        ref.child("Barbers").childByAutoId().setValue(barber.dict)
        
        barber = Barber(name: "אור", id: 2, description: "ספר גברים, מוותיקי המספרה, 6 שנים בתחום. יודע לספר במדיוק לבקשת הלקוח, מתמקצע בצביעה ובציורים מיוחדים.", image: nil, imagePath:"2")
        ref.child("Barbers").childByAutoId().setValue(barber.dict)
        
        barber = Barber(name: "מתן", id: 3, description: "ספר נשים, שנתיים ניסיון בתחום. מתמקצע בתספורות נשים, סלסולים, החלקות, תסרוקות ערב וצביעה.", image: nil, imagePath:"3")
        ref.child("Barbers").childByAutoId().setValue(barber.dict)
    }
    
    var areImagesSaved:[Bool]?
    var numOfChanges = 0
    var allBarbers:[Barber] = []

    //completion: @escaping (_ barber:[Barber]) -> Void
    
    func loadBarbersfromFirebase() {
        
//        writingBarbersToData()
        
        areImagesSaved = []
        
        ref.child("Barbers").observeSingleEvent(of: .value, with: { (data) in
            guard let barbersDict = data.value as? NSDictionary else {return}
            let barbersArray = barbersDict.allValues
            for barber in barbersArray{
                guard let barber = barber as? NSDictionary,
                    let barberFromData = Barber(dict: barber) else {return}
                self.allBarbers.append(barberFromData)
            }
            
            if self.allBarbers.count > 0{
                //sort the barbers by their id
                self.allBarbers.sort(by: { $0.id < $1.id })
            }
            
            var isDataChanged = false
            
            //if the barbers are already exist
            if let barbersData = UserDefaults.standard.object(forKey: "barbers") as? Data{
                
                let barbers = try! JSONDecoder().decode([Barber].self, from: barbersData)
                                
                for barber in self.allBarbers{
                    
                    if barbers.contains(barber) == false{ //update
                        
                        self.numOfChanges += 1
                        
                        let fileName =  barber.imagePath ?? "-1" //there is no image to the barber
                        
                        // Create a reference to the file you want to download
                        let imageRef = self.storageRef.child("barbersImages/\(fileName).jpg")
                        
                        var imageFromData:UIImage?
                        
                        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
                        imageRef.getData(maxSize: 2 * 1024 * 1024) { data, error in
                            if let error = error {
                                print(error)
                            } else {
                                // Data for image is returned
                                imageFromData = UIImage(data: data!)
                                guard let image = imageFromData else {return}
                                self.saveImage(image: image, fileName: fileName)
                            }
                        }
                        
                        isDataChanged = true
                    }
                }
                
                if isDataChanged{
                    let dataBarbers = try! JSONEncoder().encode(self.allBarbers)
                    UserDefaults.standard.set(dataBarbers, forKey: "barbers")
                }

            }
            else{ //barbers are not written in the phone so we write all the images in it
                
                for barber in self.allBarbers{
                    
                    self.numOfChanges += 1
                    
                    let fileName =  barber.imagePath ?? "-1" //there is no image to the barber
                    
                    // Create a reference to the file you want to download
                    let imageRef = self.storageRef.child("barbersImages/\(fileName).jpg")

                    var imageFromData:UIImage?

                    // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
                    imageRef.getData(maxSize: 2 * 1024 * 1024) { data, error in
                        if let error = error {
                            print(error)
                        } else {
                            // Data for image is returned
                            imageFromData = UIImage(data: data!)
                            guard let image = imageFromData else {return}
                            self.saveImage(image: image, fileName: fileName)
                        }
                    }

                }
                
                isDataChanged = true

                //we also write all the barbers to the user defaults
                let dataBarbers = try! JSONEncoder().encode(self.allBarbers)
                UserDefaults.standard.set(dataBarbers, forKey: "barbers")

            }
            
            Timer.scheduledTimer(timeInterval: 0.25, target: self, selector:#selector(self.checkIfAllImagesWereLoaded), userInfo: nil, repeats: true)

        })
        
    }
    
    @objc func checkIfAllImagesWereLoaded(_ timer:Timer){
        if self.areImagesSaved!.count == numOfChanges{
            timer.invalidate()
            //stop checking
            loadImageIntoBarber()
        }
    }
    
    
    //allBarbers:[Barber], complition: @escaping (_ barbers:[Barber]) -> Void
    func loadImageIntoBarber(){
        for barber in allBarbers{
            
            let fileName =  barber.imagePath ?? "-1" //there is no image to the barber
            
            //load all the inages from the phone data to the barbers
            if let image = self.loadImage(named: "\(fileName).jpg") {
                barber.image = image
            }
            
        }
        
        AllBarbers.shared.loadBarbers(allBarbers)
    }
    
    func saveImage(image: UIImage, fileName:String){
        let fileUrl = "\(fileName).jpg"
        guard let data = image.jpegData(compressionQuality: 1) ?? image.pngData() else {return}
        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {return}
        do {
            try data.write(to: directory.appendingPathComponent(fileUrl)!)
            //saved
            self.areImagesSaved?.append(true)
        } catch {
            print(error.localizedDescription)
            self.areImagesSaved?.append(false)
        }
    }
    
    func loadImage(named: String) -> UIImage? {
        if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            //loading succssed
            return UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(named).path)
        }
            //loading failed
        return nil
    }
    
    func writePrices(){
        let prices = [PriceModel(id: 0, servies: "תספורת", priceRange: PriceRange(lowestPrice: 40, heighestPrice: nil), duration: 20, barbersIndex: nil),
                      PriceModel(id: 1, servies: "תספורת ילדים", priceRange: PriceRange(lowestPrice: 35, heighestPrice: nil), duration: 20, barbersIndex: nil),
                      PriceModel(id: 2, servies: "תספורת + זקן", priceRange: PriceRange(lowestPrice: 50, heighestPrice: nil), duration: 20, barbersIndex: [0,1,2]),
                      PriceModel(id: 3, servies: "צבע", priceRange: PriceRange(lowestPrice: 80, heighestPrice: 100), duration: 25, barbersIndex: [1,3]),
                      PriceModel(id: 4, servies: "תספורת + צבע", priceRange: PriceRange(lowestPrice: 110, heighestPrice: 130), duration: 45, barbersIndex: [1,3]),
                      PriceModel(id: 5, servies: "גוונים", priceRange: PriceRange(lowestPrice: 70, heighestPrice: 80), duration: 30, barbersIndex: nil),
                      PriceModel(id: 6, servies: "תספורת + גוונים", priceRange: PriceRange(lowestPrice: 90, heighestPrice: 110), duration: 50, barbersIndex: [3])]
        
        for price in prices{
            ref.child("Prices").childByAutoId().setValue(price.dict)
        }
    }
    
    func loadPrices(complition: @escaping (_ prices:[PriceModel]) -> Void){
        var allPrices:[PriceModel] = []
        ref.child("Prices").observeSingleEvent(of: .value, with: { (data) in
            guard let pricesDict = data.value as? NSDictionary else {return}
            let pricesArray = pricesDict.allValues
            for price in pricesArray{
                guard let price = price as? NSDictionary,
                    let priceFromData = PriceModel(dict: price) else {return}
                allPrices.append(priceFromData)
            }
            complition(allPrices)
        })
    }
    
    func writeSchedule(){
        var allDates:AllDates?
        var displayedDates:[AppointmentDate]?
        var avialibleDaysCount:Int = 0
        var notificationDaysCount:Int = 0
        
        var avialibleDays:[AppointmentDate] = []
        var notificationDays:[AppointmentDate] = []
        
        for i in 0..<10{
            
            let current = CurrentDate().addToCurrentDate(numberOfDays: i)
            
            //after getting from data base
            let timeAvailible = TimeManager(id: current.generateId(), minTime: Time(hours: 11, minutes: 30), maxTime: Time(hours: 19, minutes: 0), intervals: 20, freeTime: [TimeRange(fromTime: Time(hours: 13, minutes: 0), toTime: Time(hours: 14, minutes: 0))])
            
            
            avialibleDays.append(AppointmentDate(id: current.generateId(), date: current, dayOfWeek: i, namedDayOfWeek: CurrentDate.namedDays[i%7], time:timeAvailible))
        }
        
        for i in 10..<16{
            let current = CurrentDate().addToCurrentDate(numberOfDays: i)
            //after getting from data base
            notificationDays.append(AppointmentDate(id: current.generateId(), date: current, dayOfWeek: i, namedDayOfWeek: CurrentDate.namedDays[i%7], time:nil))
        }
        
        //get the barber from the data base
        allDates = AllDates(barberId: 1, availableDays: avialibleDays, notificationDays: notificationDays)
        
        displayedDates = allDates?.getDisplayedDates()
        
        
        avialibleDaysCount = avialibleDays.count
        notificationDaysCount = notificationDays.count
        
        ref.child("Dates").child("1").setValue(allDates!.dict)
        
    }
    
    func loadScheduleFor(barberId:Int, complition: @escaping (_ allDates:AllDates) -> Void){
        
        ref.child("Dates").observeSingleEvent(of: .value, with: { (data) in
            guard let allBarbersDatesDict = data.value as? [NSDictionary],
                let allDates = AllDates(dict: allBarbersDatesDict[barberId]) else {return}
            
            complition(allDates)
        })
    }
        
}

//protocol for help writing data to firebase:
protocol DictionaryConvertible {
    init?(dict:NSDictionary)
    var dict:NSDictionary { get }
}
