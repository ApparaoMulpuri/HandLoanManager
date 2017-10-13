//
//  ViewController.swift
//  InterestCalculator
//
//  Created by Appa Rao Mulpuri on 13/10/17.
//  Copyright © 2017 Appa Rao Mulpuri. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UITableViewController {
    
    var items: [Transaction] = []

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.items = appDelegate.getElementsWithName("Transaction")
        self.items.sort(by: { $0.borrower!.lowercased() < $1.borrower!.lowercased() })
        self.tableView.reloadData()
        
        self.totalAmount()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func refreshAllItems(_ sender: UIBarButtonItem) {
        self.totalAmount()
    }
    
    
    @IBAction func createAction(_ sender: UIBarButtonItem) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate

        let barrower = NSEntityDescription.insertNewObject(forEntityName: "Transaction", into: appDelegate.managedObjectContext) as! Transaction
        barrower.borrower = "ZZ"
        barrower.amount = 10000
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"

        barrower.lendDate = dateFormatter.string(from: Date())
        barrower.interestRate = 24.0
        barrower.interest = 0

        self.items.append(barrower)
        self.tableView.reloadData()
        self.performSegue(withIdentifier:"detailSegue", sender: nil)
    }

    
    //MARK: TableView data source methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "cell")!
        
        let itemToDisplay: Transaction = self.items[indexPath.row]
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "en_IN")
        formatter.maximumFractionDigits = 0
        
        let amount: Float! = itemToDisplay.amount
        let interest: Float! = itemToDisplay.interest
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let fromDate = dateFormatter.date(from: (itemToDisplay.lendDate)!)
        
        let noOfMonths =   (Calendar.current as NSCalendar).components(NSCalendar.Unit.month, from: fromDate!, to: Date(), options: NSCalendar.Options.searchBackwards).month
        
        let years = noOfMonths!/12
        var textColor = UIColor.black
        var font = UIFont.systemFont(ofSize: 12.0)
        if years == 1
        {
            textColor = UIColor.red
        }
        else if years >= 2
        {
            textColor = UIColor.red
            font = UIFont.boldSystemFont(ofSize: 12.0)
        }
        
        let monthsToBeDisaplyed = noOfMonths! - (years * 12)
        if years > 0 {
            cell.textLabel?.text =  (itemToDisplay.borrower)! + "   (\(years) years \(monthsToBeDisaplyed) months)"
        } else {
            cell.textLabel?.text =  (itemToDisplay.borrower)! + "   (\(monthsToBeDisaplyed) months)"
        }
        
        cell.textLabel?.textColor = textColor
        cell.textLabel?.font = font
        cell.detailTextLabel?.textColor = textColor
        cell.detailTextLabel?.font = font

        
        cell.detailTextLabel?.text = "P:\(formatter.string(from: amount as NSNumber)!) I: \(formatter.string(from: interest as NSNumber)!) T: \(formatter.string(from: (amount + interest) as NSNumber )!) D:\(itemToDisplay.lendDate!)"
        
        return cell
    }
    
    
    override  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "detailSegue", sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegue" {
            let destViewController: DetailController = segue.destination as! DetailController

            if let indexPath: IndexPath = self.tableView.indexPathForSelectedRow
            {
                destViewController.barrowerDetails = self.items[indexPath.row]
            }
            else {
                destViewController.barrowerDetails = self.items[items.count-1]
            }
        }
    }
    
    //MARK: Utility for calculating the total amt
    func totalAmount() {
        let isAmountShown = UserDefaults.standard.bool(forKey: "displayTotalAmount")
        if isAmountShown {
            var principleAmt: Float = 0.0
            var interestAmt: Float = 0.0
            
            for barrower: Transaction in items
            {
                InterestCalculation.sharedInstance.calculateInterest(barrowerDetails: barrower)
                principleAmt += barrower.amount
                interestAmt += barrower.interest
            }
            
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.locale = Locale(identifier: "en_IN")
            formatter.maximumFractionDigits = 0
            
            self.navigationItem.title = formatter.string(from: (principleAmt + interestAmt) as NSNumber) // $123"
        } else {
            self.navigationItem.title = ""
        }
    }
}

