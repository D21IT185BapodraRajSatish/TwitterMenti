//
//  ViewController.swift
//  Twittermenti
//
//  Created by Angela Yu on 17/07/2019.
//  Copyright © 2019 London App Brewery. All rights reserved.
//

import UIKit
import SwifteriOS
import SwiftyJSON

class ViewController: UIViewController {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var sentimentLabel: UILabel!
    
    let sentimentClassifier = TweetSentimentClassifier()
    
    
    
    let swifter = Swifter(consumerKey:"RhuhYgbxxESMVzPTOzFUxbVQC", consumerSecret:"O0FsEBF6Zzicb6YKJ2axwFg3i34pHQQJTPgH5nRfERlzQvDRsx")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        
    }
    
    @IBAction func predictPressed(_ sender: Any) {
        fetchTweet()
       
    }
    func fetchTweet(){
        if let searchText = textField.text{
            swifter.searchTweet(using: searchText,lang: "en",count: 100, tweetMode: .extended) { result, searchMetadata in
                //print(result)
                var tweets = [TweetSentimentClassifierInput]()
                
                for i in 0..<100{
                    if let tweet = result[i]["full_text"].string{
                        let tweetForClassification = TweetSentimentClassifierInput(text: tweet)
                        
                        tweets.append(tweetForClassification)
                        
                    }
                }
                self.makePredection(with: tweets)
            } failure: { error in
                print(error)
            }
        }
    }
    func makePredection(with tweets:[TweetSentimentClassifierInput]){
        do{
            let predections = try self.sentimentClassifier.predictions(inputs: tweets)
            var sentimentScore  = 0
            for pred in predections{
                let sentiment  = pred.label
                if (sentiment == "Pos"){
                    sentimentScore+=1
                }
                else if(sentiment == "Neg") {
                    sentimentScore-=1
                }
            }
            updateUI(with: sentimentScore)
            
        }catch{
            print("There was an error making predection ")
        }
    }
    func updateUI(with sentimentScore:Int){
        if sentimentScore > 20{
            self.sentimentLabel.text = "😍"
        }else if sentimentScore > 10{
            self.sentimentLabel.text = "😀"
        }else if sentimentScore > 0{
            self.sentimentLabel.text = "🙂"
        }else if sentimentScore == 0{
            self.sentimentLabel.text = "😐"
        }else if sentimentScore > -10{
            self.sentimentLabel.text = "😕"
        }else if sentimentScore > -20{
            self.sentimentLabel.text = "😡"
        }else{
            self.sentimentLabel.text = "🤮"
        }
    }
    
}

