//
//  Patient.swift
//  Assignment02
//
//  Created by C Karthika on 02/04/2022.
//

import Foundation

class Patient {
    
    var name    : String
    var gender  : String
    var age     : String
    var phone   : String
    var details : String
    var image   : String
    
    //initializers
    init() {
        self.name    = "N/A"
        self.gender  = "N/A"
        self.age     = "N/A"
        self.phone   = "N/A"
        self.details = "N/A"
        self.image   = "N/A"
    }
    
    init(name:String, gender:String, age:String, phone:String, details:String, image:String) {
        self.name    = name
        self.gender  = gender
        self.age     = age
        self.phone   = phone
        self.details = details
        self.image   = image
    }
}
