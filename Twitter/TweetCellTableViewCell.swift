//
//  TweetCellTableViewCell.swift
//  Twitter
//
//  Created by Dhiaa Bantan on 2/8/22.
//  Copyright © 2022 Dan. All rights reserved.
//

import UIKit

class TweetCellTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var tweetContentLabel: UILabel!
    @IBOutlet weak var favButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // General variables with inital values:
    var tweetID: Int = -1
    var favorited: Bool = false
    var retweeted: Bool = false
    
    // Function to set the tweet as favorited or not (change the image of the favorite button):
    func setFavorite(_ isFavorited: Bool){
        favorited = isFavorited
        if(favorited == true){
            favButton.setImage(UIImage(named: "favor-icon-red"), for: .normal)
        } else {
            favButton.setImage(UIImage(named: "favor-icon"), for: .normal)
        }
    }
    
    // Function to set the tweet as it has been retweetd or not (change the image of the retweet button and disable the button):
    func setRetweeted(_ isRetweeted: Bool){
        retweeted = isRetweeted
        if(retweeted == true){
            retweetButton.setImage(UIImage(named: "retweet-icon-green"), for: .normal)
            retweetButton.isEnabled = false
        } else {
            retweetButton.setImage(UIImage(named: "retweet-icon"), for: .normal)
            retweetButton.isEnabled = true
        }
        
    }
    
    
    // When the favorite button is pressed, use the functions above to update the tweet:
    @IBAction func favButtonPressed(_ sender: UIButton) {
        
        let toBeFavorite = !favorited
        
        if(toBeFavorite == true){
            
            TwitterAPICaller.client?.favTweet(tweetID: tweetID, success: {
                self.setFavorite(true)
            }, failure: { error in
                print(error.localizedDescription)
            })
            
        } else {
            
            TwitterAPICaller.client?.unfavTweet(tweetID: tweetID, success: {
                self.setFavorite(false)
            }, failure: { error in
                print(error.localizedDescription)
            })
        }
        
    
    }
    
    // When the retweet button is pressed, use the function above to update the tweet:
    @IBAction func retweetButtonPressed(_ sender: UIButton) {
        TwitterAPICaller.client?.retweet(tweetID: tweetID, success: {
            self.setRetweeted(true)
        }, failure: { error in
            print(error.localizedDescription)
        })
    }
    
    
    
}
