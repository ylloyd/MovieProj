//
//  ViewController.swift
//  MovieProj
//
//  Created by Yvan Elessa on 14/03/2018.
//  Copyright © 2018 Yvan Elessa. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var emptyTableViewText: UILabel!
    @IBOutlet weak var movieTableView: UITableView!
    @IBAction func open(_ sender: Any) {
        performSegue(withIdentifier: "nextView", sender: self)
    }
    
    
    let dataController = DataController.default
    var movie: Movie?
    var movies: [String: [Movie]] = [:]
    var keys: [String] = []
    private let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        setRefreshControl()
        
        emptyTableViewText.text = "You have no movies yet. We suggest you to start by searching a movie"
        
        movieTableView.rowHeight = 80
        //movieTableView.register(UITableViewCell.self, forCellReuseIdentifier: "MovieTableViewCell")
        displayDefault()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadFromCoreData()
        movieTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setRefreshControl() {
        refreshControl.addTarget(self, action:  #selector(pullToRefresh), for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor(red:0.25, green:0.72, blue:0.85, alpha:1.0)
        refreshControl.attributedTitle = NSAttributedString(string: "Fetching Movie Data ...", attributes: nil)
        movieTableView.refreshControl = refreshControl
    }
    
    @objc func pullToRefresh() {
        DispatchQueue.main.async {
            self.loadFromCoreData()
            self.movieTableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    
    func displayDefault() {
        let moviesFromCoreData = dataController.movies()
        
        if moviesFromCoreData.isEmpty {
            movieTableView.isHidden = true
            emptyTableViewText.isHidden = false
        } else {
            movieTableView.isHidden = false
            emptyTableViewText.isHidden = true
        }
    }
    
    func loadFromCoreData() {
        let tmpMovies = dataController.movies()
        
        var brandsPerLetter: [String: [Movie]] = [:]
        _ = tmpMovies.reduce(brandsPerLetter) {
            (result, movie) in
            
            if let movieName = movie.original_title {
                let firstChar = String(movieName.prefix(1))
                
                if let _ = brandsPerLetter[firstChar] {
                    brandsPerLetter[firstChar]?.append(movie)
                } else {
                    brandsPerLetter[firstChar] = [movie]
                }
            }
            
            
            return result
        }
    }

}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataController.movies().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell", for: indexPath) as! CustomMainTableViewCell
        
        let movies = dataController.movies()
        let movie = movies[indexPath.row]
        cell.movieTitle?.text = movie.original_title
        cell.movieDateViewed.text = movie.viewed_at
        if let imagePath = movie.backdrop_path {
            fetchImage(cell: cell, imageUrl: imagePath, indexPath: indexPath)
        }
        
        return cell
    }
    
    func fetchImage(cell: CustomMainTableViewCell, imageUrl: String, indexPath: IndexPath) {
        let session = URLSession.shared
        let urlString = "https://image.tmdb.org/t/p/w185\(imageUrl)"
        let url = URL(string: urlString)
        
        if let url = url {
            cell.tag = indexPath.row
            
            let task = session.dataTask(with: url) {
                (data, response, error) in
                
                guard let data = data, error == nil else { return }
                
                DispatchQueue.main.async() {
                    if cell.tag == indexPath.row && imageUrl != "" {
                        cell.movieBackgroundImageView?.image = UIImage(data: data)
                    } else {
                        cell.movieBackgroundImageView?.image = UIImage(named: "no-image")
                    }
                }
            }
            task.resume()
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
//            movies.remove(at: indexPath.row)
//            movieTableView.deleteRows(at: [indexPath], with: .fade)
//            movieTableView.reloadData()
        }
    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movies = dataController.movies()
        let movie = movies[indexPath.row]
            
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mvc = storyboard.instantiateViewController(withIdentifier: "MovieViewController") as? MovieViewController

        guard let movieViewController = mvc else {
            return
        }

        movieViewController.movie = movie
        navigationController?.pushViewController(movieViewController, animated: true)
        
//        self.present(movieViewController, animated: true, completion: nil)
    }
    
}

