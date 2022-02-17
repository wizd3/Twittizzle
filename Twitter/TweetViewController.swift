//
//  TweetViewController.swift
//  Twitter
//
//  Created by Dhiaa Bantan on 2/16/22.
//  Copyright © 2022 Dan. All rights reserved.
//

import UIKit

class TweetViewController: UIViewController {

    @IBOutlet weak var tweetTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Make the tweetTextView the first responder:
        tweetTextView.becomeFirstResponder()
    }

    // When Cancel button is pressed, dismiss the tweet and go back to the previous screen "Home":
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    // When Tweet button is pressed, call the API to post the tweet, then dismiss the screen and go back to the previous screen "Home":
    @IBAction func tweet(_ sender: UIBarButtonItem) {
        
        // If the textView is not empty, post the tweet:
        if(!tweetTextView.text.isEmpty){
            
            TwitterAPICaller.client?.postTweet(tweetString: tweetTextView.text, success: {
                self.dismiss(animated: true, completion: nil)
            }, failure: { Error in
                print(Error.localizedDescription)
                self.dismiss(animated: true, completion: nil)
            })
            
        } else {
            // if the textView is empty:
            print("Nothing to post! TweetTextView is empty!")
        }
    }
    
    
    
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
