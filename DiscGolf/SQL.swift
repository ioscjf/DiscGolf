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
        
        // add a drop table!!
        // add select course id!!
        // add scores
        // add players
        // add throw (distance)
        
        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
            ).first!
        
        do {
            let db = try Connection("\(path)/courses.sqlite3")
            
            let courses = Table("courses")
            let id = Expression<Int64>("id")
            let name = Expression<String>("name")
            let latitude = Expression<Double>("latitude")
            let longitude = Expression<Double>("longitude")
            let rating = Expression<Double>("rating")
            let totalPar = Expression<Int>("totalPar")
            let numberOfHoles = Expression<Int>("numberOfHoles")
            let totalDistance = Expression<Double>("totalDistance")
            
            do {
                let cs = try db.prepare(courses)
                
                for course in cs {
                    print("id: \(course[id]), name: \(course[name]), latitude: \(course[latitude]), longitude: \(course[longitude]), totalDistance: \(course[totalDistance]), totalPar: \(course[totalPar]), numberOfHoles: \(course[numberOfHoles]), rating: \(course[rating])")
                }
            } catch {
                print("Function: \(#function), line: \(#line) error \(error)")
            }
        } catch {
            print("Function: \(#function), line: \(#line) error \(error)")
        }
    }
    
    func addCourses(courseName: String, courseLatitude: Double, courseLongitude: Double, courseTotalDistance: Double, courseTotalPar: Int, courseNumberOfHoles: Int, courseRating: Double) {
        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
            ).first!
        
        do {
            let db = try Connection("\(path)/courses.sqlite3")
            
            let courses = Table("courses")
            let id = Expression<Int64>("id")
            let name = Expression<String>("name")
            let latitude = Expression<Double>("latitude")
            let longitude = Expression<Double>("longitude")
            let rating = Expression<Double>("rating")
            let totalPar = Expression<Int>("totalPar")
            let numberOfHoles = Expression<Int>("numberOfHoles")
            let totalDistance = Expression<Double>("totalDistance")
        
            do {
                let _ = try db.run(courses.insert(name <- courseName, latitude <- courseLatitude, longitude <- courseLongitude, totalDistance <- courseTotalDistance, totalPar <- courseTotalPar, numberOfHoles <- courseNumberOfHoles, rating <- courseRating))
            } catch {
                print("Function: \(#function), line: \(#line) error \(error)")
            }
        } catch {
            print("Function: \(#function), line: \(#line) error \(error)")
        }
    }
    
    func createCourseTable() {
        
        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
            ).first!
        
        do {
            let db = try Connection("\(path)/courses.sqlite3")
            
            let courses = Table("courses")
            let id = Expression<Int64>("id")
            let name = Expression<String>("name")
            let latitude = Expression<Double>("latitude")
            let longitude = Expression<Double>("longitude")
            let rating = Expression<Double>("rating")
            let totalPar = Expression<Int>("totalPar")
            let numberOfHoles = Expression<Int>("numberOfHoles")
            let totalDistance = Expression<Double>("totalDistance")

            do {
                let _ = try db.run(courses.create { t in
                    t.column(id, primaryKey: .autoincrement)
                    t.column(name)
                    t.column(latitude)
                    t.column(longitude)
                    t.column(rating)
                    t.column(totalPar)
                    t.column(numberOfHoles)
                    t.column(totalDistance)
                })
            } catch {
                print("Function: \(#function), line: \(#line) error \(error)")
            }
        } catch {
            print("Function: \(#function), line: \(#line) error \(error)")
        }
    }
    
    func createHoleTable() {
        
        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
            ).first!
        
        do {
            let db = try Connection("\(path)/courses.sqlite3")
            
            let courses = Table("courses")
            let holes = Table("holes")
            let id = Expression<Int64>("id")
            let course_id = Expression<Int64>("couse_id")
            let tee1lat = Expression<Double>("tee1lat")
            let tee1long = Expression<Double>("tee1long")
            let tee2lat = Expression<Double>("tee2lat")
            let tee2long = Expression<Double>("tee2long")
            let tee3lat = Expression<Double>("tee3lat")
            let tee3long = Expression<Double>("tee3long")
            let basket1lat = Expression<Double>("basket1lat")
            let basket1long = Expression<Double>("basket1long")
            let basket2lat = Expression<Double>("basket2lat")
            let basket2long = Expression<Double>("basket2long")
            let basket3lat = Expression<Double>("basket3lat")
            let basket3long = Expression<Double>("basket3long")
            let par = Expression<Int>("par")
            
            do {
                let _ = try db.run(holes.create { t in
                    t.column(id, primaryKey: .autoincrement)
                    t.column(course_id)
//                    t.foreignKey(course_id, references: courses, id, delete: .setNull)
                    t.column(tee1lat)
                    t.column(tee1long)
                    t.column(tee2lat)
                    t.column(tee2long)
                    t.column(tee3lat)
                    t.column(tee3long)
                    t.column(basket1lat)
                    t.column(basket1long)
                    t.column(basket2lat)
                    t.column(basket2long)
                    t.column(basket3lat)
                    t.column(basket3long)
                    t.column(par)
                })
            } catch {
                print("Function: \(#function), line: \(#line) error \(error)")
            }
        } catch {
            print("Function: \(#function), line: \(#line) error \(error)")
        }
    }
    
    func addHole(holecourse_id: Int, holetee1lat: Double, holetee1long: Double, holetee2lat: Double, holetee2long: Double, holetee3lat: Double, holetee3long: Double, holebasket1lat: Double, holebasket1long: Double, holebasket2lat: Double, holebasket2long: Double, holebasket3lat: Double, holebasket3long: Double, holepar: Int) {
        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
            ).first!
        
        do {
            let db = try Connection("\(path)/courses.sqlite3")
            
            let courses = Table("courses")
            let holes = Table("holes")
            let id = Expression<Int64>("id")
            let course_id = Expression<Int64>("course_id")
            let tee1lat = Expression<Double>("tee1lat")
            let tee1long = Expression<Double>("tee1long")
            let tee2lat = Expression<Double>("tee2lat")
            let tee2long = Expression<Double>("tee2long")
            let tee3lat = Expression<Double>("tee3lat")
            let tee3long = Expression<Double>("tee3long")
            let basket1lat = Expression<Double>("basket1lat")
            let basket1long = Expression<Double>("basket1long")
            let basket2lat = Expression<Double>("basket2lat")
            let basket2long = Expression<Double>("basket2long")
            let basket3lat = Expression<Double>("basket3lat")
            let basket3long = Expression<Double>("basket3long")
            let par = Expression<Int>("par")
            
            do {
                let _ = try db.run(holes.insert(course_id <- Int64(holecourse_id), tee1lat <- holetee1lat, tee1long <- holetee1long, tee2lat <- holetee2lat, tee2long <- holetee2long, tee3lat <- holetee3lat, tee3long <- holetee3long, basket1lat <- holebasket1lat, basket1long <- holebasket1long, basket2lat <- holebasket2lat, basket2long <- holebasket2long, basket3lat <- holebasket3lat, basket3long <- holebasket3long, par <- holepar))
            } catch {
                print("Function: \(#function), line: \(#line) error \(error)")
            }
        } catch {
            print("Function: \(#function), line: \(#line) error \(error)")
        }
    }
    
    func getHoles() {
        
        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
            ).first!
        
        do {
            let db = try Connection("\(path)/courses.sqlite3")
            
            let courses = Table("courses")
            let holes = Table("holes")
            let id = Expression<Int64>("id")
            let course_id = Expression<Int64>("course_id")
            let tee1lat = Expression<Double>("tee1lat")
            let tee1long = Expression<Double>("tee1long")
            let tee2lat = Expression<Double>("tee2lat")
            let tee2long = Expression<Double>("tee2long")
            let tee3lat = Expression<Double>("tee3lat")
            let tee3long = Expression<Double>("tee3long")
            let basket1lat = Expression<Double>("basket1lat")
            let basket1long = Expression<Double>("basket1long")
            let basket2lat = Expression<Double>("basket2lat")
            let basket2long = Expression<Double>("basket2long")
            let basket3lat = Expression<Double>("basket3lat")
            let basket3long = Expression<Double>("basket3long")
            let par = Expression<Int>("par")
            
            do {
                let hs = try db.prepare(holes)
                
                for holes in hs {
                    print("id: \(holes[id]), course_id: \(holes[course_id]), tee1lat: \(holes[tee1lat]), tee1long: \(holes[tee1long]), tee2lat: \(holes[tee2lat]), tee2long: \(holes[tee2long]), tee3lat: \(holes[tee3lat]), tee3long: \(holes[tee3long]), basket2lat: \(holes[basket1lat]), basket1long: \(holes[basket1long]), basket2lat: \(holes[basket2lat]), basket2long: \(holes[basket2long]), basket3lat: \(holes[basket3lat]), basket3long: \(holes[basket3long]), par: \(holes[par])")
                }
            } catch {
                print("Function: \(#function), line: \(#line) error \(error)")
            }
        } catch {
            print("Function: \(#function), line: \(#line) error \(error)")
        }
    }
}
