//
//  MainPageVC.swift
//  Twitter
//
//  Created by Abylbek Khassenov on 11/26/20.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class MainPageVC: UIViewController , UITableViewDelegate , UITableViewDataSource {
    
    @IBOutlet weak var myTable: UITableView!
    var currentUser : User?
    var userName  : String?
    var tweets: [Tweet] = []
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetsCell" , for : indexPath) as! TweetViewCell
        cell.nameLabel.text = tweets[indexPath.row].author
        cell.hashtagLabel.attributedText = boldText(bold: "#", normal: tweets[indexPath.row].hashtag!)
        cell.tweetLabel.text = tweets[indexPath.row].content
        cell.dateLabe.attributedText = boldText(bold: "Date:", normal: tweets[indexPath.row].date!)
        cell.timeLabel.attributedText = boldText(bold: "Time", normal: tweets[indexPath.row].time!)
        return cell
        }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete){
            tweets.reverse()
            tweets.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        currentUser = Auth.auth().currentUser
        let parent = Database.database().reference().child("tweets")
        parent.observe(.value){[weak self](snapshot) in
            self?.tweets.removeAll()
            for child in snapshot.children{
                if let snap = child as? DataSnapshot{
                    let tweet = Tweet(snapshot: snap)
                    self?.tweets.append(tweet)
                }
            }
            self?.tweets.reverse()
            self?.myTable.reloadData()
        }
        currentUser = Auth.auth().currentUser
        let parent2 = Database.database().reference().child("Users").child(currentUser!.uid)
        parent2.observe(.value){[weak self](snapshot) in
            let value = snapshot.value as? NSDictionary
            self?.userName = value?["name"] as? String ?? ""
        }

        // Do any additional setup after loading the view.
    }
    
    @IBAction func tweet(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "New tweet", message: "Enter a text", preferredStyle: .alert)

        alert.addTextField { (textField) in
            textField.placeholder = "Hashtag"
        }
        alert.addTextField { (textField) in
            textField.placeholder = "What's up?"
        }
        let time = self.getCurrentTime()
        let date = self.getCurrentDate()
        alert.addAction(UIAlertAction(title: "Tweet", style: .default, handler: { [weak alert] (_) in
            let textField1 = alert?.textFields![0]
            let textField2 = alert?.textFields![1]
            
            let tweet = Tweet(textField1!.text!, textField2!.text!, self.userName!, self.currentUser!.email!, time , date: date)
            Database.database().reference().child("tweets").childByAutoId().setValue(tweet.dict)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func signout(_ sender: UIBarButtonItem) {
        do{
            try Auth.auth().signOut()
        }catch{
            print("Error")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func getCurrentDate() -> String{
                    let date = Date()
                    let calender = Calendar.current
                    let components = calender.dateComponents([.year,.month,.day], from: date)
                    let currentDate = String(components.day!) + ":" + String(components.month!) + ":" + String(components.year! % 2000)

                    return currentDate
                }
    func getCurrentTime() -> String{
                    let date = Date()
                    let calender = Calendar.current
                    let components = calender.dateComponents([.hour,.minute,.second], from: date)
                    let currentTime = String(components.hour!)  + ":" + String(components.minute!) + ":" +  String(components.second!)

                    return currentTime
                }
    
    func boldText(bold : String , normal : String) -> NSMutableAttributedString{
        let boldText = bold
        let attrs = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)]
        let attributedString = NSMutableAttributedString(string:boldText, attributes:attrs)

        let normalText = normal
        let normalString = NSMutableAttributedString(string:normalText)
        
        attributedString.append(normalString)
        return attributedString
    }
}
