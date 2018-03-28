//
//  Movie.swift
//  MovieProj
//
//  Created by Yvan Elessa on 21/03/2018.
//  Copyright © 2018 Yvan Elessa. All rights reserved.
//

import Foundation

struct MovieDB {
    var original_title: String
    var title: String
    var poster_path: String
//    var productsCount: Int
//    var id: String
    
    init(_ data: [String: AnyObject]) {
        self.original_title = (data["original_title"] as? String) ?? ""
        self.title = (data["title"] as? String) ?? ""
        self.poster_path = (data["poster_path"] as? String) ?? ""
    }
}
