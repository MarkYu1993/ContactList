//
//  SQLiteCommands.swift
//  ContactList
//
//  Created by MarkYu on 2022/3/3.
//

import Foundation
import SQLite
import SQLite3

class SQLiteCommands {
    static var table = Table("contact")
    
    // Expressions
    static let id = Expression<Int>("id")
    static let firstName = Expression<String>("firstName")
    static let lastName = Expression<String>("lastName")
    static let phoneNumber = Expression<String>("phoneNumber")
    static let photo = Expression<Data>("photo")
    
    // (C) Creating Table
    static func createTable(){
        guard let database = SQLiteDatabase.sharedInstance.database else {
            print("Datastore connection Error")
            return
        }
        do {
            // ifNotExist: true - Will Not Create a table if it already exists
            try database.run(table.create(ifNotExists: true){ table in
                table.column(id, primaryKey: true)
                table.column(firstName)
                table.column(lastName)
                table.column(phoneNumber, unique: true)
                table.column(photo)
            })

        } catch {
            print("Table already exists: \(error)")
        }
    }
    
    // (R) Present Rows
    static func presentRows() -> [Contact]? {
        guard let database = SQLiteDatabase.sharedInstance.database else {
            print("Datastore connection Error")
            return nil
        }
        
        // Contact Array
        var contactArray = [Contact]()
        
        // Sorting data in descending order by Id
        table = table.order(id.desc)
        
        do {
            for contact in try database.prepare(table) {
                let idValue = contact[id]
                let firstNameValue = contact[firstName]
                let lastNameValue = contact[lastName]
                let phoneNumberValue = contact[phoneNumber]
                let photoValue = contact[photo]
                
                // Create Object
                let contactObject = Contact(id: idValue,
                                            firstName: firstNameValue,
                                            lastName: lastNameValue,
                                            phoneNumber: phoneNumberValue,
                                            photo: photoValue)
                
                // Add object to an array
                contactArray.append(contactObject)
                
                print("id: \(contact[id]), firstName: \(contact[firstName]), lastName: \(contact[lastName]), phoneNumber: \(contact[phoneNumber]), photo: \(contact[photo])")
            }
        } catch {
            print("Present row error: \(error)")
        }
        return contactArray
    }
    
    // (U) Updating Rows
    static func updatingRow(_ contactValues: Contact) -> Bool? {
        guard let database = SQLiteDatabase.sharedInstance.database else {
            print("Datastore connection Error")
            return nil
        }
        
        // Extracts the appropriate contact from the table according to the id
        let contact = table.filter(id == contactValues.id).limit(1)
        
        do {
          // Update the contact's values
            if try database.run(contact.update(firstName <- contactValues.firstName,
                                               lastName <- contactValues.lastName,
                                               phoneNumber <- contactValues.phoneNumber,
                                               photo <- contactValues.photo)) > 0 {
                print("Updated contact")
                return true
            } else {
                print("Could not update contact: contact not found")
                return false
            }
        } catch let Result.error(message, code, statement) where code == SQLITE_CONSTRAINT {
            print("Update row failed: \(message), in \(String(describing: statement))")
            return false
        } catch let error {
            print("Update failed: \(error)")
            return false
        }
    }
    
    // (D) Delete Rows
    static func deleteRow(contactId: Int){
        guard let database = SQLiteDatabase.sharedInstance.database else {
            print("Datastore connection Error")
            return
        }
        
        do {
            let contact = table.filter(id == contactId).limit(1)
            try database.run(contact.delete())
        } catch {
            print("Delete row error: \(error)")
        }
    }
    
    // Inserting Row
    static func insertRow(_ contactValues: Contact) -> Bool? {
        guard let database = SQLiteDatabase.sharedInstance.database else {
            print("Datastore connection Error")
            return nil
        }
        do {
            try database.run(table.insert(firstName <- contactValues.firstName,
                                          lastName <- contactValues.lastName,
                                          phoneNumber <- contactValues.phoneNumber,
                                          photo <- contactValues.photo))
            return true
        } catch let Result.error(message, code, statement) where code == SQLITE_CONSTRAINT {
            print("Insert Row Failed:\(message), in\(String(describing: statement))")
            return false
        } catch let error {
            print("Insertion Failed: \(error)")
            return false
        }
    }
    

}
