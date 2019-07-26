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
        
//        DAO.shared.loadBarbersfromFirebase(completion: { [weak self] barbers in
//            self?.allBarbers += barbers
//            print("Barbers were loaded")
//            })
        
        DAO.shared.loadBarbersfromFirebase()

    }
    
    func loadBarbers(_ barbers:[Barber], complition: @escaping () -> Void){
        allBarbers = barbers
        print("Barbers were loaded")
        //load the prices
        PricesDataSource.shared.fetchPrices(complition: {
            complition()
        })
    }
    
    func getBarbersByIndex(_ indexArray:[Int]) -> [Barber]{
        var newBarbers:[Barber] = []
        for index in indexArray{
            newBarbers.append(barbers[index])
        }
        return newBarbers
    }
    
//    func setDaysOff(barberIndex:Int, days:[Int]){
//        allBarbers[barberIndex].schedule?.setDaysOff(days: days)
//    }
//
//    func addDatesOff(barberIndex:Int, dates:[AppDate]){
//        allBarbers[barberIndex].schedule?.addDatesOff(dates: dates)
//    }
}
