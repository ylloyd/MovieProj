//
//  SaveMovieViewController.swift
//  MovieProj
//
//  Created by Yvan Elessa on 28/03/2018.
//  Copyright © 2018 Yvan Elessa. All rights reserved.
//

import Foundation
import UIKit

class SaveMovieViewController: UIViewController {
    @IBOutlet weak var backgroundMovieImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    
    @IBAction func saveToCoreData(_ sender: Any) {
        guard let movie = movie else {
            return
        }
        
        let alreadyExistsInDB = self.dataController.movie(id: movie.id)
        
        if alreadyExistsInDB {
            print("Already exists")
            return
        } else {
            print("Good to go!")
        }
        
        
        if let movieToSave = self.dataController.newObject(NSStringFromClass(Movie.self)) as? Movie {
            
            
            
            movieToSave.id = Int32(movie.id)
            movieToSave.original_title = movie.original_title
            
            self.dataController.save()
        }
    }
    
    var movie: MovieDB?
    var dataObject: Int?
    var movieCredits = MovieCreditDB()
    let dataController = DataController.default
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let movie = movie else {
            return
        }
        
        title = "Informations"
        
        movieTitleLabel.text = movie.original_title
        datePicker.setValue(UIColor.white, forKeyPath: "textColor")
        datePicker.maximumDate = NSDate() as Date

        fetchImage(imageUrl: movie.poster_path)
        getMovieCredits(movieId: movie.id)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func fetchImage(imageUrl: String) {
        let session = URLSession.shared
        let urlString = "https://image.tmdb.org/t/p/w185\(imageUrl)"
        let url = URL(string: urlString)
        
        if let url = url {
            
            let task = session.dataTask(with: url) {
                (data, response, error) in
                
                guard let data = data, error == nil else { return }
                
                DispatchQueue.main.async() {
                    if imageUrl != "" {
                        self.backgroundMovieImageView?.image = UIImage(data: data)
                    } else {
                        self.backgroundMovieImageView?.image = UIImage(named: "no-image")
                    }
                }
            }
            task.resume()
        }
    }
    
    func getMovieCredits(movieId: Int) {
        let apiKey = "b753bea3c6fd7e64a2e07a4538ee6aa9"
        let session = URLSession.shared
        let urlString = "https://api.themoviedb.org/3/movie/\(movieId)/credits?api_key=\(apiKey)"
        let url = URL(string: urlString)
        
        if let url = url {
            
            let task = session.dataTask(with: url) {
                (data, response, error) in
                
                if let data = data, let json = try! JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject], let movieCreditsCastResults = json["cast"] as? [[String: AnyObject]], let movieCreditsCrewResults = json["crew"] as? [[String: AnyObject]] {
                    
                    let movieCreditsCast = movieCreditsCastResults.reduce([]) {
                        (result, data) in

                        var res = result
                        let movieCreditCast = CastDB(data)

                        res.append(movieCreditCast)
                        return res
                    }
                    
                    let movieCreditsCrew = movieCreditsCrewResults.reduce([]) {
                        (result, data) in
                        
                        var res = result
                        let movieCreditCrew = CrewDB(data)
                        
                        res.append(movieCreditCrew)
                        return res
                    }

                    DispatchQueue.main.async {
                        self.movieCredits.cast = movieCreditsCast as? [CastDB]
                        self.movieCredits.crew = movieCreditsCrew as? [CrewDB]
                    }
                    
                } else {
                    // if error
                }
            }
            
            task.resume()
        }
    }
}
