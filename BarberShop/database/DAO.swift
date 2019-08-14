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

    func getUser(_ uid:String, completion: @escaping (_ user: User?)-> Void){
        var user:User?
        
        ref.child("Users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            guard let value = snapshot.value as? NSDictionary else {return}
            user = User(dict: value)
        
            completion(user)

        }) { (error) in
           print(error.localizedDescription)
        }
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
    
    func checkUserExists(number:String, completion: @escaping (_ exists:Bool)-> Void){
        ref.child("Users").observeSingleEvent(of: .value) { (snapshot) in
           guard let allUsers =  snapshot.value as? NSDictionary else{return}
            
            for user in allUsers.allValues{
                guard let user = user as? NSDictionary,
                let userNumber = user.value(forKey: "number") as? String
                else {return}
                
                if userNumber == number{
                   completion(true)
                    return
                }
            }
            completion(false)
        }
    }
    
    func getShopProducts(completion: @escaping (_ products:[Product])-> Void){
        var products:[Product] = []
        ref.child("Products").observeSingleEvent(of: .value) { (data) in
            guard let allProducts = data.value as? NSArray else{return}
            
            for product in allProducts{
                guard let dictProduct = product as? NSDictionary,
                    let readyProduct = Product(dict: dictProduct) else {return}
                products.append(readyProduct)
            }
            completion(products)
        }
    }
    
    func checkMessageDialogue(completion: @escaping (_ message:String?) -> Void){
        ref.child("MessageDialog").observeSingleEvent(of: .value) { (data) in
            guard let value = data.value as? NSDictionary else{
                completion(nil)
                return
            }
            if let message = value["message"] as? String{
                completion(message)
            }
        }
    }
    
    func writeMessageForDialog(){
        ref.child("MessageDialog").setValue(["message": "היי, ברוכים הבאים למספרה שלנו! נשמח לראותכם אצלנו"])
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
        
        AllBarbers.shared.loadBarbers(allBarbers, complition: {
            NotificationCenter.default.post(name: .dataWereLoaded, object: nil, userInfo: ["isLoaded": true])
        })
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
        
        var avialibleDays:[AppointmentDate] = []
        var notificationDays:[AppointmentDate] = []
        
        for i in 0..<9{
            let current = CurrentDate()
            let currentDate = current.addToCurrentDate(numberOfDays: i)
            let currentWeekDay = current.currentDay + i
            
            //after getting from data base
            let timeAvailible = TimeManager(id: currentDate.generateId(), minTime: Time(hours: 11, minutes: 30), maxTime: Time(hours: 19, minutes: 0), intervals: 20, freeTime: [TimeRange(fromTime: Time(hours: 13, minutes: 0), toTime: Time(hours: 14, minutes: 0))])
            
            
            avialibleDays.append(AppointmentDate(id: currentDate.generateId(), date: currentDate, dayOfWeek: currentWeekDay, namedDayOfWeek: CurrentDate.namedDays[currentWeekDay%7], time:timeAvailible))
        }
        
        for i in 9..<16{
            let current = CurrentDate()
            let currentDate = current.addToCurrentDate(numberOfDays: i)
            let currentWeekDay = current.currentDay + i
            
            //after getting from data base
            notificationDays.append(AppointmentDate(id: currentDate.generateId(), date: currentDate, dayOfWeek: currentWeekDay, namedDayOfWeek: CurrentDate.namedDays[currentWeekDay%7], time:nil))
        }
        
        //get the barber from the data base
        allDates = AllDates(barberId: 1, availableDays: avialibleDays, notificationDays: notificationDays)
        
        
        ref.child("Dates").child("1").setValue(allDates!.dict)
    }

    func loadScheduleFor(barberId:Int, complition: @escaping (_ allDates:AllDates) -> Void){
        
        ref.child("Dates").child("\(barberId)").observeSingleEvent(of: .value, with: { (data) in
            guard let barbersDatesDict = data.value as? NSDictionary,
                let allDates = AllDates(dict: barbersDatesDict) else {return}
            
            complition(allDates)
        })
    }
    
    func writeAppoinment(_ appointment:Appointment){
        var unitsIndex:[Int] = []
        let updatedAppointment = appointment
        
        for i in 0..<updatedAppointment.units!.count{
            let unit = updatedAppointment.units![i]
            //add the unit index
            unitsIndex.append(unit.index)
            //set the unit availability to false
            updatedAppointment.units![i].isAvailable = false
        }
        self.ref.child("Appointments").child(String(updatedAppointment.clientId!)).setValue(updatedAppointment.dict)
        self.ref.child("AppointmentsDates").child(String(updatedAppointment.barber!.id)).child(String(updatedAppointment.date!.generateId())).child(updatedAppointment.clientId!).setValue(true)
    }
    
    func setAvailability(to bool:Bool, barber:Barber, dateId:Int, units:[TimeUnit], userId:String, complition: @escaping (_ availabilityChanged:Bool) -> Void){
        let barberId = barber.id
        
        var unitsIndex:[Int] = []
        for unit in units{
            unitsIndex.append(unit.index)
        }
         ref.child("Dates").child("\(barberId)").child("availableDays").child("\(dateId)").child("units").observeSingleEvent(of: .value, with: { (data) in
                guard let unitDictArray = data.value as? [NSDictionary] else {return}
                
                var areUnitsAvailable:Bool = !bool
                var dataUnitsIndex:[Int] = []
                
                for u in 0..<unitDictArray.count{
                    if let unit = TimeUnit(dict: unitDictArray[u]){
                        for index in unitsIndex{
                            if unit.index == index{
                                dataUnitsIndex.append(u)
                                if unit.isAvailable == bool{
                                    areUnitsAvailable = unit.isAvailable
                                }
                            }
                        }
                    }
                }
            
                if areUnitsAvailable != bool{
                
                for index in dataUnitsIndex{
                    let path = self.ref.child("Dates").child("\(barberId)").child("availableDays").child("\(dateId)").child("units").child("\(index)")
                    
                    path.child("isAvailable").setValue(bool)
                    
                    if bool{
                        path.child("user").removeValue()
                    }
                    else{
                        path.child("user").setValue(userId)
                    }
                }
                }
            
                complition(areUnitsAvailable)
        })
        
    }
    
    func getAppointment(userId:String, complition: @escaping (_ appointment:Appointment, _ isExist:Bool) -> Void){
        ref.child("Appointments").child(userId).observeSingleEvent(of: .value) { (data) in
            guard let dict = data.value as? NSDictionary else {
                complition(Appointment(), false)
                return
            }

            let appointment = Appointment(dict: dict)
            
            complition(appointment!, true)
        }
    }
    
    func eraseAppointment(userId:String, appointment:Appointment, removeFromAppointments:Bool){
        if removeFromAppointments{
            ref.child("Appointments").child(userId).removeValue()
        }
        
//        let path = ref.child("Dates").child("\(appointment.barber!.id)").child("availableDays").child("\(appointment.date!.generateId())").child("units")
//
//        let units = appointment.units!
        
        setAvailability(to:true, barber: appointment.barber!, dateId: appointment.date!.generateId(), units: appointment.units!, userId: appointment.clientId!) { (_) in
            
        }
        
        //removing the appointment from AppointmentsDates field in firebase
    ref.child("AppointmentsDates").child(String(appointment.barber!.id)).child(String(appointment.date!.generateId())).child(userId).removeValue()
        
//        for unit in units{
//            //set the units that was taken to available again
//            path.child("\(unit.index)").child("isAvailable").setValue(true)
//            //erase the user name that written in the unit
//            path.child("\(unit.index)").child("user").removeValue()
//        }
    }
    
    func writeAboutUs(){
        let aboutUs = AboutUs(title: "על המספרה", text: "המספרה הוקמה ב2018 מנוהלת על ידי חברת \"Neighbors\". המספרה מספרת נשים וגברים במצועיות ונאמנות ומגיעה לתוצאות הטובות ביותר. שלל שירותי הסמפרה כוללים: תספורת, עיצוב זקן, צביעה, פן, החלקה, סלסול ועוד..")
        
        ref.child("Info").child("AboutUs").setValue(aboutUs.dict)
    }
    
    func readAboutUs(complition: @escaping (_ aboutUs:AboutUs) -> Void){
        ref.child("Info").child("AboutUs").observeSingleEvent(of: .value) { (data) in
            guard let aboutUsDict = data.value as? NSDictionary,
                let aboutUs = AboutUs(dict: aboutUsDict) else {return}
            
            complition(aboutUs)
        }
    }
    
    func writeDescriptionAboveBarbers(){
        let descriptionText = DescriptionAboveBarbers(descriptionText: "הספרים שלנו")
        ref.child("Info").child("DescriptionAboveBarbers").setValue(descriptionText.dict)
    }
    
    func readDescriptionAboveBarbers(complition: @escaping (_ descriptionText:DescriptionAboveBarbers) -> Void){
        ref.child("Info").child("DescriptionAboveBarbers").observeSingleEvent(of: .value) { (data) in
            guard let dict = data.value as? NSDictionary,
                let descriptionText = DescriptionAboveBarbers(dict: dict) else {return}
            
            complition(descriptionText)
        }
    }
    
    func writeContactUs(){
        let contactUs = ContactUs(phone: "0544533616", email: "neighbors.apps@gmail.com", instagramName: "daniel_radshun")
        ref.child("Info").child("ContactUs").setValue(contactUs.dict)
    }

    func readContactUs(complition: @escaping (_ contactUs:ContactUs) -> Void){
        ref.child("Info").child("ContactUs").observeSingleEvent(of: .value) { (data) in
            guard let dict = data.value as? NSDictionary,
                let contactUs = ContactUs(dict: dict) else {return}

            complition(contactUs)
        }
    }
    
    func writeSliderImages(){
        storageRef.child("sliderShowImages").child("switching_pic1.jpg").downloadURL { (url, error) in
            let image1 = SliderImage(index: 0, imagePath: url!.absoluteString)
            
            self.storageRef.child("sliderShowImages").child("switching_pic2.jpg").downloadURL { (url, error) in
                let image2 = SliderImage(index: 1, imagePath: url!.absoluteString)
                
                self.storageRef.child("sliderShowImages").child("switching_pic3.jpeg").downloadURL { (url, error) in
                    let image3 = SliderImage(index: 2, imagePath: url!.absoluteString)
                    
                    let images = [image1,image2,image3]
                    
                    for i in images{
                        self.ref.child("SliderImages").child(String(i.index)).setValue(i.dict)
                    }
                }
            }
        }
    }
    
    func loadSliderImages(completion: @escaping (_ sliderImages:[SliderImage]) -> Void){
        var sliderImages:[SliderImage] = []
        ref.child("SliderImages").observeSingleEvent(of: .value) { (data) in
            guard let sliderImagesDictArr = data.value as? NSArray else {return}
            
            for sliderImageDict in sliderImagesDictArr{
                if let sliderImageDict = sliderImageDict as? NSDictionary,
                    let sliderImage = SliderImage(dict: sliderImageDict){
                    sliderImages.append(sliderImage)
                }
            }
            
            completion(sliderImages)
        }
    }
    
    func writeLocation(address: NSDictionary){
        ref.child("Location").setValue(address)
    }
    func getLocation(completion: @escaping (_ location:Address?)-> Void){
        ref.child("Location").observeSingleEvent(of: .value) { (data) in
            guard let value = data.value as? NSDictionary else {return}
            let address = Address(dict: value)
            
            completion(address)
        }
    }
}

extension Notification.Name{
    static let dataWereLoaded = Notification.Name(rawValue: "dataWereLoaded")
}

//protocol for help writing data to firebase:
protocol DictionaryConvertible {
    init?(dict:NSDictionary)
    var dict:NSDictionary { get }
}
