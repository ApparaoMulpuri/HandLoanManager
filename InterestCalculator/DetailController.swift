//
//  DetailController.swift
//  InterestCalculator
//
//  Created by Appa Rao Mulpuri on 13/10/17.
//  Copyright © 2017 Appa Rao Mulpuri. All rights reserved.
//

import UIKit

class DetailController: UIViewController {
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var amount: UITextField!
    @IBOutlet weak var lendingDate: UITextField!
    @IBOutlet weak var interestRate: UITextField!
    @IBOutlet weak var totalAmt: UILabel!
    @IBOutlet weak var duration: UILabel!
    @IBOutlet weak var computeButton: UIButton!
    @IBOutlet weak var interestLabel: UILabel!
    
    @IBOutlet weak var principleLabel: UILabel!
    
    @IBOutlet weak var interestPerMonthLabel: UILabel!
    
    var barrowerDetails: Transaction?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.name.text = self.barrowerDetails?.borrower
        self.amount.text = String(format: "%.0f", (self.barrowerDetails?.amount)!)
        self.lendingDate.text = self.barrowerDetails?.lendDate //            self.barrowerDetails?.lendDate)
//        self.lendingDate.text = String(format: "%s", (self.barrowerDetails?.lendDate)!)
        self.interestRate.text = String(format: "%.2f", (self.barrowerDetails?.interestRate)!)
        
        self.computeInterest(self.computeButton)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func cancel(_ sender: UIButton) {
        self.name.resignFirstResponder()
        self.amount.resignFirstResponder()
        self.lendingDate.resignFirstResponder()
        self.interestRate.resignFirstResponder()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.navigationController?.popViewController(animated: true)
        }
    }

    @IBAction func computeInterest(_ sender: UIButton) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let fromDate = dateFormatter.date(from: (self.barrowerDetails?.lendDate)!)

        let noOfDays =   (Calendar.current as NSCalendar).components(NSCalendar.Unit.day, from: fromDate!, to: Date(), options: NSCalendar.Options.searchBackwards).day
        
//        noOfMonths++

        var years = noOfDays!/365
        let months = (noOfDays!%365)/30
        let days = (noOfDays!%365)%30
        
        if years>0
        {
            self.duration.text = "\(years) years, \(months) months, \(days) days"
        }
        else
        {
            self.duration.text = "\(months) months \(days) days"
        }

        
        var totalAmt = self.barrowerDetails?.amount
        var totalInterest = 0
        var compoundInterestActivated: Bool = false
        var compoundInterest = 0
        var compoundInterestRemaining = 0

        if (years > 0)
        {
            while years >= 3 {
                let temp: Float = totalAmt!*((self.barrowerDetails?.interestRate)!/12)
                compoundInterest = (Int(temp) * 3*12)/100
                
                self.interestPerMonthLabel.text = "NA in Compound Interest"
                totalAmt = totalAmt! + Float(compoundInterest)
                
                years -= 3
                compoundInterestActivated = true
            }
            
            if years > 0
            {
                let temp: Float = totalAmt!*((self.barrowerDetails?.interestRate)!/12)
                totalInterest = (Int(temp) * (years*12))/100
                compoundInterestRemaining = 0
            }
        }
        
        //100*24*(13/12)/100
        if months > 0
        {
            let temp: Float = totalAmt!*((self.barrowerDetails?.interestRate)!/12)
            totalInterest += (Int(temp) * months)/100
            compoundInterestRemaining = 0
        }
        
        if days > 0 {
            let dayInterest: Float = totalAmt!*(((self.barrowerDetails?.interestRate)!/12)/30)
            totalInterest += (Int(dayInterest) * days)/100
            compoundInterestRemaining = 0
        }
        
        let temp: Float = (totalAmt)!*((self.barrowerDetails?.interestRate)!/12)
        let intPerMonth = (Int(temp))/100

        let totalAmoutWithInterest = Int(totalAmt!)+totalInterest

        if let totalAmt = totalAmt {
            self.interestPerMonthLabel.text = "\(intPerMonth)"
            self.interestLabel.text = "\(totalInterest)"
            self.principleLabel.text = "\(Int(totalAmt))"
            
            self.totalAmt.text = "\(totalAmoutWithInterest)"
            
            self.barrowerDetails?.interest = Float(totalAmoutWithInterest - Int((self.barrowerDetails?.amount)!))
        }
    }
    
    @IBAction func save(_ sender: UIButton) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.saveContext()
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func deleteEntity(_ sender: UIButton) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate

        let alertController = UIAlertController(title: "Delete", message: "Do you want to delete the Entry!", preferredStyle: .alert)
        //We add buttons to the alert controller by creating UIAlertActions:
        let actionOk = UIAlertAction.init(title: "OK", style: .default) { (void) in
            appDelegate.managedObjectContext.delete(self.barrowerDetails!)
            appDelegate.saveContext()
            self.navigationController?.popViewController(animated: true)
        }
        alertController.addAction(actionOk)
        
        let actionCancel = UIAlertAction.init(title: "Cancel", style: .cancel) { (void) in
        }
        alertController.addAction(actionCancel)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        if (textField == self.name)
        {
            self.barrowerDetails?.borrower = textField.text
        }
        else if (textField == self.amount)
        {
            self.barrowerDetails?.amount = NSString(string: textField.text!).floatValue
        }
        else if (textField == self.lendingDate)
        {
            self.barrowerDetails?.lendDate = textField.text
        }
        else if (textField == self.interestRate)
        {
            self.barrowerDetails?.interestRate = NSString(string: textField.text!).floatValue
        }
        
        self.computeInterest(self.computeButton)
    }
    
}
