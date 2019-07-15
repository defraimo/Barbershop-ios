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

class DAO{
    static var shared = DAO()
    //database ref:
    var ref:DatabaseReference!
    //storage ref:
    let storage = Storage.storage()
    var verId:String?
    
    
    private init(){
        Auth.auth().languageCode = "il"
        ref = Database.database().reference()
    }
    
    func saveNewUser(_ user: User, uid:String){
        let name = user.fullName
        let number = user.number
        let email = user.email
        let gender = user.gender
        
        if email != ""{
        ref.child("Users").child(uid).setValue(["fullName": name ,
                                                       "gender": gender,
                                                       "number":number,
                                                       "email": email!])
        }else{
        ref.child("Users").child(uid).setValue(["fullName": name ,
                                                       "gender": gender,
                                                       "number":number])
        }
    }

    func getUser(_ uid:String) -> User?{
        var user:User?
        
        ref.child("Users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            guard let value = snapshot.value as? NSDictionary else {return}
            
            guard let name = value["fullName"] as? String,
                  let gender = value["gender"] as? Int,
                let number = value["number"] as? String else {print("shit");return}
            
            user = User(number: number, fullName: name, gender: gender, email: nil)
            // ...
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
}
