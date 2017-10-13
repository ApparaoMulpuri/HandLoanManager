//
//  SettingSections.swift
//  InterestCalculator
//
//  Created by Apparao Mulpuri on 13/10/17.
//  Copyright (c) 2017. All rights reserved.
//

import Foundation

// Setting Sections
enum SettingSections : Int {
    case global_Settings
    
    // TODO : to be updated when a new enumeration value in added
    static let allValues = [global_Settings]
    
    // Gets the description of each enum value
    func getDescription() -> String{
        switch self {
        case .global_Settings:
            return ""
        }
        
    }
}
