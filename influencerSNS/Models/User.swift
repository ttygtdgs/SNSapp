//
//  User.swift
//  influencerSNS
//
//  Created by user on 2021/03/02.
//

import Foundation
import Firebase

//ここでモデルを作っている
struct User {
    let name: String
    let createdAt: Timestamp
    let email: String
    
    init(dic: [String: Any]){
        self.name = dic["name"] as! String
        self.createdAt = dic["createdAt"] as! Timestamp
        self.email = dic["email"] as! String
    }
}
