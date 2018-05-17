//
//  Movie.swift
//  MovieProj
//
//  Created by Yvan Elessa on 21/03/2018.
//  Copyright © 2018 Yvan Elessa. All rights reserved.
//

import Foundation

struct MovieDB {
    var id: Int
    var original_title: String
    var title: String
    var poster_path: String
    var backdrop_path: String
    var release_date: String
    var overview: String
    
    init(_ data: [String: AnyObject]) {
        self.id = (data["id"] as? Int)!
        self.original_title = (data["original_title"] as? String) ?? ""
        self.title = (data["title"] as? String) ?? ""
        self.poster_path = (data["poster_path"] as? String) ?? ""
        self.backdrop_path = (data["backdrop_path"] as? String) ?? ""
        self.release_date = (data["release_date"] as? String) ?? ""
        self.overview = (data["overview"] as? String) ?? ""
    }
}
