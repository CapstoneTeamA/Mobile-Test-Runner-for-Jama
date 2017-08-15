//
//  UserModel.swift
//  Mobile Test Runner for Jama
//
//  Created by PSU2 on 6/28/17.
//  Copyright © 2017 Jaca. All rights reserved.
//

import Foundation

class UserModel {
    var firstName: String = ""
    var lastName: String = ""
    var email: String = ""
    var id: Int = -1
    var username: String = ""

    func extractUser(fromData: [String : AnyObject]) {
        if fromData["firstName"] == nil || fromData["lastName"] == nil || fromData["email"] == nil || fromData["username"] == nil || fromData["id"] == nil {
            return
        }
        firstName = fromData["firstName"] as! String
        lastName = fromData["lastName"] as! String
        email = fromData["email"] as! String
        id = fromData["id"] as! Int
        username = fromData["username"] as! String
    }
}


