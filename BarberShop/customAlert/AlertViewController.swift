//
//  AlertViewController.swift
//  BarberShop
//
//  Created by Daniel Fraimovich on 25/07/2019.
//  Copyright © 2019 Neighbors. All rights reserved.
//

import UIKit

class AlertViewController: UIViewController {
    @IBOutlet weak var blur: UIVisualEffectView!
    
    @IBOutlet weak var titleLine: UIImageView!
    @IBOutlet weak var alertView: UIView!
    
    @IBOutlet weak var alertTitle: UILabel!
    @IBOutlet weak var alertBody: UILabel!
    @IBOutlet weak var positiveBtn: UIButton!
    @IBOutlet weak var negativeBtn: UIButton!
    @IBOutlet weak var btnSeperator: UIImageView!
    
    var titleText: String?
    var bodtText: String?
    var positiveBtnText: String?
    var negativeBtnText: String?
    var positiveCompletion:(() -> Void)?
    var negativeCompletion:(() -> Void)?
    var btnAmount:Int?
 
    
    override func viewDidLoad() {
        super.viewDidLoad()

        alertView.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        alertView.layer.shadowColor = UIColor.black.cgColor
        alertView.layer.shadowOffset = CGSize(width: 1, height: 1)
        alertView.layer.shadowRadius = 15
        alertView.layer.shadowOpacity = 0.5
        alertView.layer.masksToBounds = false

        //inserts all the info needed from the AlertService
        setupView()
        
        //depends on the choice from AlertService, the amount of buttons will be: 1 or 2
        guard let btnAmount = btnAmount else {return}
        if btnAmount == 1 {
            negativeBtn.alpha = 0
            negativeBtn.isHidden = true
            btnSeperator.alpha = 0
            btnSeperator.isHidden = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            UIView.animate(withDuration: 0.1) {
                self.blur.alpha = 1
            }
        }
       
    }
    
    func setupView(){
        alertTitle.text = titleText
        alertBody.text = bodtText
        positiveBtn.titleLabel?.text = positiveBtnText
        negativeBtn.titleLabel?.text = negativeBtnText
    }
    
    @IBAction func positive(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2) {
            self.blur.alpha = 0
        }
        dismiss(animated: true, completion: positiveCompletion)
    }
    
    @IBAction func negative(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2) {
            self.blur.alpha = 0
        }
        dismiss(animated: true, completion: negativeCompletion)
    }
    

}
