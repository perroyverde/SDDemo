//
//  RealmBaseObject.swift
//  SDDemo
//
//  Created by José Ferré on 21/7/17.
//  Copyright © 2017 José Ferré. All rights reserved.
//
import Foundation
import ObjectMapper
import RealmSwift
import ObjectMapper_Realm

/// Base Realm Object to be used as parent in all the new Realm Objects. Capable of mapping arrays<T> to List<T>
open class RealmBaseObject: Object, Mappable {
    
    static public let PK_SEPARATOR = ":"
    
    required convenience public init?(map: Map) { self.init() }
    open func mapping(map: Map) { dump("‼️ \(#file).\(#function) should be overweitten by its subclass") }
}

/// Maps object of Realm's List type
public func <- <T: Mappable>(left: List<T>, right: Map)
{
    var array: [T]?
    
    if right.mappingType == .toJSON { array = Array(left) }
    
    array <- right
    
    if right.mappingType == .fromJSON {
        if let theArray = array { left.append(objectsIn: theArray) }
    }
}
