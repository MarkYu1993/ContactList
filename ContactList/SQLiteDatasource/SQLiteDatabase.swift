//
//  SQLiteDatabase.swift
//  ContactList
//
//  Created by MarkYu on 2022/3/3.
//

import Foundation
import SQLite

class SQLiteDatabase {
    static let sharedInstance = SQLiteDatabase()
    var database: Connection?
    
    private init() {
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("contactList").appendingPathExtension("sqlite3")
            database = try Connection(fileUrl.path)
        } catch {
            print("Creating Connection to database error:\(error.localizedDescription)")
        }
    }
    
    // Creating Table
    
    func createTable(){
        SQLiteCommands.createTable()
    }
}
