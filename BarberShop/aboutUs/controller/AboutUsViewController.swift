//
//  AboutUsViewController.swift
//  BarberShop
//
//  Created by Daniel Radshun on 18/06/2019.
//  Copyright © 2019 Neighbors. All rights reserved.
//

import UIKit

class AboutUsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //setting the background
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
    }

}

var aboutUs = AboutUsData().aboutUsArr
var descriptionLine = DescriptionAboveBarbers().descriptionText
var barbers = AllBarbers.shared.allBarbers
var contactUs = ContactUs().contactDetails

let firstCount = aboutUs.count
let secondCount = descriptionLine.count
let thirdCount = barbers.count

extension AboutUsViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return firstCount + secondCount + thirdCount + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = indexPath.row
        
        if row < firstCount{
            let cell = tableView.dequeueReusableCell(withIdentifier: "aboutUsCell") as! AboutUsTableViewCell
            
            let aboutUsModel = aboutUs[indexPath.row]
            
            cell.titleLabel.text = aboutUsModel.title
            cell.descriptionLabel.text = aboutUsModel.text
            
            return cell
        }
        else if row < firstCount + secondCount{
            let cell = tableView.dequeueReusableCell(withIdentifier: "descriptionCell") as! DescriptionTableViewCell
            
            let stringText = descriptionLine[indexPath.row - firstCount]
            
            cell.descriptionLabel.text = stringText
            
            return cell
        }
        else if row < firstCount + secondCount + thirdCount{
            let cell = tableView.dequeueReusableCell(withIdentifier: "barberDescriptionCell") as! BarberDescriptionTableViewCell
            
            let barberModel = barbers[indexPath.row - firstCount - secondCount]
            
            cell.barberName.text = barberModel.name
            cell.barberDescription.text = barberModel.description
            cell.barberImage.image = barberModel.image
            
            cell.barberImage.layer.cornerRadius = 60
            cell.imageBackground.layer.cornerRadius = 10
            
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "contactUsCell") as! ContactUsTableViewCell
            
            cell.phoneButton.setTitle(contactUs[0], for: .normal)
            cell.emailButton.setTitle(contactUs[1], for: .normal)
            
            cell.phoneButton.addTarget(self, action: #selector(phoneButtonTapped(_:)), for: .touchDown)
            
            cell.emailButton.addTarget(self, action: #selector(emailButtonTapped(_:)), for: .touchDown)
            
            return cell
        }

    }
    
    @objc func phoneButtonTapped(_ sender:UIButton){
        let number = "0544533616"
        if let url = URL(string: "tel://\(number)") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @objc func emailButtonTapped(_ sender:UIButton){
        let email = "neighbors.apps@gmail.com"
        let mailURL = URL(string: "mailto:\(email)")!
        if UIApplication.shared.canOpenURL(mailURL) {
            UIApplication.shared.open(mailURL, options: [:], completionHandler: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let row = indexPath.row
        
        if row < firstCount{
            return 200
        }
        else if row < firstCount + secondCount{
            return 70
        }
        else if row < firstCount + secondCount + thirdCount{
            return 180
        }
        else{
            return 160
        }
    }
}
