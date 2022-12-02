//
//  PeopleData.swift
//  Assignment02
//
//  Created by C Karthika on 02/04/2022.
//

import Foundation

class PeopleData {
    // data is an array of an array of Person objects
    var data : [Patient]!
    
    //initialiser makes parsing
    init(fromXML:String){
        //make data from the XML using a parser
        let parser = XMLPeopleParser(fileName: fromXML)
        parser.startParsing()
        self.data = parser.peopleData
    }
    
    func getCount()->Int{return data.count}
    func getPeople(index:Int)->Patient{return data[index]}
}
