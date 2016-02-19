//
//  PGMSmsUserProfileViewController.swift
//  SMSCollectionsClient
//
//  Created by Richard Rosiak on 12/18/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

import UIKit

class PGMSmsUserProfileViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet var userId: UILabel!
    @IBOutlet var firstName: UILabel!
    @IBOutlet var lastName: UILabel!
    @IBOutlet var loginName: UILabel!
    @IBOutlet var email: UILabel!
    @IBOutlet var institutionName: UILabel!
    
    @IBOutlet var modules: UITextView!
    @IBOutlet var moduleFilters: UIPickerView!
    
    @IBOutlet var moduleIdField: UITextField!
    
    @IBOutlet var filteredModules: UITextView!
    
    
    var userProfile: PGMSmsUserProfile? = nil
    var pickerData: Array<String>!
    var rowSelectedInPicker: Int!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        println("Passed in user profile has \(self.userProfile?.userModules.count) modules.")
        
        if (self.userProfile != nil) {
            self.showUserProfile(profile: self.userProfile!)
        }
        else {
            println("userProfile was not passed in or is nil!")
        }
        
        pickerData = ["--Please select--", "All", "Active", "Expired", "Module Id", "Expiring"]
        
        self.moduleFilters.dataSource = self
        self.moduleFilters.delegate = self
        self.rowSelectedInPicker = 0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showUserProfile(profile uProfile: PGMSmsUserProfile) {
        self.userId.text = uProfile.userId
        self.firstName.text = uProfile.firstName
        self.lastName.text = uProfile.lastName
        self.loginName.text = uProfile.loginName
        self.email.text = uProfile.emailAddress
        self.institutionName.text = uProfile.institutionName
        
        modules.text = ""
        
        modules.text = self.formatModulesForView(uProfile.userModules as Array<PGMSmsUserModule>) //moduleViewRepresentation
    }
    
    func formatModulesForView(modules: Array<PGMSmsUserModule>) -> String {
        var formattedModule = ""
        
        for module in modules {
            
            formattedModule = formattedModule + self.formatModule(module)
        }
        
        return formattedModule
    }
    
    func formatModule(module: PGMSmsUserModule) -> String {
        println("The module id is: \(module.moduleId)")
        var formattedModule = ""
        formattedModule = formattedModule + "Module id: " + module.moduleId + "\n"
        formattedModule = formattedModule + "\t Is trial: " + ((module.isTrial == true) ? "true" : "false") + "\n"
        formattedModule = formattedModule + "\t Is expiring within warning period: " + ((module.isExpiringWithinWarningPeriod == true) ? "true" : "false") + "\n"
        formattedModule = formattedModule + "\t Is expired: " + ((module.isExpired == true) ? "true" : "false") + "\n"
        formattedModule = formattedModule + "\t Last sign on date: " + module.lastSignOnDate + "\n"
        formattedModule = formattedModule + "\t Expiration date: " + module.expirationDate + "\n"
        formattedModule = formattedModule + "\t Product type id: " + module.productTypeId + "\n"
        formattedModule = formattedModule + "\t Market name: " + module.marketName + "\n"
        formattedModule = formattedModule + "\t License type: " + module.licenseType + "\n"
        formattedModule = formattedModule + "\t Product role name: " + module.productRoleName + "\n\n"
        
        return formattedModule
    }
    
    // MARK: UIPickerView delegates
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.pickerData.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return self.pickerData[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        println("Selected row in picker is \(row)")
        self.rowSelectedInPicker = row
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func filterModulesTapped(sender: AnyObject) {
        println("Row selected in picker is: \(self.rowSelectedInPicker)")
        self.filteredModules.text = ""
        
        switch self.rowSelectedInPicker {
        case 0:
            self.showErrorDialogBox("Please select a module filter")
        case 1:
            println("Will show all modules")
            var allModules = self.userProfile!.allModules() as Array<PGMSmsUserModule>
            self.filteredModules.text = self.formatModulesForView(allModules as Array<PGMSmsUserModule>)
        case 2:
            println("Will show active modules")
            var activeModules = self.userProfile!.activeModules() as Array<PGMSmsUserModule>
            self.filteredModules.text = self.formatModulesForView(activeModules as Array<PGMSmsUserModule>)
        case 3:
            println("Will show expired modules")
            var expiredModules = self.userProfile!.expiredModules() as Array<PGMSmsUserModule>
            self.filteredModules.text = self.formatModulesForView(expiredModules as Array<PGMSmsUserModule>)
        case 4:
            println("Will show by module id")
            if (self.moduleIdField.text != nil && self.moduleIdField.text != "") {
                var moduleById: PGMSmsUserModule? = self.userProfile!.moduleById(self.moduleIdField.text);
                if (moduleById != nil) {
                    println("Got module \(moduleById!.moduleDescription())")
                    
                    self.filteredModules.text = self.formatModule(moduleById!)
                } else {
                    println("return module is nil")
                }
            } else {
                self.showErrorDialogBox("Please provide module id")
            }
        case 5:
            println("Will show expiring modules")
            var modulesExpiring = self.userProfile!.modulesExpiringWithinWarningPeriod() as Array<PGMSmsUserModule>
            self.filteredModules.text = self.formatModulesForView(modulesExpiring as Array<PGMSmsUserModule>)
        default:
            println("Unrecognized selection in switch - new picker row?")
        }
    }
    
    func showErrorDialogBox(errorMessage: String) {
        let alert = UIAlertView()
        alert.title = "Module Filtering Error"
        alert.message = errorMessage
        alert.addButtonWithTitle("OK")
        alert.show()
    }
}
