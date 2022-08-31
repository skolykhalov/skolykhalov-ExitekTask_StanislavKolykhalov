//
//  MovieData.swift
//  ExitekTask_StanislavKolykhalov
//
//  Created by Stas on 31.08.2022.
//

import Foundation
import RealmSwift

class MovieData: Object {
    @objc dynamic var movieTitle: String = ""
    @objc dynamic var movieDate: Int = 0
    
    override class func primaryKey() -> String? {
        "movieTitle"
    }
}
