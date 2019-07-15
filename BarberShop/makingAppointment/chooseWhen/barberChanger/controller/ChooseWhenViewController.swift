//
//  ChooseWhenViewController.swift
//  BarberShop
//
//  Created by Daniel Radshun on 21/06/2019.
//  Copyright © 2019 Neighbors. All rights reserved.
//

import UIKit

class ChooseWhenViewController: UIViewController {
    
    var barbers:[Barber]?
    
    var scheduleData:ScheduleData?
    var datesForBarber:[AppointmentDate]?
    var timeForChosenDay:[TimeUnit]?
    
    //check if the first barber is already loaded from the code so it won't be loaded in the first swipe while passing between two barbers
    var firstAlreadyLoaded = false
    
    var passedPointX:CGFloat?
    var passedPointY:CGFloat?
    var chosenBarberImage:UIImageView?
    var chosenBarberIndex:IndexPath?
    
    var cellWasReloaded:[Bool] = []
    
    @IBOutlet weak var datePicker: UIPickerView!
    @IBOutlet weak var timePicker: UIPickerView!
    
    @IBOutlet weak var timeView: UIView!
    @IBOutlet weak var timeViewHeight: NSLayoutConstraint!
    @IBOutlet weak var timeViewLabel: UILabel!
    
    @IBOutlet weak var sendMeNotificationView: UIView!
    @IBOutlet weak var sendMeNotificationHeight: NSLayoutConstraint!
    
    @IBOutlet weak var scheduleButton: UIButton!
    @IBOutlet weak var sendNotificationButton: UIButton!
    
    @IBOutlet weak var barbersCollection: UICollectionView!
    @IBOutlet weak var arrowRight: UIImageView!
    @IBOutlet weak var arrowLeft: UIImageView!
    @IBAction func arrowRightTapped(_ sender: UITapGestureRecognizer) {
        if chosenBarberIndex!.row < barbers!.count{
            chosenBarberIndex!.row += 1
            barbersCollection.scrollToItem(at: IndexPath(row: chosenBarberIndex!.row, section: 0), at: .right, animated: true)
        }
        if chosenBarberIndex!.row == barbers!.count - 1{
            UIView.animate(withDuration: 0.1) {
                self.arrowRight.alpha = 0
            }
        }
        else if arrowLeft.alpha == 0{
            UIView.animate(withDuration: 0.1) {
                self.arrowLeft.alpha = 0.3
            }
        }
    }
    @IBAction func arrowLeftTapped(_ sender: UITapGestureRecognizer) {
        if chosenBarberIndex!.row > 0{
            chosenBarberIndex!.row -= 1
            barbersCollection.scrollToItem(at: IndexPath(row: chosenBarberIndex!.row, section: 0), at: .right, animated: true)
        }
        if chosenBarberIndex!.row == 0{
            UIView.animate(withDuration: 0.1) {
                self.arrowLeft.alpha = 0
            }
        }
        else if arrowRight.alpha == 0{
            UIView.animate(withDuration: 0.1) {
                self.arrowRight.alpha = 0.3
            }
        }
    }
    
    @IBAction func schedule(_ sender: UIButton) {
        performSegue(withIdentifier: "toSumUp", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let dest = segue.destination as? SumUpViewController, let id = segue.identifier else {return}
        
        //set the navigation back item title of the next screen
        let backItem = UIBarButtonItem()
        backItem.title = "בחירת תור"
        navigationItem.backBarButtonItem = backItem
        
        if id == "toSumUp"{
            
        }
    }
    
    
    fileprivate func imageEntryAnimation() {
        
        //set all the vies to invisible
        for view in view.subviews{
            view.alpha = 0
        }
        
        //scroll the collaction view to the chosen barber posiotion from the lase screen
        barbersCollection.scrollToItem(at: chosenBarberIndex!, at: .centeredHorizontally, animated: false)
        
        //----------------------------------------------
        //TODO FIX THE MOVING INTO THE SELECTED BARBER
        //----------------------------------------------
        
        //getting the position of the current item
        let collectionPosition = barbersCollection.layoutAttributesForItem(at: chosenBarberIndex!)?.center ?? barbersCollection.center
        
        //find the collactionView position in the global view
        let pointInGlobalView = barbersCollection.convert(collectionPosition, to: view)
        
        //if there is only one barber so the image is not passed
        if imageView != nil {
            //add the imageView that passes from the last screen to the view
            self.view.addSubview(imageView!)
        }
        
        //animate the imageView
        UIView.animate(withDuration: 0.3, animations: {
            imageView?.center = pointInGlobalView
            imageView?.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            imageView?.alpha = 0.4
        }) { (_) in
            //animate all the views to fade in
            UIView.animate(withDuration: 0.05, animations: {
                self.barbersCollection.alpha = 1
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                    for view in self.view.subviews{
                        if ((view as? UIImageView) != nil){
                            //setting the arrows to invisble if they are at the first or last index
                            if self.chosenBarberIndex!.row == 0 && view.tag == 0 ||
                                self.chosenBarberIndex!.row == self.barbers!.count - 1 && view.tag == 1{
                                view.alpha = 0
                            }
                            else {
                                //set the arrows alpha to 0.3 for a design reasons
                                view.alpha = 0.3
                            }
                            
                        }
                        else{
                            view.alpha = 1
                        }
                        //check if the working time is set atleast on the first day
                        if self.timeForChosenDay?.count != 0{
                            //animate the timeView
                            self.timeViewHeight.constant = self.view.frame.height / 2.5
                            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 20, options: [], animations: {
                                self.view.layoutIfNeeded()
                            })
                        }
                        else{
                            //animate the sendMeNotificationView
                            self.sendMeNotificationHeight.constant = self.view.frame.height / 3.2
                            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 14, options: [], animations: {
                                self.view.layoutIfNeeded()
                            })
                        }
                    }
                })
            })
            //remove the image from the view
            imageView?.removeFromSuperview()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //load the data for the chosen barber
        scheduleData = ScheduleData(barber: barbers![chosenBarberIndex?.row ?? 0])
        
        //load all the days of the cirrent barber
        fetchDatesForCurrentBarber()
        
        //load the time for the first shown day
        fetchTimeForChosenDay(index: 0)
        
        //setting the background
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
        
       imageEntryAnimation()
        
        //set the picker date array to the chosen barber from the last screen
        let chosenRow = chosenBarberIndex!.row
//        currentlyShownSchedule = barbersSchedule[chosenRow]
//        currentlyDaysNamed = currentlyShownSchedule?.namedDays
//        avialibleTimeForChosenDay = currentlyDaysNamed![chosenRow].timeAvialible?.workingHours
        
        //set the current cell index to false so it won't be realoded more then 1 time
        if barbers != nil{
            for i in 0..<barbers!.count{
                if i == chosenRow{
                    cellWasReloaded.append(true)
                }
                else{
                    cellWasReloaded.append(false)
                }
            }
        }
        
        //scroll to see the collection item in the middle
        self.barbersCollection.scrollToNearestVisibleCollectionViewCell()
        
        //set the timeView background and corner radius
        timeView.backgroundColor = UIColor(patternImage: UIImage(named: "green_background.png")!)
        timeView.layer.cornerRadius = 22
        
        //set the sendMeNotificationView background and corner radius
        sendMeNotificationView.backgroundColor = UIColor(patternImage: UIImage(named: "green_background.png")!)
        sendMeNotificationView.layer.cornerRadius = 22
        
        //set the buttons to sqaure rounded white outlines
        scheduleButton.setRoundedSquareToWhite()
        sendNotificationButton.setRoundedSquareToWhite()
        
        //setting the label size to be responsive
        timeViewLabel.adjustsFontSizeToFitWidth = true
        timeViewLabel.minimumScaleFactor = 0.2
        
        //setting the size of the barberCollection cell
        let layout = self.barbersCollection.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.itemSize = CGSize(width: self.view.frame.width, height: self.view.frame.height*0.13)
        
        }
    
    func fetchDatesForCurrentBarber(){
        datesForBarber = scheduleData?.getDisplayedDates()
    }
    
    func fetchTimeForChosenDay(index:Int){
        timeForChosenDay = scheduleData?.getDisplayTimeFor(dateIndex: index)
//        timeForChosenDay = scheduleData?.getDisplayTimeUnitsWith(intervals: 40, forDateIndex: index)
    }
   
}

private let reuseIdentifier = "barberChooseCell"

extension ChooseWhenViewController: UICollectionViewDataSource,UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return barbers?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! BarberChangeCollectionViewCell
        
        let barber = barbers![indexPath.row]
        
        cell.populate(barber:barber)
        
        var delay = 0.4
        var duration = 0.2
        
        //if there is only one barber so the image is not passed
        if imageView == nil{
            delay = 0
            duration = 0.4
        }
        
        //animate a little spring motion when created
        UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: 0.5, initialSpringVelocity: 20, options: [], animations: {
            cell.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        })
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let visible = barbersCollection.indexPathsForVisibleItems
        
        guard visible.count == 1 else {
            return
        }
        
        let visibleRow = visible.first!.row

        //set the arrows visability
        setArrowsAlpha(visibleRow)
        
        if cellWasReloaded[visibleRow] == false && firstAlreadyLoaded{
        
            //set the picker date array to the chosen barber from the collectionView
//            currentlyShownSchedule = barbersSchedule[visibleRow]
//            currentlyDaysNamed = currentlyShownSchedule?.namedDays
            scheduleData = ScheduleData(barber: barbers![visibleRow])
            fetchDatesForCurrentBarber()
            fetchTimeForChosenDay(index: 0)
            
            chosenBarberIndex = visible.first!
            
            UIView.animate(withDuration: 0.3, animations: {
                self.datePicker.alpha = 0
            }) { (_) in
                UIView.animate(withDuration: 0.3, animations: {
                    self.datePicker.alpha = 1
                })
                self.datePicker.reloadAllComponents()
                self.timePicker.reloadAllComponents()
            }
            
            for i in 0..<barbers!.count{
                if i == visibleRow{
                    cellWasReloaded[i] = true
                }
                else{
                    cellWasReloaded[i] = false
                }
            }
        }
        else{
            firstAlreadyLoaded = true
        }
        
//        guard let attrs = barbersCollection.layoutAttributesForItem(at: visible[0]) else {return}
        
        
//        let x = barbersCollection.layoutAttributesForItem(at: IndexPath(item: 1, section: 0))?.frame.origin.x
        
//        guard let layout = self.barbersCollection.collectionViewLayout as? UICollectionViewFlowLayout else {return}
        
    }
    
    fileprivate func setArrowsAlpha(_ visibleRow: Int) {
        if visibleRow == barbers!.count - 1{
            UIView.animate(withDuration: 0.1) {
                self.arrowRight.alpha = 0
                if self.arrowLeft.alpha == 0{
                    self.arrowLeft.alpha = 0.3
                }
            }
        }
        else if visibleRow == 0{
            UIView.animate(withDuration: 0.1) {
                self.arrowLeft.alpha = 0
                if self.arrowRight.alpha == 0{
                    self.arrowRight.alpha = 0.3
                }
            }
        }
        else{
            UIView.animate(withDuration: 0.1) {
                if self.arrowLeft.alpha == 0{
                    self.arrowLeft.alpha = 0.3
                }
                if self.arrowRight.alpha == 0{
                    self.arrowRight.alpha = 0.3
                }
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.barbersCollection.scrollToNearestVisibleCollectionViewCell()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            self.barbersCollection.scrollToNearestVisibleCollectionViewCell()
        }
    }
    
}

extension UICollectionView {
    func scrollToNearestVisibleCollectionViewCell() {
        self.decelerationRate = UIScrollView.DecelerationRate.fast
        let visibleCenterPositionOfScrollView = Float(self.contentOffset.x + (self.bounds.size.width / 2))
        var closestCellIndex = -1
        var closestDistance: Float = .greatestFiniteMagnitude
        for i in 0..<self.visibleCells.count {
            let cell = self.visibleCells[i]
            let cellWidth = cell.bounds.size.width
            let cellCenter = Float(cell.frame.origin.x + cellWidth / 2)
            
            // Now calculate closest cell
            let distance: Float = fabsf(visibleCenterPositionOfScrollView - cellCenter)
            if distance < closestDistance {
                closestDistance = distance
                closestCellIndex = self.indexPath(for: cell)!.row
            }
        }
        if closestCellIndex != -1 {
            self.scrollToItem(at: IndexPath(row: closestCellIndex, section: 0), at: .centeredHorizontally, animated: true)
        }
    }
}

extension ChooseWhenViewController:UICollectionViewDelegateFlowLayout{
    
}

//let barbersSchedule = BarbersSchedule().allBarbersShedule
//
//var currentlyShownSchedule:DatesManager?
//var currentlyDaysNamed:[DayData]?
//var avialibleTimeForChosenDay:[Time]?

extension ChooseWhenViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        if pickerView.tag == 1{
//            return currentlyDaysNamed?.count ?? 0
//        }
//        else{
//           return avialibleTimeForChosenDay?.count ?? 0
//        }
        if pickerView.tag == 1{
            return datesForBarber?.count ?? 0
        }
        else{
            return timeForChosenDay?.count ?? 0
        }
    }
    
    //set the picker components into label and setting the data inside
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView{
        //init the label
        let pickerLabel = UILabel()
        pickerLabel.textAlignment = NSTextAlignment.center
        
        if pickerView.tag == 1{
            pickerLabel.font = UIFont(name: "SinhalaSangamMN", size: 24)
            
//            if row < currentlyShownSchedule!.daysAvailable{
//                pickerLabel.text = currentlyDaysNamed![row].description
//                pickerLabel.textColor = UIColor.white
//
//                //UIColor(red: 166/255, green: 243/255, blue: 208/255, alpha: 250/255)
//            }
//            else{
//                pickerLabel.text = currentlyDaysNamed![row].description
//                pickerLabel.textColor = UIColor(red: 255/255, green: 110/255, blue: 100/255, alpha: 250/255)
//            }
            guard let avialibleDaysCount = scheduleData?.avialibleDaysCount
                else {return pickerLabel}
            
            if row < avialibleDaysCount{
                pickerLabel.text = datesForBarber![row].description
                pickerLabel.textColor = UIColor.white
            }
            else{
                pickerLabel.text = datesForBarber![row].description
                pickerLabel.textColor = UIColor(red: 255/255, green: 110/255, blue: 100/255, alpha: 250/255)
            }
        }
        else{
            pickerLabel.text = timeForChosenDay?[row].description
            pickerLabel.font = UIFont(name: "SinhalaSangamMN-Bold", size: 24)
            pickerLabel.textColor = #colorLiteral(red: 0.2299421132, green: 0.2285816669, blue: 0.2309920788, alpha: 1)
        }
        return pickerLabel
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        if pickerView.tag == 1{
//            avialibleTimeForChosenDay = currentlyDaysNamed![row].timeAvialible?.workingHours
//
//            if avialibleTimeForChosenDay != nil{
//                UIView.animate(withDuration: 0.3, animations: {
//                    self.sendMeNotificationHeight.constant = 0
//                    self.timeViewHeight.constant = self.view.frame.height / 3.5
//                }) { (_) in
//                    self.timeViewHeight.constant = self.view.frame.height / 2.5
//                    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 14, options: [], animations: {
//                        self.view.layoutIfNeeded()
//                    }, completion: { (_) in
//                        self.timePicker.reloadAllComponents()
//                    })
//                }
//            }
//            else{
//                UIView.animate(withDuration: 0.3, animations: {
//                    self.sendMeNotificationHeight.constant = 0
//                    self.timeViewHeight.constant = 0
//                }) { (_) in
//                    self.sendMeNotificationHeight.constant = self.view.frame.height / 3.2
//                    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 14, options: [], animations: {
//                        self.view.layoutIfNeeded()
//                    })
//                }
//            }
//        }
        
        if pickerView.tag == 1{
            //fetch the new time data for the chosen day
            fetchTimeForChosenDay(index: row)
            
            if timeForChosenDay?.count != 0{
                UIView.animate(withDuration: 0.3, animations: {
                    self.sendMeNotificationHeight.constant = 0
                    self.timeViewHeight.constant = self.view.frame.height / 3.5
                }) { (_) in
                    self.timeViewHeight.constant = self.view.frame.height / 2.5
                    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 14, options: [], animations: {
                        self.view.layoutIfNeeded()
                    }, completion: { (_) in
                        self.timePicker.reloadAllComponents()
                    })
                }
            }
            else{
                UIView.animate(withDuration: 0.3, animations: {
                    self.sendMeNotificationHeight.constant = 0
                    self.timeViewHeight.constant = 0
                }) { (_) in
                    self.sendMeNotificationHeight.constant = self.view.frame.height / 3.2
                    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 14, options: [], animations: {
                        self.view.layoutIfNeeded()
                    })
                }
            }
        }

    }
    
    //flow layout
    //uicollection snap to center delegate
    //circlar view
    
}