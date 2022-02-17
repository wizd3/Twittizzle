//
//  LoginViewController.swift
//  Twitter
//
//  Created by Dhiaa Bantan on 2/8/22.
//  Copyright © 2022 Dan. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        // When the screen appears, check if the user is already logged in, if so, navigate to the next screen "Home":
        if(UserDefaults.standard.bool(forKey: "userLoggedIn") == true){
            performSegue(withIdentifier: "loginToHome", sender: self)
        }
        
    }
    
    // When the login button is pressed:
    @IBAction func LoginButtonPressed(_ sender: UIButton) {
        
        // Use the Twitter API to authorize the user:
        let myURL = "https://api.twitter.com/oauth/request_token"
        
        // Login:
        TwitterAPICaller.client?.login(url: myURL, success: {
            
            // Change the user logged in status:
            UserDefaults.standard.set(true, forKey: "userLoggedIn")
            
            // Navigate to the next screen "Home":
            self.performSegue(withIdentifier: "loginToHome", sender: self)
            
        }, failure: { error in
            
            // If there's an error print it:
            print(error.localizedDescription)
        })
    
    }

}
