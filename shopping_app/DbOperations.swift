//
//  DbOperations.swift
//  shopping_app
//
//  Created by Muvindu on 9/23/19.
//  Copyright © 2019 Muvindu. All rights reserved.
//

import Foundation
import SQLite3

extension DbStore {
    func create(record: productModel) {
        // ensure statements are created on first usage if nil
        guard self.prepareInsertEntryStmt() == SQLITE_OK else { return }

        defer {
            // reset the prepared statement on exit.
            sqlite3_reset(self.insertEntryStmt)
        }
       if sqlite3_bind_text(self.insertEntryStmt, 1, (record.name as NSString).utf8String, -1, nil) != SQLITE_OK {
            logDbErr("sqlite3_bind_text(insertEntryStmt)")
            return
        }

        if sqlite3_bind_text(self.insertEntryStmt, 2, (record.user as NSString).utf8String, -1, nil) != SQLITE_OK {
            logDbErr("sqlite3_bind_text(insertEntryStmt)")
            return
        }

        if sqlite3_bind_text(self.insertEntryStmt, 3, (record.description as NSString).utf8String, -1, nil) != SQLITE_OK {
            logDbErr("sqlite3_bind_text(insertEntryStmt)")
            return
        }
        
        if sqlite3_bind_text(self.insertEntryStmt, 4, (record.price as NSString).utf8String, -1, nil) != SQLITE_OK {
            logDbErr("sqlite3_bind_text(insertEntryStmt)")
            return
        }

        if sqlite3_bind_text(self.insertEntryStmt, 5, (record.photos as NSString).utf8String, -1, nil) != SQLITE_OK {
            logDbErr("sqlite3_bind_text(insertEntryStmt)")
            return
        }

        if sqlite3_bind_text(self.insertEntryStmt, 6, (record.location as NSString).utf8String, -1, nil) != SQLITE_OK {
            logDbErr("sqlite3_bind_text(insertEntryStmt)")
            return
        }

        //executing the query to insert values
        let r = sqlite3_step(self.insertEntryStmt)
        if r != SQLITE_DONE {
            logDbErr("sqlite3_step(insertEntryStmt) \(r)")
            return
        }
    }

    func read(id: String) throws -> productModel {
        // ensure statements are created on first usage if nil
        guard self.prepareReadEntryStmt() == SQLITE_OK else { throw SqliteError(message: "Error in prepareReadEntryStmt") }

        defer {
            // reset the prepared statement on exit.
            sqlite3_reset(self.readEntryStmt)
        }

      
        if sqlite3_bind_text(self.readEntryStmt, 1, (id as NSString).utf8String, -1, nil) != SQLITE_OK {
            logDbErr("sqlite3_bind_text(readEntryStmt)")
            throw SqliteError(message: "Error in inserting value in prepareReadEntryStmt")
        }

        //executing the query to read value
        if sqlite3_step(readEntryStmt) != SQLITE_ROW {
            logDbErr("sqlite3_step COUNT* readEntryStmt:")
            throw SqliteError(message: "Error in executing read statement")
        }


        
        return productModel(name: String(cString: sqlite3_column_text(readEntryStmt, 1)),
                      user: String(cString: sqlite3_column_text(readEntryStmt, 2)),
                      description: String(cString: sqlite3_column_text(readEntryStmt, 3)),
                      price: String(cString: sqlite3_column_text(readEntryStmt, 4)),
                      photos: String(cString: sqlite3_column_text(readEntryStmt, 5)),
                      location: String(cString: sqlite3_column_text(readEntryStmt, 6)))
    }
    
    
    func readAll() throws -> [productModel] {
        var products = [productModel]()
        guard self.prepareReadAllEntryStmt() == SQLITE_OK else { throw SqliteError(message: "Error in prepareReadEntryStmt") }
        
        defer {
            // reset the prepared statement on exit.
            sqlite3_reset(self.readAllEntryStmt)
        }
        
        
        
        do{
            while sqlite3_step(readAllEntryStmt) == SQLITE_ROW {
                products.append(productModel(name: String(cString: sqlite3_column_text(readAllEntryStmt, 1)),
                                             user: String(cString: sqlite3_column_text(readAllEntryStmt, 2)),
                                             description: String(cString: sqlite3_column_text(readAllEntryStmt, 3)),
                                             price: String(cString: sqlite3_column_text(readAllEntryStmt, 4)),
                                             photos: String(cString: sqlite3_column_text(readAllEntryStmt, 5)),
                                             location: String(cString: sqlite3_column_text(readAllEntryStmt, 6))))
            }
        }
    catch {
        self.logDbErr("sqlite3_step COUNT* readEntryStmt: /error")

        
    }        //executing the query to read value
    
        
        
        
        return products
    }
    

   
    
    
    func deleteAll() throws {
      
        guard self.prepareDeleteEntryStmt() == SQLITE_OK else { throw SqliteError(message: "Error in prepareReadEntryStmt") }
        
        defer {
            // reset the prepared statement on exit.
            sqlite3_reset(self.deleteEntryStmt)
        }
        
        
        
        do{
           sqlite3_step(deleteEntryStmt)
        }
        catch {
            self.logDbErr("sqlite3_step COUNT* readEntryStmt: /error")
            
            
        }        //executing the query to read value
        
        
        }
    
    

    // INSERT/CREATE operation prepared statement
    func prepareInsertEntryStmt() -> Int32 {
        guard insertEntryStmt == nil else { return SQLITE_OK }
        
      
        let sql = "INSERT INTO ProductsTable(name, user, description, price, photos, location) VALUES (?,?,?,?,?,?)"
        //preparing the query
        let r = sqlite3_prepare(db, sql, -1, &insertEntryStmt, nil)
        if  r != SQLITE_OK {
            logDbErr("sqlite3_prepare insertEntryStmt")
        }
        return r
    }

    // READ operation prepared statement
    func prepareReadEntryStmt() -> Int32 {
        guard readEntryStmt == nil else { return SQLITE_OK }
        let sql = "SELECT * FROM ProductsTable WHERE id = ? LIMIT 1"
        //preparing the query
        let r = sqlite3_prepare(db, sql, -1, &readEntryStmt, nil)
        if  r != SQLITE_OK {
            logDbErr("sqlite3_prepare readEntryStmt")
        }
        return r
    }

    // READ operation prepared statement
    func prepareReadAllEntryStmt() -> Int32 {
        guard readAllEntryStmt == nil else { return SQLITE_OK }
        let sql = "SELECT * FROM ProductsTable"
        //preparing the query
        let r = sqlite3_prepare(db, sql, -1, &readAllEntryStmt, nil)
        if  r != SQLITE_OK {
            logDbErr("sqlite3_prepare readEntryStmt")
        }
        return r
    }
    
    // UPDATE operation prepared statement
    func prepareUpdateEntryStmt() -> Int32 {
        guard updateEntryStmt == nil else { return SQLITE_OK }
        let sql = "UPDATE ProductsTable SET Name = ?, Designation = ? WHERE EmployeeID = ?"
        //preparing the query
        let r = sqlite3_prepare(db, sql, -1, &updateEntryStmt, nil)
        if  r != SQLITE_OK {
            logDbErr("sqlite3_prepare updateEntryStmt")
        }
        return r
    }

    // DELETE operation prepared statement
    func prepareDeleteEntryStmt() -> Int32 {
        guard deleteEntryStmt == nil else { return SQLITE_OK }
        let sql = "DROP TABLE ProductsTable"
        //preparing the query
        let r = sqlite3_prepare(db, sql, -1, &deleteEntryStmt, nil)
        if  r != SQLITE_OK {
            logDbErr("sqlite3_prepare deleteEntryStmt")
        }
        return r
    }
    
    func insert(record: productModel) {
        
        let insertStatementString = "INSERT INTO ProductsTable(name, user, description, price, photos, location) VALUES (?,?,?,?,?,?)"

        var insertStatement: OpaquePointer? = nil
        
        // 1
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
           
            sqlite3_bind_text(insertStatement, 1, (record.name as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 2, (record.user as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 3, (record.description as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 4, (record.price as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 5, (record.photos as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 6, (record.location as NSString).utf8String, -1, nil)

            // 4
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row.")
            } else {
                print("Could not insert row.")
            }
        } else {
            print("INSERT statement could not be prepared.")
        }
        // 5
        sqlite3_finalize(insertStatement)
    }
    
}

