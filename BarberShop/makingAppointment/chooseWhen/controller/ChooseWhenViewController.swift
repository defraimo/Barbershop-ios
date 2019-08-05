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
    
    var appointment:Appointment?
    var previousAppointment:Appointment?
    
    var displayedDate:MyDate?
    
    var chosenDateIndex:Int = 0
    var chosenTimeIndex:Int = 0
    var unitsNeeded:Int = 1
    
    //check if the first barber is already loaded from the code so it won't be loaded in the first swipe while passing between two barbers
    var firstAlreadyLoaded = false
    
    var passedPointX:CGFloat?
    var passedPointY:CGFloat?
    var chosenBarberImage:UIImageView?
    var chosenBarberIndex:IndexPath?
    
    var cellWasReloaded:[Bool] = []
    
    @IBOutlet weak var datePicker: UIPickerView!
    @IBOutlet weak var timePicker: UIPickerView!
    
    @IBOutlet weak var datePickerIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var timeView: UIView!
    @IBOutlet weak var timeViewHeight: NSLayoutConstraint!
    @IBOutlet weak var timeViewLabel: UILabel!
    
    @IBOutlet weak var sendNotificationLabel: UILabel!
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
        guard let dest = segue.destination as? SumUpViewController,
            let id = segue.identifier
            else {return}
        
        //set the navigation back item title of the next screen
        let backItem = UIBarButtonItem()
        backItem.title = "בחירת תור"
        navigationItem.backBarButtonItem = backItem
        
        if id == "toSumUp"{
            appointment?.barber = barbers?[chosenBarberIndex!.row]
            appointment?.date = datesForBarber?[chosenDateIndex].date
            
            let chosenUnit = timeForChosenDay![chosenTimeIndex]
            let unitsNeeded = scheduleData?.getUnitsNeededForServies(date: chosenDateIndex, chosenUnit: chosenUnit, unitsNeededNum: scheduleData?.numberOfUnitsNeeded ?? 1)
            
            appointment?.units = unitsNeeded
            dest.appointment = appointment
            
            dest.dayOfWeek = datesForBarber?[chosenDateIndex].namedDayOfWeek
            
            //if user chose to change his appointment pass the previous one
            if previousAppointment != nil{
                dest.previousAppointment = previousAppointment
            }
        }
    }
    
    
    fileprivate func imageEntryAnimation() {
        
        //set all the vies to invisible
        for view in view.subviews{
            view.alpha = 0
        }
        
        //getting the position of the current item
        let collectionPosition = /*barbersCollection.layoutAttributesForItem(at: chosenBarberIndex!)?.center ??*/ barbersCollection.center
        
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
//                        if self.timeForChosenDay?.count != 0{
//                            //animate the timeView
//                            self.timeViewHeight.constant = self.view.frame.height / 2.5
//                            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 20, options: [], animations: {
//                                self.view.layoutIfNeeded()
//                            })
//                        }
//                        else{
//                            //animate the sendMeNotificationView
//                            self.sendMeNotificationHeight.constant = self.view.frame.height / 3.2
//                            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 14, options: [], animations: {
//                                self.view.layoutIfNeeded()
//                            })
//                        }
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
        ScheduleData().fetchScheduleFor(barber: barbers![chosenBarberIndex?.row ?? 0]) { [weak self] (schedule) in
            self?.scheduleData = schedule
            
            //load all the days of the current barber
            self?.fetchDatesForCurrentBarber()
            
            //load the time for the first shown day
            self?.fetchTimeForChosenDay(index: 0)
            
            self?.datePickerIndicator.stopAnimating()
            self?.datePickerIndicator.isHidden = true
            
            self?.datePicker.reloadAllComponents()
            self?.timePicker.reloadAllComponents()
            
            self?.checkWhichDialogToShow(timeViewDuration: 0.3, notificationViewDuration: 0.5)
            
            //scroll the collaction view to the chosen barber posiotion from the last screen
            self?.barbersCollection.scrollToItem(at: (self?.chosenBarberIndex!)!, at: .centeredHorizontally, animated: false)
            
            self?.setArrowsAlpha((self?.chosenBarberIndex!.row)!)
        }
        
        //setting the background
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
        
       imageEntryAnimation()
        
        //set the picker date array to the chosen barber from the last screen
        let chosenRow = chosenBarberIndex!.row
        
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
    
    override func viewDidAppear(_ animated: Bool) {
        //scroll to see the collection item in the middle
        self.barbersCollection.scrollToNearestVisibleCollectionViewCell()
    }
    
    func fetchDatesForCurrentBarber(){
        datesForBarber = scheduleData?.getDisplayedDates()
    }
    
    func fetchTimeForChosenDay(index:Int){
//        timeForChosenDay = scheduleData?.getDisplayTimeFor(dateIndex: index)
        let serviesDuration = appointment?.servies?.duration
        timeForChosenDay = scheduleData?.getDisplayTimeUnitsWith(intervals: serviesDuration!, forDateIndex: index)
        unitsNeeded = scheduleData?.numberOfUnitsNeeded ?? 1
        
        displayedDate = scheduleData?.displayedDates?[index].date
    }
    
    fileprivate func checkWhichDialogToShow(timeViewDuration:Float, notificationViewDuration:Float){
        //check if the working time is set atleast on the first day
        if self.timeForChosenDay?.count != 0{
            //animate the timeView
            self.timeViewHeight.constant = self.view.frame.height / 2.5
            UIView.animate(withDuration: TimeInterval(timeViewDuration), delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 20, options: [], animations: {
                self.view.layoutIfNeeded()
            })
        }
        else{
            //check if all the time availible for the chosen day is full
            changeSendNotificationView()
            //animate the sendMeNotificationView
            self.sendMeNotificationHeight.constant = self.view.frame.height / 3.2
            UIView.animate(withDuration: TimeInterval(notificationViewDuration), delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 14, options: [], animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
    
    fileprivate func hideAllDialogs(){
        //set both dialog height to 0
        self.timeViewHeight.constant = 0
        self.sendMeNotificationHeight.constant = 0
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.6,initialSpringVelocity: 20, options: [], animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    fileprivate func changeSendNotificationView(){
        if let avialibleDaysCount = scheduleData?.avialibleDaysCount, self.displayedDate != nil && timeForChosenDay?.count == 0 && self.chosenDateIndex < avialibleDaysCount{
            self.sendNotificationLabel.text = "אין יותר תורים ליום זה"
            self.sendNotificationButton.alpha = 0
        }
        else{
            self.sendNotificationLabel.text = "שלח לי התראה כשיפתחו תורים"
            self.sendNotificationButton.alpha = 1
        }
    }
    
    @IBAction func sendMeNotification(_ sender: UIButton) {
        let alert = AlertService().alert(title: "התראה", body: "אנו נודיע לך ברגע שיפתחו תורים ליום זה", btnAmount: 2, positive: "אישור", negative: "חזור לתפריט הראשי", positiveCompletion: {
            
        }, negativeCompletion: {
            self.navigationController?.popToRootViewController(animated: true)
        })
        self.present(alert, animated: true)
    }
   
}

private let reuseIdentifier = "barberChooseCell"

extension ChooseWhenViewController: UICollectionViewDataSource,UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return barbers?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! BarberChangeCollectionViewCell
        
        let barber = barbers![indexPath.item]
        
        cell.populate(barber:barber)
        
        var delay = 0.1
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
        
        if !cellWasReloaded[visibleRow] && firstAlreadyLoaded{
            
            UIView.animate(withDuration: 0.3, animations: {
                self.datePicker.alpha = 0
                self.hideAllDialogs()
            })
            
            self.datePickerIndicator.startAnimating()
            self.datePickerIndicator.isHidden = false

            ScheduleData().fetchScheduleFor(barber: barbers![visibleRow]) { [weak self] (schedule) in
                self?.scheduleData = schedule
                
                self?.fetchDatesForCurrentBarber()
                self?.fetchTimeForChosenDay(index: 0)
                
                self?.chosenDateIndex = 0
                self?.chosenTimeIndex = 0
            
                self?.chosenBarberIndex = visible.first!
                
                UIView.animate(withDuration: 0.3, animations: {
                    self?.datePicker.alpha = 1
                })
                self?.datePickerIndicator.stopAnimating()
                self?.datePickerIndicator.isHidden = true
                
                self?.datePicker.reloadAllComponents()
                self?.timePicker.reloadAllComponents()
                
                self?.checkWhichDialogToShow(timeViewDuration: 0.24, notificationViewDuration: 0.32)
                
                self?.datePicker.selectRow(0, inComponent: 0, animated: true)
                self?.timePicker.selectRow(0, inComponent: 0, animated: true)
                
            }
            
            for i in 0..<self.barbers!.count{
                if i == visibleRow{
                    self.cellWasReloaded[i] = true
                }
                else{
                    self.cellWasReloaded[i] = false
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

extension ChooseWhenViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
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
        
        if pickerView.tag == 1{
            //fetch the new time data for the chosen day
            fetchTimeForChosenDay(index: row)
            
            chosenDateIndex = row
            
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
                        self.timePicker.selectRow(0, inComponent: 0, animated: true)
                    })
                }
            }
            else{
                //check if all units are not availible so write there are no appointments left
                self.changeSendNotificationView()
                
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
        else{
            chosenTimeIndex = row
        }

    }
    
}
