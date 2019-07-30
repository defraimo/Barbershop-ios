
//  AlertService.swift
//  BarberShop
//
//  Created by Daniel Fraimovich on 25/07/2019.
//  Copyright © 2019 Neighbors. All rights reserved.
//

import UIKit

class AlertService{
    
    func alert(title: String, body: String, btnAmount:Int ,positive: String , negative: String?, positiveCompletion: (@escaping () -> Void), negativeCompletion: (() -> Void)?) -> AlertViewController{
        let storyBoard =  UIStoryboard(name: "Alert", bundle: nil)
        
        //init the viewController:
        let alertVc = storyBoard.instantiateViewController(withIdentifier: "AlertVc") as! AlertViewController
        
        alertVc.titleText = title
        alertVc.bodtText = body
        alertVc.btnAmount = btnAmount
        
        alertVc.positiveBtnText = positive
        alertVc.negativeBtnText = negative
        
        alertVc.positiveCompletion = positiveCompletion
        alertVc.negativeCompletion = negativeCompletion
        
        return alertVc
    }
    
}
