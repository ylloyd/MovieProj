//
//  Crew.swift
//  MovieProj
//
//  Created by Yvan Elessa on 04/04/2018.
//  Copyright © 2018 Yvan Elessa. All rights reserved.
//

import Foundation

struct CrewDB {
    var id: Int
    var job: String
    var name: String
    
    init(_ data: [String: AnyObject]) {
        self.id = (data["id"] as? Int)!
        self.job = (data["job"] as? String) ?? ""
        self.name = (data["name"] as? String) ?? ""
    }
}
