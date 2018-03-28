//
//  SearchViewController.swift
//  MovieProj
//
//  Created by Yvan Elessa on 14/03/2018.
//  Copyright © 2018 Yvan Elessa. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emptyTableViewText: UILabel!
    @IBOutlet weak var searchTableView: UITableView!
    
    var searchBar = UISearchBar()
    
    @IBAction func dismissKeyboardButton(sender: Any) {
        searchBar.resignFirstResponder()
    }
    
    var movies: [MovieDB] = []
    let dataController = DataController.default
    
    var keys: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSearchBar()
        
        //searchTableView.register(CustomSearchTableViewCell.self, forCellReuseIdentifier: "CustomSearchTableViewCell")
        
        searchTableView.isHidden = true
        searchTableView.rowHeight = 124.0
        // Do any additional setup after loading the view.
    }
    
    func addSearchBar() {
        self.searchBar.showsCancelButton = false
        self.searchBar.placeholder = "Search for a movie"
        self.searchBar.delegate = self
        
        self.navigationItem.titleView = self.searchBar
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension SearchViewController: UITableViewDelegate {
    
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomSearchTableViewCell", for: indexPath) as! CustomSearchTableViewCell
        
        cell.selectionStyle = .none
        cell.title?.text = movies[indexPath.row].title
        fetchImage(cell: cell, imageUrl: movies[indexPath.row].poster_path, indexPath: indexPath)
        
        return cell
    }
    
    func fetchImage(cell: CustomSearchTableViewCell, imageUrl: String, indexPath: IndexPath) {
        let session = URLSession.shared
        let urlString = "https://image.tmdb.org/t/p/w185\(imageUrl)"
        let url = URL(string: urlString)
        
        if let url = url {
            cell.tag = indexPath.row
            
            let task = session.dataTask(with: url) {
                (data, response, error) in
                
                guard let data = data, error == nil else { return }
                
                DispatchQueue.main.async() {
                    if cell.tag == indexPath.row {
                        cell.movieImageView?.image = UIImage(data: data)
                    }
                }
            }
            task.resume()
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchTableView.isHidden = searchText.isEmpty
        
        if !searchText.isEmpty {
            searchMovie(query: searchText)
            searchTableView.isHidden = false
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchMovie(query: String) {
        let apiKey = "b753bea3c6fd7e64a2e07a4538ee6aa9"
        let session = URLSession.shared
        let query = query.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        let urlString = "https://api.themoviedb.org/3/search/movie/?api_key=\(apiKey)&query=\(query ?? "")"
        let url = URL(string: urlString)
        
        if let url = url {
            
            let task = session.dataTask(with: url) {
                (data, response, error) in
                
                if let data = data, let json = try! JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject], let movieResults = json["results"] as? [[String: AnyObject]] {
                    
                    self.movies = movieResults.reduce([]) {
                        (result, data) in
                        
                        var res = result
                        let movie = MovieDB(data)
                        
                        res.append(movie)
                        
                        return res
                    }
                    
                    DispatchQueue.main.async {
                        self.searchTableView.reloadData()
                    }
                    
                } else {
                    // if error
                }
            }
            
            task.resume()
        }
    }
}
