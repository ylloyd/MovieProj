//
//  Cast.swift
//  MovieProj
//
//  Created by Yvan Elessa on 04/04/2018.
//  Copyright © 2018 Yvan Elessa. All rights reserved.
//

import Foundation

struct CastDB {
    var id: Int
    var cast_id: Int
    var name: String
    
    init(_ data: [String: AnyObject]) {
        self.id = (data["id"] as? Int)!
        self.cast_id = (data["cast_id"] as? Int) ?? 0
        self.name = (data["name"] as? String) ?? ""
    }
}
