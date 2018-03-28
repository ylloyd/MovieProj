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
    
    var movieId: Int?
    var movie: MovieDB?
    var dataObject: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let movie = movie else {
            return
        }
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
        
        title = movie.original_title
        fetchImage(imageUrl: movie.poster_path)
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
    
    func getMovieCredits(movieId: String) {
        let apiKey = "b753bea3c6fd7e64a2e07a4538ee6aa9"
        let session = URLSession.shared
        let urlString = "https://api.themoviedb.org/3/movie\(movieId)?api_key=\(apiKey)"
        let url = URL(string: urlString)
        
        if let url = url {
            
            let task = session.dataTask(with: url) {
                (data, response, error) in
                
                if let data = data, let json = try! JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject], let movieResults = json["results"] as? [[String: AnyObject]] {
                    
//                    self.movies = movieResults.reduce([]) {
//                        (result, data) in
//
//                        var res = result
//                        let movie = MovieDB(data)
//
//                        res.append(movie)
//
//                        return res
//                    }
//
//                    DispatchQueue.main.async {
//                        self.searchTableView.reloadData()
//                    }
                    
                } else {
                    // if error
                }
            }
            
            task.resume()
        }
    }
}
