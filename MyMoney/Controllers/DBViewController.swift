//
//  DBViewController.swift
//  MyMoney
//
//  Created by Dilyana Yankova on 21.06.19.
//  Copyright © 2019 Dilyana Yankova. All rights reserved.
//

//This file is not used. It will be if we need a database
import SQLite3
import UIKit

class DBViewController: UIViewController {
    
    var db: OpaquePointer?
    var tableViewHeroes: UITableView!
    var textFieldName: UITextField!
    var textFieldPowerRanking: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("MyMoneyDatabase.sqlite")
        
        //opening the database
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("error opening database")
        }
        
        //creating table
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS AllMoney (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, powerrank INTEGER)", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table: \(errmsg)")
        }
        
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS Crypto (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, amount DOUBLE, singlePrice INTEGER, totalPrice DOUBLE )", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table: \(errmsg)")
        }
        
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS Stocks (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, amount DOUBLE, singlePrice INTEGER, totalPrice DOUBLE )", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table: \(errmsg)")
        }
        
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS Gold (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, amount DOUBLE, singlePrice INTEGER, totalPrice DOUBLE )", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table: \(errmsg)")
        }
        
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS Currency (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, amount DOUBLE, singlePrice INTEGER, totalPrice DOUBLE )", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table: \(errmsg)")
        }
    }
    
}

