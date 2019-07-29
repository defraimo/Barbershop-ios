//
//  ShopTableViewController.swift
//  BarberShop
//
//  Created by Daniel Fraimovich on 15/07/2019.
//  Copyright © 2019 Neighbors. All rights reserved.
//

import UIKit

class ShopViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var products:[Product]?
    
    var isDetailsShownShop = false
    var chosenCellRowShop:Int?
    var infoOrCloseShop:UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
           
        let progressBar = UIActivityIndicatorView()
        progressBar.center = view.center
        self.view.addSubview(progressBar)
        
        //setting the background of the view
        view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        //setting the background of the table
        tableView.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)

        //set the info picture to "info" first
        infoOrCloseShop = #imageLiteral(resourceName: "info_icon")
        //hides the tableView while loading:
        tableView.isHidden = true
        
        progressBar.startAnimating()
        DAO.shared.getShopProducts {[weak self] (products) in
            //inserting the data
            self?.products = products
            //reloading the table:
            self?.tableView.reloadData()
            //stop the animation:
            progressBar.stopAnimating()
            //releasing the indicator:
            progressBar.removeFromSuperview()
            //showing the tableView with the info:
            self?.tableView.isHidden = false
            
        }
    }
}

extension ShopViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let cell = tableView.dequeueReusableCell(withIdentifier: "shopCell") as! ShopTableViewCell
        
        guard let checkedProducts = products else {return cell}
        
        let product = checkedProducts[indexPath.row]
        
        cell.productName.text = product.name
        cell.productPrice.text = product.realPrice
        cell.details.text = product.details
       
        cell.productImage.sd_setImage(with: URL(string: product.imagePath), placeholderImage: #imageLiteral(resourceName: "broken image"), options: [], progress: nil) { (image, err, cache, url) in
            cell.productImage.alpha = 1
        }
        cell.infoBtn.setImage(infoOrCloseShop, for: .normal)
        cell.infoBtn.tag = indexPath.row
        
        //added tapgesture to product image to open details when image pressed:
        
        cell.productImage.tag = indexPath.row
        let tap = UITapGestureRecognizer(target: self, action: #selector(showDetailsImage(_:)))
        cell.productImage.addGestureRecognizer(tap)
        
        cell.infoBtn.addTarget(self, action: #selector(showDetails(_:)), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == chosenCellRowShop && isDetailsShownShop{
            let cell = tableView.cellForRow(at: indexPath) as! ShopTableViewCell
            
            return 250 + cell.details.calculateLinesSize()
        }
        return 200
    }
    
    @objc func showDetails(_ sender:UIButton){
        //every press switch the buttons position
        isDetailsShownShop = !isDetailsShownShop
        //change the buttons images
        if isDetailsShownShop{
            infoOrCloseShop = #imageLiteral(resourceName: "close_icon")
            //set the current item that is pressed
            chosenCellRowShop = sender.tag
        }else{
            infoOrCloseShop = #imageLiteral(resourceName: "info_icon")
        }
        
        tableView.reloadRows(at: [IndexPath(row: chosenCellRowShop!, section: 0)], with: .automatic)
    }
    @objc func showDetailsImage(_ sender:UITapGestureRecognizer){
        //every press switch the buttons position
        isDetailsShownShop = !isDetailsShownShop
        //change the buttons images
        if isDetailsShownShop{
            infoOrCloseShop = #imageLiteral(resourceName: "close_icon")
            //set the current item that is pressed
            let imageView = sender.view as! UIImageView

            chosenCellRowShop = imageView.tag
        }else{
            infoOrCloseShop = #imageLiteral(resourceName: "info_icon")
        }
        
        tableView.reloadRows(at: [IndexPath(row: chosenCellRowShop!, section: 0)], with: .automatic)
    }

    
}

