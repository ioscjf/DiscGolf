//
//  SQL.swift
//  DiscGolf
//
//  Created by Connor Fitzpatrick on 7/29/17.
//  Copyright © 2017 Connor Fitzpatrick. All rights reserved.
//

import Foundation
import SQLite

class SQL {
    func getCourses() {
        
        // path is null?
        let path = Bundle.main.path(forResource: "db", ofType: "sqlite3")!
        guard let db = try? Connection(path, readonly: true) else {
            print("ERROR: handle this!!")
            return
        }
        
        // add db file to xcode project!!
        
        let courses = Table("courses")
        let id = Expression<Int64>("id")
        let name = Expression<String>("name")
        let location = Expression<String>("location")
        let totalDistance = Expression<Double>("totalDistance")
        let totalPar = Expression<Int>("totalPar")
        let numberOfHoles = Expression<Int>("numberOfHoles")
    
        guard let cs = try? db.prepare(courses) else {
            print("ERROR: !!")
            return
        }
        
        for course in cs {
            print("id: \(course[id]), name: \(course[name]), location: \(course[location]), totalDistance: \(course[totalDistance]), totalPar: \(course[totalPar]), numberOfHoles: \(course[numberOfHoles])")
            // id: 1, name: Optional("Alice"), email: alice@mac.com
        }
    }
    
    func addCourses() {
        
        // path is null!!?
        let path = Bundle.main.path(forResource: "db", ofType: "sqlite3")!
        guard let db = try? Connection(path, readonly: true) else {
            print("ERROR: handle this too!!")
            return
        }

        let courses = Table("courses")
        let id = Expression<Int64>("id")
        let name = Expression<String?>("name")
        let location = Expression<String>("location")
        let totalDistance = Expression<Double>("totalDistance")
        let totalPar = Expression<Int>("totalPar")
        let numberOfHoles = Expression<Int>("numberOfHoles")
        
        guard let _ = try? db.run(courses.create { t in
            t.column(id, primaryKey: true)
            t.column(name)
            t.column(location)
            t.column(totalDistance)
            t.column(totalPar)
            t.column(numberOfHoles)
        }) else {
            print("ERROR: handle this three!!")
            return
        }
    }

}
