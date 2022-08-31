//
//  DataManager.swift
//  ExitekTask_StanislavKolykhalov
//
//  Created by Stas on 31.08.2022.
//

import Foundation
import RealmSwift

struct DataManager {
    
    let realm = try! Realm()
    static let shared = DataManager()
    private init() {}
    
    //MARK: - Saving to Realm
    
    func saveMovie(movie: MovieData) {
        
        do {
            try realm.write {
                realm.add(movie, update: .modified)
            }
        } catch {
            print("Error saving data to realm, \(error)")
        }
    }
    
    //MARK: - Loading from Realm
    
    func loadMovie() -> Results<MovieData> {
        
        var movieRealm: Results<MovieData>
        movieRealm = realm.objects(MovieData.self)
        
        return movieRealm
    }
    
    //MARK: - Deleting from Realm
    
    func deleteMovie(movie: MovieData) {
        
        do {
            try realm.write {
                realm.delete(movie)
            }
        } catch {
            print("Error deleting movies \(error)")
        }
    }
    
}
