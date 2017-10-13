//
//  InterestCalculation.swift
//  InterestCalculator
//
//  Created by Appa Rao Mulpuri on 10/13/17.
//  Copyright © 2017 Appa Rao Mulpuri. All rights reserved.
//

import Foundation

class InterestCalculation: NSObject {
    static let sharedInstance = InterestCalculation()
    
    func calculateInterest(barrowerDetails: Transaction) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let fromDate = dateFormatter.date(from: (barrowerDetails.lendDate)!)
        
        let noOfDays =   (Calendar.current as NSCalendar).components(NSCalendar.Unit.day, from: fromDate!, to: Date(), options: NSCalendar.Options.searchBackwards).day
        
        //        noOfMonths++
        
        var years = noOfDays!/365
        let months = (noOfDays!%365)/30
        let days = (noOfDays!%365)%30
        
        var totalAmt = barrowerDetails.amount
        var totalInterest = 0
        var compoundInterest = 0
        
        if (years > 0)
        {
            while years >= 3 {
                let temp: Float = totalAmt*((barrowerDetails.interestRate)/12)
                compoundInterest = (Int(temp) * 3*12)/100
                
                totalAmt = totalAmt + Float(compoundInterest)
                
                years -= 3
            }
            
            if years > 0
            {
                let temp: Float = totalAmt*((barrowerDetails.interestRate)/12)
                totalInterest = (Int(temp) * (years*12))/100
            }
        }
        
        //100*24*(13/12)/100
        if months > 0
        {
            let temp: Float = totalAmt*((barrowerDetails.interestRate)/12)
            totalInterest += (Int(temp) * months)/100
        }
        
        if days > 0 {
            let dayInterest: Float = totalAmt*(((barrowerDetails.interestRate)/12)/30)
            totalInterest += (Int(dayInterest) * days)/100
        }
        
        let temp: Float = (totalAmt)*((barrowerDetails.interestRate)/12)        
        let totalAmoutWithInterest = Int(totalAmt)+totalInterest
        
        barrowerDetails.interest = Float(totalAmoutWithInterest - Int((barrowerDetails.amount)))
    }

}
