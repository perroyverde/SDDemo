//
//  RealmHelper.swift
//  SDDemo
//  Created by José Ferré on 21/7/17.
//  Copyright © 2017 José Ferré. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

/// A generic REALM DAO with utils
@objc public class RealmHelper: NSObject {
    
    /// Inserts or updates any Realm object
    ///
    /// - Parameters:
    ///   - obj: Any Realm Object
    ///   - type: Realm object type. (e.g: Service.self)
    public static func insertOrUpdateObj <T : RealmSwift.Object> (obj: Object, _ type: T.Type) -> () {
        
        let realm = try! Realm()
        do {
            
            try realm.write { realm.create(type, value: obj, update: true) }
            
        } catch let error as NSError {
            
            dump("⛔️ Error upserting realm object \(obj): \(error.localizedDescription)")
        }
    }
    
    /// Inserts any Realm object
    ///
    /// - Parameters:
    ///   - obj: Any Realm Object
    ///   - type: Realm object type. (e.g: Service.self)
    public static func insertObj <T : RealmSwift.Object> (obj: Object, _ type: T.Type) -> () {
        
        let realm = try! Realm()
        do {
            
            try realm.write { realm.create(type, value: obj, update: false) }
            
        } catch let error as NSError {
            
            dump("⛔️ Error upserting realm object \(obj): \(error.localizedDescription)")
        }
    }
    
    
    /// Returns all Realm objects of defined type
    ///
    /// - Parameter ofType: Realm object type. (e.g: Service.self)
    /// - Returns: Nullable Results of desired type
    public static func getRealmObjects <T : RealmSwift.Object> (ofType: T.Type) -> Results<T>? {
        let realm = try! Realm()
        let tmpResults = realm.objects(T.self)
        
        if (tmpResults.count > 0) { return tmpResults }
        
        return nil
    }
    
    /// Deletes a single Realm object
    ///
    /// - Parameter obj: A Realm object
    public static func deleteSingleObj(obj: Object) -> () {
        
        let realm = try! Realm()
        do {
            
            try realm.write { realm.delete(obj) }
            
        } catch let error as NSError {
            dump("⛔️ Error deleting realm object \(obj): \(error.localizedDescription)")
        }
    }
    
    /// Deletes all Realm objects of defined type
    ///
    /// - Parameter ofType: Realm object type. (e.g: Service.self)
    public static func deleteAllObjects <T : RealmSwift.Object> (ofType: T.Type) {
        
        let realm = try! Realm()
        do {
            try realm.write {
                realm.delete(realm.objects(ofType))
                dump("💣 Deleted all realm objects of type: \(ofType)")
            }
        } catch let error as NSError {
             dump("⛔️ Error deleting realm objects of type \(ofType): \(error.localizedDescription)")
        }
    }
    
    /// Deletes ALL Realm objects in a Realm
    public static func wipeAllRealmData() {
        let realm = try! Realm()
        do {
            try realm.write {
                realm.deleteAll()
                dump("💣 Realm data successfuly wiped")
            }
        } catch let error as NSError {
            dump("⛔️ Error deleting user data in Logout: \(error.localizedDescription)")
        }
    }
}
