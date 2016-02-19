//
//  ViewController.swift
//  SMSCollectionsClient
//
//  Created by Joe Miller on 12/1/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var tokenText: UITextView!
    @IBOutlet weak var errorText: UITextView!
    
    var userToken = ""
    var salt = "PE"
    var userProfileToPass: PGMSmsUserProfile!
    
    var client: PGMSmsCollectionsClient?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        statusView.hidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func loginButtonTapped(sender: AnyObject) {
        tokenText.text = "";
        errorText.text = "";
        
        getClient().loginWithUsername(usernameField.text, password: passwordField.text, onComplete: { (response) -> Void in
            NSOperationQueue.mainQueue().addOperationWithBlock({
                self.loginComplete(response)
            })
        })
    }
    
    @IBAction func tapped(sender: AnyObject) {
        self.view.endEditing(true)
    }
    
    func loginComplete(response: PGMSmsResponse) {
        self.statusView.hidden = false
        if (response.error != nil) {
            errorText.text = response.error.description
            self.userToken = ""
        } else {
            self.tokenText.text = response.smsToken
            self.userToken = response.smsToken
            println("Assign token to userToken: \(self.userToken)")
        }
    }
    
    func getClient() -> PGMSmsCollectionsClient {
        if (client == nil) {
            var environment = PGMSmsEnvironment(forType: PGMSmsEnvironmentType.PGMSMSCertStagingEnv, withSiteID: "87227", error: nil)
            client = PGMSmsCollectionsClient(environment: environment)
        }
        return client!
    }
    
    @IBAction func showModulesTapped(sender: AnyObject) {
        
        println("Will call obtainModuleIDsForToken with these paramaters: user token: \(self.userToken) and salt \(self.salt)")
        
        getClient().obtainModuleIDsForToken(self.userToken, salt: self.salt, onComplete: { (response) -> Void in
            NSOperationQueue.mainQueue().addOperationWithBlock({
                self.moduleIdsComplete(response)
            })
        })
    }
    
    func moduleIdsComplete(response: PGMSmsResponse) {
        if (response.error != nil) {
            errorText.text = response.error.description
            println("moduleIdComplete - Error: \(response.error.description)")
        }
        else {
            println("moduleIdComplete - success! got module ids.")
            if (response.userProfile != nil) {
                println("It has \(response.userProfile.userModules.count) user modules.")
            }
            self.userProfileToPass = response.userProfile
            self.performSegueWithIdentifier("userProfile", sender: self)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        println("in prepare for segue - userProfile")
        if (segue.identifier == "userProfile") {
            println("Will send data to user profile view...")
            
            var userProfileVC = segue.destinationViewController as PGMSmsUserProfileViewController
            userProfileVC.userProfile = self.userProfileToPass
        }
    }
}
