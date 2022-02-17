//
//  HomeTableTableViewController.swift
//  Twitter
//
//  Created by Dhiaa Bantan on 2/8/22.
//  Copyright © 2022 Dan. All rights reserved.
//

import UIKit

class HomeTableTableViewController: UITableViewController {

    // General variables:
    var tweetsArray = [NSDictionary]()
    var numberOfTweets: Int!
    let myRefreshControll = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Load all tweets using the function "loadTweets":
        loadTweets()
        
        // Configuration of the refreshing the tableView when polling down:
        myRefreshControll.addTarget(self, action: #selector(loadTweets), for: .valueChanged)
        tableView.refreshControl = myRefreshControll
        
        // Set the row hieght dynamically based on the tweet itself:
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 120
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Load the tweets whenever the screen appears:
        loadTweets()
        
    }
    
    
    @objc func loadTweets(){
        
        // Only load 20 tweets when calling the loading function:
        numberOfTweets = 20
        
        // Use the Twitter API to retrieve the tweets:
        let myUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let myParams = ["count": numberOfTweets]
        
        TwitterAPICaller.client?.getDictionariesRequest(url: myUrl, parameters: myParams, success: { (tweets: [NSDictionary]) in
            
            // Empty the tweets array before repopulate it with new 20 tweets
            self.tweetsArray.removeAll()
            
            // Populate the tweets array by the retrieved tweets:
            for tweet in tweets {
                self.tweetsArray.append(tweet)
            }
            
            // Reload Data and end the refreshing if it was started by polling down the tableView (otherwise, it will be refreshing forever):
            self.tableView.reloadData()
            self.tableView.refreshControl?.endRefreshing()
            
        }, failure: { Error in
            
            // print the error:
            print(Error.localizedDescription)
        })
        
    }
    
    
    // Load more tweets when scrolling down (infinetely):
    func loadMoreTweets(){
        
        // Add 20 more tweets to the tableView:
        numberOfTweets += 20
        
        // Use the Twitter API to retrieve the tweets, but this time more than 20:
        let myUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let myParams = ["count": numberOfTweets]
        
        TwitterAPICaller.client?.getDictionariesRequest(url: myUrl, parameters: myParams, success: { (tweets: [NSDictionary]) in
            
            // Empty the tweets array before repopulate it with new tweets:
            self.tweetsArray.removeAll()
            
            // Populate the tweets array by the retrieved tweets:
            for tweet in tweets {
                self.tweetsArray.append(tweet)
            }
            
            // Reload Data:
            self.tableView.reloadData()
            
        }, failure: { Error in
            
            // print the error:
            print(Error.localizedDescription)
        })
        
    }
    
    
    // Recognize the scrolling down if the index of the cell that will be displayed is greater than the tweets array elements:
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == tweetsArray.count {
            loadMoreTweets()
        }
    }
    
    // If the Logout button is pressed:
    @IBAction func LogoutPressed(_ sender: UIBarButtonItem) {
        
        // Update the user logged in status:
        UserDefaults.standard.set(false, forKey: "userLoggedIn")
        
        // Call the API to perform the loging out:
        TwitterAPICaller.client?.logout()
        
        // Dismiss the screen and go back to Login screen:
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // Number of the tableview rows depends on how much elements in the tweets array:
        return tweetsArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Dequeue the reusable cell as the custom tweetCell:
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCellTableViewCell

        // Configuration of the cell using information from the API:
        // Extract the user:
        let user = tweetsArray[indexPath.row]["user"] as! NSDictionary
        // Extract the image URL:
        let imageUrl = URL(string: (user["profile_image_url_https"] as? String)!)
        let data = try? Data(contentsOf: imageUrl!)
        
        // If the image data is valid, display the user image on the cell:
        if let imageData = data {
            cell.profileImageView.image = UIImage(data: imageData)
        }
        // Modify the cell properties to match the tweet's info:
        cell.userNameLabel.text = user["name"] as? String
        cell.tweetContentLabel.text = tweetsArray[indexPath.row]["text"] as? String
        cell.setFavorite(tweetsArray[indexPath.row]["favorited"] as! Bool)
        cell.tweetID = tweetsArray[indexPath.row]["id"] as! Int
        cell.setRetweeted(tweetsArray[indexPath.row]["retweeted"] as! Bool)
        
        return cell
    }
    

}
