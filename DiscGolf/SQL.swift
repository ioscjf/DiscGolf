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
    
    // MARK: - Courses
    
    func getCourses() {
        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
            ).first!
        
        do {
            let db = try Connection("\(path)/courses.sqlite3")
            
            let courses = Table("courses")
            let id = Expression<Int>("id")
            let name = Expression<String>("name")
            let latitude = Expression<Double>("latitude")
            let longitude = Expression<Double>("longitude")
            let rating = Expression<Double>("rating")
            let totalPar = Expression<Int>("totalPar")
            let numberOfHoles = Expression<Int>("numberOfHoles")
            let totalDistance = Expression<Double>("totalDistance")
            let isUploaded = Expression<Bool>("isUploaded")
            
            do {
                let cs = try db.prepare(courses)
                
                for course in cs {
                    print("id: \(course[id]), name: \(course[name]), latitude: \(course[latitude]), longitude: \(course[longitude]), totalDistance: \(course[totalDistance]), totalPar: \(course[totalPar]), numberOfHoles: \(course[numberOfHoles]), rating: \(course[rating]), isUploaded: \(course[isUploaded])")
                }
            } catch {
                print("Function: \(#function), line: \(#line) error \(error)")
            }
        } catch {
            print("Function: \(#function), line: \(#line) error \(error)")
        }
    }
    
    func addCourses(courseName: String, courseLatitude: Double, courseLongitude: Double, courseTotalDistance: Double, courseTotalPar: Int, courseNumberOfHoles: Int, courseRating: Double, courseIsUploaded: Bool) -> Int? {
        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
            ).first!
        
        do {
            let db = try Connection("\(path)/courses.sqlite3")
            
            let courses = Table("courses")
            let name = Expression<String>("name")
            let latitude = Expression<Double>("latitude")
            let longitude = Expression<Double>("longitude")
            let rating = Expression<Double>("rating")
            let totalPar = Expression<Int>("totalPar")
            let numberOfHoles = Expression<Int>("numberOfHoles")
            let totalDistance = Expression<Double>("totalDistance")
            let isUploaded = Expression<Bool>("isUploaded")
        
            do {
                let id = try db.run(courses.insert(name <- courseName, latitude <- courseLatitude, longitude <- courseLongitude, totalDistance <- courseTotalDistance, totalPar <- courseTotalPar, numberOfHoles <- courseNumberOfHoles, rating <- courseRating, isUploaded <- courseIsUploaded))
                
                return Int(id)
            } catch {
                print("Function: \(#function), line: \(#line) error \(error)")
            }
        } catch {
            print("Function: \(#function), line: \(#line) error \(error)")
        }
        return nil
    }
    
    func createCourseTable() {
        
        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
            ).first!
        
        do {
            let db = try Connection("\(path)/courses.sqlite3")
            
            let courses = Table("courses")
            let id = Expression<Int>("id")
            let name = Expression<String>("name")
            let latitude = Expression<Double>("latitude")
            let longitude = Expression<Double>("longitude")
            let rating = Expression<Double>("rating")
            let totalPar = Expression<Int>("totalPar")
            let numberOfHoles = Expression<Int>("numberOfHoles")
            let totalDistance = Expression<Double>("totalDistance")
            let isUploaded = Expression<Bool>("isUploaded")
            
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
                    t.column(isUploaded)
                })
            } catch {
                print("Function: \(#function), line: \(#line) error \(error)")
            }
        } catch {
            print("Function: \(#function), line: \(#line) error \(error)")
        }
    }
    
    func updateCourse(idNum: Int, courseName: String, courseLatitude: Double, courseLongitude: Double, courseRating: Double, courseTotalPar: Int, courseNumberOfHoles: Int, courseTotalDistance: Double, courseIsUploaded: Bool) {
        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
            ).first!
        
        do {
            let db = try Connection("\(path)/courses.sqlite3")
            let courses = Table("courses")
            let id = Expression<Int>("id")
            let name = Expression<String>("name")
            let latitude = Expression<Double>("latitude")
            let longitude = Expression<Double>("longitude")
            let rating = Expression<Double>("rating")
            let totalPar = Expression<Int>("totalPar")
            let numberOfHoles = Expression<Int>("numberOfHoles")
            let totalDistance = Expression<Double>("totalDistance")
            let isUploaded = Expression<Bool>("isUploaded")
            
            let course = courses.filter(id == idNum)
            do {
                try db.run(course.update(name <- courseName, latitude <- courseLatitude, longitude <- courseLongitude, rating <- courseRating, totalPar <- courseTotalPar, numberOfHoles <- courseNumberOfHoles, totalDistance <- courseTotalDistance, isUploaded <- courseIsUploaded))
            } catch {
                print("Function: \(#function), line: \(#line) error \(error)")
            }
        } catch {
            print("Function: \(#function), line: \(#line) error \(error)")
        }
    }
    
    func getCourse(courseID: Int) -> [String: AnyObject] {
        let courses = Table("courses")
        let id = Expression<Int>("id")
        let name = Expression<String>("name")
        let latitude = Expression<Double>("latitude")
        let longitude = Expression<Double>("longitude")
        let rating = Expression<Double>("rating")
        let totalPar = Expression<Int>("totalPar")
        let numberOfHoles = Expression<Int>("numberOfHoles")
        let totalDistance = Expression<Double>("totalDistance")
        let isUploaded = Expression<Bool>("isUploaded")
        let query = courses.select(name, latitude, longitude, rating, totalPar, numberOfHoles, totalDistance, isUploaded)           // SELECT * FROM "courses"
            .filter(id == courseID)                   // WHERE courses.id == "courseID"
        
        var dict = [String: AnyObject]()
        dict["name"] = query[name] as AnyObject
        dict["latitude"] = query[latitude] as AnyObject
        dict["longitude"] = query[longitude] as AnyObject
        dict["rating"] = query[rating] as AnyObject
        dict["totalPar"] = query[totalPar] as AnyObject
        dict["numberOfHoles"] = query[numberOfHoles] as AnyObject
        dict["totalDistance"] = query[totalDistance] as AnyObject
        dict["isUploaded"] = query[isUploaded] as AnyObject
        
        return dict
    }
    
    func dropCourseTable() {
        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
            ).first!
        
        do {
            let db = try Connection("\(path)/courses.sqlite3")
            let courses = Table("courses")
            
            do {
                try db.run(courses.drop())
                
            } catch {
                print("Funciton: \(#function), line: \(#line) error \(error)")
            }
        } catch {
            print("Funciton: \(#function), line: \(#line) error \(error)")
        }
    }
    
    // MARK: - Scores
    // missing update, get all scores, drop scores table
    
    func addScores(somegame_id: Int, someplayerName: String, sometotalScore: Int, somebestDrive: Double) -> Int? {
        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
            ).first!
        
        do {
            let db = try Connection("\(path)/courses.sqlite3")
            
            let scores = Table("scores")
            let game_id = Expression<Int>("game_id")
            let playerName = Expression<String>("playerName")
            let totalScore = Expression<Int>("totalScore")
            let bestDrive = Expression<Double>("bestDrive")
            
            do {
                let id = try db.run(scores.insert(game_id <- somegame_id, playerName <- someplayerName, totalScore <- sometotalScore, bestDrive <- somebestDrive))
                
                return Int(id)
            } catch {
                print("Function: \(#function), line: \(#line) error \(error)")
            }
        } catch {
            print("Function: \(#function), line: \(#line) error \(error)")
        }
        return nil
    }
    
    func createScoresTable() {
        
        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
            ).first!
        
        do {
            let db = try Connection("\(path)/courses.sqlite3")
            
            let games = Table("games")
            let scores = Table("scores")
            let id = Expression<Int>("id")
            let playerName = Expression<String>("name")
            let game_id = Expression<Int>("game_id")
            let totalScore = Expression<Int>("totalScore") // in a future update, keep track of the score of each hole!!
            let bestDrive = Expression<Double>("bestDrive")
            
            do {
                let _ = try db.run(scores.create { t in
                    t.column(id, primaryKey: .autoincrement)
                    t.column(game_id)
                    t.column(playerName)
                    t.column(totalScore)
                    t.column(bestDrive)
                    t.foreignKey(game_id, references: games, id, delete: .setNull)
                })
            } catch {
                print("Function: \(#function), line: \(#line) error \(error)")
            }
        } catch {
            print("Function: \(#function), line: \(#line) error \(error)")
        }
    }
    
    // MARK: - Games
    // missing update, get all games, drop games table
    
    func createGameTable() {
        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
            ).first!
        
        do {
            let db = try Connection("\(path)/courses.sqlite3")
            
            let games = Table("games")
            let courses = Table("courses")
            let scores = Table("scores")
            let id = Expression<Int>("id")
            let player_id = Expression<Int>("player_id")
            let course_id = Expression<Int>("course_id")
            let gameNum = Expression<Int>("gameNum")
            
            do {
                let _ = try db.run(games.create { t in
                    t.column(id, primaryKey: .autoincrement)
                    t.column(course_id)
                    t.column(player_id)
                    t.column(gameNum)
                    t.foreignKey(course_id, references: courses, id, delete: .setNull)
                    t.foreignKey(player_id, references: scores, id, delete: .setNull)
                })
            } catch {
                print("Function: \(#function), line: \(#line) error \(error)")
            }
        } catch {
            print("Function: \(#function), line: \(#line) error \(error)")
        }
    }
    
    func addGames(somegameNum: Int, someplayer_id: Int, somecourse_id: Int) -> Int? {
        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
            ).first!
        
        do {
            let db = try Connection("\(path)/courses.sqlite3")
            
            let games = Table("games")
            let player_id = Expression<Int>("player_id")
            let course_id = Expression<Int>("course_id")
            let gameNum = Expression<Int>("gameNum")
            
            do {
                let id = try db.run(games.insert(player_id <- someplayer_id, course_id <- somecourse_id, gameNum <- somegameNum))
                
                return Int(id)
            } catch {
                print("Function: \(#function), line: \(#line) error \(error)")
            }
        } catch {
            print("Function: \(#function), line: \(#line) error \(error)")
        }
        return nil
    }
    
    // MARK: - Holes
    
    func updateHole(idNum: Int, holecourse_id: Int, holetee1lat: Double, holetee1long: Double, holetee2lat: Double, holetee2long: Double, holetee3lat: Double, holetee3long: Double, holebasket1lat: Double, holebasket1long: Double, holebasket2lat: Double, holebasket2long: Double, holebasket3lat: Double, holebasket3long: Double, holepar: Int, holetee1picPath: String, holetee2picPath: String, holetee3picPath: String, holebasket1picPath: String, holebasket2picPath: String, holebasket3picPath: String) {
        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
            ).first!
        
        do {
            let db = try Connection("\(path)/courses.sqlite3")
            
            let holes = Table("holes")
            let id = Expression<Int>("id")
            let course_id = Expression<Int>("course_id")
            let tee1picPath = Expression<String>("tee1picPath")
            let tee1lat = Expression<Double>("tee1lat")
            let tee1long = Expression<Double>("tee1long")
            let tee2picPath = Expression<String>("tee2picPath")
            let tee2lat = Expression<Double>("tee2lat")
            let tee2long = Expression<Double>("tee2long")
            let tee3picPath = Expression<String>("tee3picPath")
            let tee3lat = Expression<Double>("tee3lat")
            let tee3long = Expression<Double>("tee3long")
            let basket1picPath = Expression<String>("basket1picPath")
            let basket1lat = Expression<Double>("basket1lat")
            let basket1long = Expression<Double>("basket1long")
            let basket2picPath = Expression<String>("basket2picPath")
            let basket2lat = Expression<Double>("basket2lat")
            let basket2long = Expression<Double>("basket2long")
            let basket3picPath = Expression<String>("basket3picPath")
            let basket3lat = Expression<Double>("basket3lat")
            let basket3long = Expression<Double>("basket3long")
            let par = Expression<Int>("par")
            
            let hole = holes.filter(id == idNum)
            do {
                try db.run(hole.update(course_id <- Int(holecourse_id), tee1lat <- holetee1lat, tee1long <- holetee1long, tee2lat <- holetee2lat, tee2long <- holetee2long, tee3lat <- holetee3lat, tee3long <- holetee3long, basket1lat <- holebasket1lat, basket1long <- holebasket1long, basket2lat <- holebasket2lat, basket2long <- holebasket2long, basket3lat <- holebasket3lat, basket3long <- holebasket3long, par <- holepar, tee1picPath <- holetee1picPath, tee2picPath <- holetee2picPath, tee3picPath <- holetee3picPath, basket1picPath <- holebasket1picPath, basket2picPath <- holebasket2picPath, basket3picPath <- holebasket3picPath))
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
            let id = Expression<Int>("id")
            let course_id = Expression<Int>("course_id")
            let tee1picPath = Expression<String>("tee1picPath")
            let tee1lat = Expression<Double>("tee1lat")
            let tee1long = Expression<Double>("tee1long")
            let tee2picPath = Expression<String>("tee2picPath")
            let tee2lat = Expression<Double>("tee2lat")
            let tee2long = Expression<Double>("tee2long")
            let tee3picPath = Expression<String>("tee3picPath")
            let tee3lat = Expression<Double>("tee3lat")
            let tee3long = Expression<Double>("tee3long")
            let basket1picPath = Expression<String>("basket1picPath")
            let basket1lat = Expression<Double>("basket1lat")
            let basket1long = Expression<Double>("basket1long")
            let basket2picPath = Expression<String>("basket2picPath")
            let basket2lat = Expression<Double>("basket2lat")
            let basket2long = Expression<Double>("basket2long")
            let basket3picPath = Expression<String>("basket3picPath")
            let basket3lat = Expression<Double>("basket3lat")
            let basket3long = Expression<Double>("basket3long")
            let par = Expression<Int>("par")
            
            do {
                let _ = try db.run(holes.create { t in
                    t.column(id, primaryKey: .autoincrement)
                    t.column(course_id)
                    t.column(tee1picPath)
                    t.column(tee1lat)
                    t.column(tee1long)
                    t.column(tee2picPath)
                    t.column(tee2lat)
                    t.column(tee2long)
                    t.column(tee3picPath)
                    t.column(tee3lat)
                    t.column(tee3long)
                    t.column(basket1picPath)
                    t.column(basket1lat)
                    t.column(basket1long)
                    t.column(basket2picPath)
                    t.column(basket2lat)
                    t.column(basket2long)
                    t.column(basket3picPath)
                    t.column(basket3lat)
                    t.column(basket3long)
                    t.column(par)
                    t.foreignKey(course_id, references: courses, id, delete: .setNull)
                })
            } catch {
                print("Function: \(#function), line: \(#line) error \(error)")
            }
        } catch {
            print("Function: \(#function), line: \(#line) error \(error)")
        }
    }
    
    func addHole(holecourse_id: Int, holetee1lat: Double, holetee1long: Double, holetee2lat: Double, holetee2long: Double, holetee3lat: Double, holetee3long: Double, holebasket1lat: Double, holebasket1long: Double, holebasket2lat: Double, holebasket2long: Double, holebasket3lat: Double, holebasket3long: Double, holepar: Int, holetee1picPath: String, holetee2picPath: String, holetee3picPath: String, holebasket1picPath: String, holebasket2picPath: String, holebasket3picPath: String) -> Int? {
        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
            ).first!
        
        do {
            let db = try Connection("\(path)/courses.sqlite3")
            
            let holes = Table("holes")
            let course_id = Expression<Int>("course_id")
            let tee1picPath = Expression<String>("tee1picPath")
            let tee1lat = Expression<Double>("tee1lat")
            let tee1long = Expression<Double>("tee1long")
            let tee2picPath = Expression<String>("tee2picPath")
            let tee2lat = Expression<Double>("tee2lat")
            let tee2long = Expression<Double>("tee2long")
            let tee3picPath = Expression<String>("tee3picPath")
            let tee3lat = Expression<Double>("tee3lat")
            let tee3long = Expression<Double>("tee3long")
            let basket1picPath = Expression<String>("basket1picPath")
            let basket1lat = Expression<Double>("basket1lat")
            let basket1long = Expression<Double>("basket1long")
            let basket2picPath = Expression<String>("basket2picPath")
            let basket2lat = Expression<Double>("basket2lat")
            let basket2long = Expression<Double>("basket2long")
            let basket3picPath = Expression<String>("basket3picPath")
            let basket3lat = Expression<Double>("basket3lat")
            let basket3long = Expression<Double>("basket3long")
            let par = Expression<Int>("par")
            
            do {
                let id = try db.run(holes.insert(course_id <- Int(holecourse_id), tee1lat <- holetee1lat, tee1long <- holetee1long, tee2lat <- holetee2lat, tee2long <- holetee2long, tee3lat <- holetee3lat, tee3long <- holetee3long, basket1lat <- holebasket1lat, basket1long <- holebasket1long, basket2lat <- holebasket2lat, basket2long <- holebasket2long, basket3lat <- holebasket3lat, basket3long <- holebasket3long, par <- holepar, tee1picPath <- holetee1picPath, tee2picPath <- holetee2picPath, tee3picPath <- holetee3picPath, basket1picPath <- holebasket1picPath, basket2picPath <- holebasket2picPath, basket3picPath <- holebasket3picPath))
                
                return Int(id)
            } catch {
                print("Function: \(#function), line: \(#line) error \(error)")
            }
        } catch {
            print("Function: \(#function), line: \(#line) error \(error)")
        }
        return nil
    }
    
    func getHole(holeId: Int) -> [String: AnyObject] {
        let holes = Table("holes")
        let id = Expression<Int>("id")
        let course_id = Expression<Int>("course_id")
        let tee1picPath = Expression<String>("tee1picPath")
        let tee1lat = Expression<Double>("tee1lat")
        let tee1long = Expression<Double>("tee1long")
        let tee2picPath = Expression<String>("tee2picPath")
        let tee2lat = Expression<Double>("tee2lat")
        let tee2long = Expression<Double>("tee2long")
        let tee3picPath = Expression<String>("tee3picPath")
        let tee3lat = Expression<Double>("tee3lat")
        let tee3long = Expression<Double>("tee3long")
        let basket1picPath = Expression<String>("basket1picPath")
        let basket1lat = Expression<Double>("basket1lat")
        let basket1long = Expression<Double>("basket1long")
        let basket2picPath = Expression<String>("basket2picPath")
        let basket2lat = Expression<Double>("basket2lat")
        let basket2long = Expression<Double>("basket2long")
        let basket3picPath = Expression<String>("basket3picPath")
        let basket3lat = Expression<Double>("basket3lat")
        let basket3long = Expression<Double>("basket3long")
        let par = Expression<Int>("par")
        let query = holes.select(course_id, tee1picPath, tee1lat, tee1long, tee2picPath, tee2lat, tee2long, tee3picPath, tee3lat, tee3long, basket1picPath, basket1lat, basket1long, basket2picPath, basket2lat, basket2long, basket3picPath, basket3lat, basket3long, par)           // SELECT * FROM "holes"
            .filter(id == holeId)                   // WHERE holes.id == "holeID"
            
        var dict = [String: AnyObject]()
        dict["courseID"] = query[course_id] as AnyObject
        dict["tee1picPath"] = query[tee1picPath] as AnyObject
        dict["tee1lat"] = query[tee1lat] as AnyObject
        dict["tee1long"] = query[tee1long] as AnyObject
        dict["tee2picPath"] = query[tee2picPath] as AnyObject
        dict["tee2lat"] = query[tee2lat] as AnyObject
        dict["tee2long"] = query[tee2long] as AnyObject
        dict["tee3picPath"] = query[tee3picPath] as AnyObject
        dict["tee3lat"] = query[tee3lat] as AnyObject
        dict["tee3long"] = query[tee3long] as AnyObject
        dict["basket1picPath"] = query[basket1picPath] as AnyObject
        dict["basket1lat"] = query[basket1lat] as AnyObject
        dict["basket1long"] = query[basket1long] as AnyObject
        dict["basket2picPath"] = query[basket2picPath] as AnyObject
        dict["basket2lat"] = query[basket2lat] as AnyObject
        dict["basket2long"] = query[basket2long] as AnyObject
        dict["basket3picPath"] = query[basket3picPath] as AnyObject
        dict["basket3lat"] = query[basket3lat] as AnyObject
        dict["basket3long"] = query[basket3long] as AnyObject
        dict["par"] = query[par] as AnyObject
        
        return dict
    }
    
    func getHoles() {
        
        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
            ).first!
        
        do {
            let db = try Connection("\(path)/courses.sqlite3")
            
            let holes = Table("holes")
            let id = Expression<Int>("id")
            let course_id = Expression<Int>("course_id")
            let tee1picPath = Expression<String>("tee1picPath")
            let tee1lat = Expression<Double>("tee1lat")
            let tee1long = Expression<Double>("tee1long")
            let tee2picPath = Expression<String>("tee2picPath")
            let tee2lat = Expression<Double>("tee2lat")
            let tee2long = Expression<Double>("tee2long")
            let tee3picPath = Expression<String>("tee3picPath")
            let tee3lat = Expression<Double>("tee3lat")
            let tee3long = Expression<Double>("tee3long")
            let basket1picPath = Expression<String>("basket1picPath")
            let basket1lat = Expression<Double>("basket1lat")
            let basket1long = Expression<Double>("basket1long")
            let basket2picPath = Expression<String>("basket2picPath")
            let basket2lat = Expression<Double>("basket2lat")
            let basket2long = Expression<Double>("basket2long")
            let basket3picPath = Expression<String>("basket3picPath")
            let basket3lat = Expression<Double>("basket3lat")
            let basket3long = Expression<Double>("basket3long")
            let par = Expression<Int>("par")
            
            do {
                let hs = try db.prepare(holes)
                
                for holes in hs {
                    print("id: \(holes[id]), course_id: \(holes[course_id]), tee1lat: \(holes[tee1lat]), tee1long: \(holes[tee1long]), tee2lat: \(holes[tee2lat]), tee2long: \(holes[tee2long]), tee3lat: \(holes[tee3lat]), tee3long: \(holes[tee3long]), basket1lat: \(holes[basket1lat]), basket1long: \(holes[basket1long]), basket2lat: \(holes[basket2lat]), basket2long: \(holes[basket2long]), basket3lat: \(holes[basket3lat]), basket3long: \(holes[basket3long]), par: \(holes[par]), tee1picPath: \(holes[tee1picPath]), tee2picPath: \(holes[tee2picPath]), tee3picPath: \(holes[tee3picPath]), basket1picPath: \(holes[basket1picPath]), basket2picPath: \(holes[basket2picPath]), basket3picPath: \(holes[basket3picPath])")
                }
            } catch {
                print("Function: \(#function), line: \(#line) error \(error)")
            }
        } catch {
            print("Function: \(#function), line: \(#line) error \(error)")
        }
    }
    
    func dropHoleTable() {
        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
            ).first!
        
        do {
            let db = try Connection("\(path)/courses.sqlite3")
            let holes = Table("holes")
            
            do {
                try db.run(holes.drop())
                
            } catch {
                print("Funciton: \(#function), line: \(#line) error \(error)")
            }
        } catch {
            print("Funciton: \(#function), line: \(#line) error \(error)")
        }
    }
}
