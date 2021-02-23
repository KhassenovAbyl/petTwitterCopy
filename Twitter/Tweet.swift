//
//  Tweet.swift
//  Twitter
//
//  Created by Abylbek Khassenov on 12/1/20.
//

import Foundation
import FirebaseDatabase
struct Tweet {
    var content : String?
    var author : String?
    var email : String?
    var hashtag : String?
    var time : String?
    var date : String?
    var dict: [String:String]{
        return [
            "tweet" : content!,
            "hashtag" : hashtag!,
            "author" : author!,
            "email" : email!,
            "time" : time! ,
            "date" : date!
        ]
    }
    init(_ content : String ,_ hashtag : String ,  _ author : String , _ email : String , _ time : String , date : String) {
        self.content = content
        self.hashtag = hashtag
        self.author = author
        self.email = email
        self.time = time
        self.date = date
    
    }
    init(snapshot : DataSnapshot){
        if let value = snapshot.value as? [String:String]{
            content = value["tweet"]
            hashtag = value["hashtag"]
            author = value["author"]
            email = value["email"]
            time = value["time"]
            date = value["date"]
        }
    }
}
