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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        emptyTableViewText.text = "You have no movies yet. We suggest you to start by searching a movie"
        
        movieTableView.register(UITableViewCell.self, forCellReuseIdentifier: "MovieTableViewCell")
        loadFromCoreData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadFromCoreData() {
        let tmpMovies = dataController.movies()
        
        var brandsPerLetter: [String: [Movie]] = [:]
        _ = tmpMovies.reduce(brandsPerLetter) {
            (result, movie) in
            
            if let movieName = movie.original_title {
                let firstChar = String(movieName.prefix(1))
                
                if !keys.contains(firstChar) {
                    keys.append(firstChar)
                }
                
                if let _ = brandsPerLetter[firstChar] {
                    brandsPerLetter[firstChar]?.append(movie)
                } else {
                    brandsPerLetter[firstChar] = [movie]
                }
            }
            
            
            return result
        }
        
        keys.sort { $0 < $1 }
        
        movies = brandsPerLetter
    }

}

extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return keys.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let key = keys[section]
        if let movies = movies[key] {
            return movies.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell", for: indexPath)
        
        let key = keys[indexPath.section]
        if let movies = movies[key] {
            let movie = movies[indexPath.row]
            cell.textLabel?.text = movie.original_title
        }
        
        return cell
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return keys
    }
    
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let key = keys[indexPath.section]
        if let movies = movies[key] {
            let movie = movies[indexPath.row]
            
            //        let storyboard = UIStoryboard(name: "Main", bundle: nil)
            //        let vc = storyboard.instantiateViewController(withIdentifier: "ProductsViewController") as? ProductsViewController
            //
            //        guard let productsViewController = vc else {
            //            return
            //        }
            //
            //        productsViewController.brand = brand
            //        navigationController?.pushViewController(productsViewController, animated: true)
            
//            performSegue(withIdentifier: "brandToProducts", sender: brand)
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let key = keys[section]
        return key
    }
    
}

