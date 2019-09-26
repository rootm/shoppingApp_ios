//
//  DbStore.swift
//  shopping_app
//
//  Created by Muvindu on 9/23/19.
//  Copyright © 2019 Muvindu. All rights reserved.
//

import Foundation
import os.log
import SQLite3

class DbStore {
    
    let dbURL: URL
   
    var db: OpaquePointer?
    
    var insertEntryStmt: OpaquePointer?
    var readEntryStmt: OpaquePointer?
    var readAllEntryStmt: OpaquePointer?

    var updateEntryStmt: OpaquePointer?
    var deleteEntryStmt: OpaquePointer?
    
    let oslog = OSLog(subsystem: "muvindu", category: "sqliteintegration")
    
    init() {
        do {
            do {
                dbURL = try FileManager.default
                    .url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                    .appendingPathComponent("product.db")
                os_log("URL: %s", dbURL.absoluteString)
            } catch {
                //TODO: Just logging the error and returning empty path URL here. Handle the error gracefully after logging
                os_log("Some error occurred. Returning empty path.")
                dbURL = URL(fileURLWithPath: "")
                return
            }
            
            try openDB()
            try createTables()
        } catch {
            //TODO: Handle the error gracefully after logging
            os_log("Some error occurred. Returning.")
            return
        }
    }
    
    // Command: sqlite3_open(dbURL.path, &db)
    // Open the DB at the given path. If file does not exists, it will create one for you
    func openDB() throws {
        if sqlite3_open(dbURL.path, &db) != SQLITE_OK { // error mostly because of corrupt database
            os_log("error opening database at %s", log: oslog, type: .error, dbURL.absoluteString)
            //            deleteDB(dbURL: dbURL)
            throw SqliteError(message: "error opening database \(dbURL.absoluteString)")
        }
    }
    
    // Code to delete a db file. Useful to invoke in case of a corrupt DB and re-create another
    func deleteDB(dbURL: URL) {
        os_log("removing db", log: oslog)
        do {
            try FileManager.default.removeItem(at: dbURL)
        } catch {
            os_log("exception while removing db %s", log: oslog, error.localizedDescription)
        }
    }
    
    func createTables() throws {
        // create the tables if they dont exist.
        
        // create the table to store the entries.
        // ID | Name | Employee Id | Designation
        
       
        
        let ret =  sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS ProductsTable (id INTEGER UNIQUE PRIMARY KEY AUTOINCREMENT, name VARCHAR(255), user VARCHAR(255), description VARCHAR(255), price VARCHAR(255) NOT NULL, photos VARCHAR(255), location VARCHAR(255))", nil, nil, nil)
        if (ret != SQLITE_OK) { // corrupt database.
            logDbErr("Error creating db table - Products")
            throw SqliteError(message: "unable to create table Products")
        }else{
            logDbErr("xxxxxxxxxxxxxxxxx")
        }
        
    }
    
    func logDbErr(_ msg: String) {
        let errmsg = String(cString: sqlite3_errmsg(db)!)
        os_log("ERROR %s : %s", log: oslog, type: .error, msg, errmsg)
    }
}

// Indicates an exception during a SQLite Operation.
class SqliteError : Error {
    var message = ""
    var error = SQLITE_ERROR
    init(message: String = "") {
        self.message = message
    }
    init(error: Int32) {
        self.error = error
    }
}
