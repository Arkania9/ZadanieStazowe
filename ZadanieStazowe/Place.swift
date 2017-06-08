//
//  Place.swift
//  ZadanieStazowe
//
//  Created by Kamil Zajac on 08.06.2017.
//  Copyright © 2017 Kamil Zajac. All rights reserved.
//

import Foundation
import RealmSwift

class Place: Object {
    
    dynamic var id: String = ""
    dynamic var avatar: String = ""
    dynamic var latitude: Double = 0.0
    dynamic var longitude: Double = 0.0
    dynamic var name: String = ""
    
    convenience init(id: String, avatar: String, latitude: Double, longitude: Double, name: String) {
        self.init()
        self.id = id
        self.avatar = avatar
        self.latitude = latitude
        self.longitude = longitude
        self.name = name
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
}
