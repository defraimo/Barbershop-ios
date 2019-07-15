//
//  AllBarbers.swift
//  BarberShop
//
//  Created by Daniel Radshun on 18/06/2019.
//  Copyright © 2019 Neighbors. All rights reserved.
//

import Foundation

class AllBarbers {
    
    static let shared = AllBarbers()
    
    var allBarbers:[Barber] = []
    
    func addBarber(_ barber:Barber){
        allBarbers.append(barber)
    }
    
    init() {
        addBarber(Barber(name: "דניאל", id: 0, description: "ספר גברים, 3 שנים ניסיון בתחום. מתמקצע בדירוגים ובשלל התספורות השונות המודרניות והחדשניות ביותר.", image: #imageLiteral(resourceName: "profile_pic2"), schedule: DatesManager(daysAvailable: 10, additionalDays: 1), daysSchedule: nil))
        addBarber(Barber(name: "דניאל", id: 1, description: "ספר גברים ונשים, שנתיים ניסיון בתחום. יודע לעבוד עם כל סוגי השיער, התאמה אישית של תספורת וצבע לכל לקוח.", image: #imageLiteral(resourceName: "profile_pic1"), schedule: DatesManager(daysAvailable: 10, additionalDays: 2), daysSchedule: nil))
        addBarber(Barber(name: "אור", id: 2, description: "ספר גברים, מוותיקי המספרה, 6 שנים בתחום. יודע לספר במדיוק לבקשת הלקוח, מתמקצע בצביעה ובציורים מיוחדים.", image: #imageLiteral(resourceName: "profile_pic3"), schedule: DatesManager(daysAvailable: 10, additionalDays: 3), daysSchedule: nil))
        addBarber(Barber(name: "מתן", id: 3, description: "ספר נשים, שנתיים ניסיון בתחום. מתמקצע בתספורות נשים, סלסולים, החלקות, תסרוקות ערב וצביעה.", image: #imageLiteral(resourceName: "profile_pic4"), schedule: DatesManager(daysAvailable: 10, additionalDays: 4), daysSchedule: nil))
    }
    
    func setDaysOff(barberIndex:Int, days:[Int]){
        allBarbers[barberIndex].schedule?.setDaysOff(days: days)
    }
    
    func addDatesOff(barberIndex:Int, dates:[AppDate]){
        allBarbers[barberIndex].schedule?.addDatesOff(dates: dates)
    }
}
