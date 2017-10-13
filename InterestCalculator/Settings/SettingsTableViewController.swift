//
//  SettingsTableViewController.swift
//  InterestCalculator
//
//  Created by Apparao Mulpuri on 13/10/17.
//  Copyright (c) 2017. All rights reserved.
//


import UIKit

class SettingsTableViewController: UITableViewController, UIPopoverPresentationControllerDelegate {
    
    // MARK: - Initialization
    
    let cellIdSettings = "DisplayCellID-Settings"
    
    //Default fields irrespective of user permissions
    var defaultGlobalSettings : Set<GlobalSettings> = [.displayTotalAmount]
    
    //Get the list of fields in global Setting Section for the particular user permissions
    var globalSettingSection : [GlobalSettings] = [.displayTotalAmount]
    
    var displayTotalAmountToggle : UISwitch?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateSettings()
        initializeAndLoadSettingValues()
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func updateSettings() {
        globalSettingSection = Array(
            defaultGlobalSettings.sorted { (a: GlobalSettings, b : GlobalSettings) -> Bool in
                return a.rawValue < b.rawValue })
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return SettingSections.allValues.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let section : SettingSections = SettingSections(rawValue: section)!
        
        switch(section){
        case .global_Settings:
            return globalSettingSection.count
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionForInt(section)
    }
    
    func sectionForInt(_ sectionID : Int) -> String{
        let section = SettingSections(rawValue: sectionID)
        return section!.getDescription()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell : UITableViewCell!
        let section : SettingSections = SettingSections(rawValue: indexPath.section)!
        
        switch(section){
        case .global_Settings:
            cell = self.getSettingsCell(tableView, indexPath:indexPath.row)
        }
        
        return cell
    }
    
   
    // MARK: - Table View Delegates
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath?
    {
        var returnValue : IndexPath?
        let section = SettingSections(rawValue: indexPath.section)!
       
        switch(section){
        case .global_Settings:
            returnValue = indexPath

        }
        
        return returnValue
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        self.tableView.deselectRow(at: indexPath, animated: true)
        
        let section = SettingSections(rawValue: indexPath.section)!
        
        switch(section){
        case .global_Settings:
            globalSettingsRowSelected(tableView, indexPath: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
    
    
    // MARK :- Event Handlers
    // functions for toggle buttons
    
    func initializeAndLoadSettingValues(){
        

        let displayTotalAmountKeyExists :Any? = UserDefaults.standard.object(forKey: "displayTotalAmount")
        displayTotalAmountToggle = UISwitch(frame: CGRect(x: 130, y: 235, width: 0, height: 0))
        displayTotalAmountToggle?.isOn = (displayTotalAmountKeyExists != nil) ? UserDefaults.standard.bool(forKey: "displayTotalAmount") : true
        displayTotalAmountToggle?.addTarget(self, action: #selector(SettingsTableViewController.displayTotalAmountToggleStateChaged(_:)), for: UIControlEvents.valueChanged)
    }
    
    
    @objc func displayTotalAmountToggleStateChaged(_ switchState: UISwitch) {
        if switchState.isOn {
            UserDefaults.standard.set(true, forKey: "displayTotalAmount")
        } else {
            UserDefaults.standard.set(false, forKey: "displayTotalAmount")
        }
    }
    
    
    // MARK :- Cells for Sections
    
    func getSettingsCell(_ tableView : UITableView, indexPath : Int) -> UITableViewCell{
        var cell : UITableViewCell!
        
        if(cell ==  nil){
            cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: cellIdSettings as String)
            cell.selectionStyle = UITableViewCellSelectionStyle.none
        }
        
        let setting : GlobalSettings = globalSettingSection[indexPath]
        
        switch(setting){
        case .displayTotalAmount:
            cell.accessoryView = displayTotalAmountToggle
            cell.textLabel?.text = setting.getDescription()
        }
        return cell
    }
    
    
    func globalSettingsRowSelected(_ tableView : UITableView, indexPath : IndexPath){
    }
}
