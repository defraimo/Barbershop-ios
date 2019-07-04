//
//  SingUPViewController.swift
//  BarberShop
//
//  Created by Daniel Fraimovich on 01/07/2019.
//  Copyright © 2019 Neighbors. All rights reserved.
//

import UIKit

class SingUPViewController: UIViewController {
    var isGenderPicked = false

    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var genderPick: UISegmentedControl!
    @IBAction func genderPicked(_ sender: UISegmentedControl) {
        isGenderPicked = true
        genderPick.tintColor = UIColor.white
    }
    
    //outlet for animation:
    @IBOutlet weak var signupBtn: UIButton!
    @IBAction func signup(_ sender: UIButton) {
        if !isGenderPicked{
            genderPick.tintColor = UIColor.red
        }else{
            dismiss(animated: true) {
                //getting the reference to mainViewController:
                guard let mainVC = UIApplication.shared.keyWindow?.rootViewController?.children[0] as? MainViewController else {return}
                //presenting the send code view after done dismiossing:
                mainVC.presentAuthCodeView()
            }
        }
    }
    
  
    @IBAction func cancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
            pageDesign()
    }
    
    fileprivate func pageDesign(){
        //controller background color:
        view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)

        //placeholder color to white:
        let textfields = [phoneField!, nameField!, emailField!]
        for textField in textfields{
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
}
