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
    
    func testing(){
       
    }
}

//protocol for help writing data to firebase:
protocol DictionaryConvertible {
    init?(dict:NSDictionary)
    var dict:NSDictionary { get }
}
