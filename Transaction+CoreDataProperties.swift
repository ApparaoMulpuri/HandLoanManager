//
//  Transaction+CoreDataProperties.swift
//  InterestCalculator
//
//  Created by Appa Rao Mulpuri on 13/10/17.
//  Copyright © 2017 Appa Rao Mulpuri. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Transaction {

    @NSManaged var moneyLender: String?
    @NSManaged var borrower: String?
    @NSManaged var amount: Float
    @NSManaged var interest: Float
    @NSManaged var lendDate: String?
    @NSManaged var interestRate: Float
    @NSManaged var paidBackDate: TimeInterval
}
