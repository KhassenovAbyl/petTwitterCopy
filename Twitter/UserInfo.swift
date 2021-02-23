//
//  UserInfo.swift
//  Twitter
//
//  Created by Abylbek Khassenov on 12/1/20.
//

import Foundation
import FirebaseDatabase
struct UserInfo {
    var name : String?
    var surname : String?
    var dateOfBirth : String?
    var email : String?
    var dict: [String:String]{
        return [
            "name" : name!,
            "surname" : surname!,
            "dateOfBirth" : dateOfBirth!,
            "email" : email!
        ]
    }
    init(_ name : String ,_ surname : String , _ dateOfBirth: String , _ email : String) {
        self.name = name
        self.surname  = surname
        self.dateOfBirth = dateOfBirth
        self.email = email
    }
    init(snapshot : DataSnapshot){
        if let value = snapshot.value as? [String:String]{
            name = value["name"]
            surname = value["surname"]
            dateOfBirth = value["dateOfBirth"]
            email = value["email"]
        }
    }
}
