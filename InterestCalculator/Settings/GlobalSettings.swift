//
//  GlobalSettings.swift
//  InterestCalculator
//
//  Created by Apparao Mulpuri on 13/10/17.
//  Copyright (c) 2017. All rights reserved.
//

import Foundation

// Global Setting
// maintain the order here the way we want them ordered on screen
enum GlobalSettings : Int {
    case displayTotalAmount
    
    // to be updated when a new enumeration value in added
    static let enabledValues = [displayTotalAmount]
    
    
    // Gets the description of each enum value
    func getDescription() -> String{
        switch self {
        case .displayTotalAmount:
            return "Display Total Amount"
        }
    }
}
