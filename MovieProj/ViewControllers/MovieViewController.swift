//
//  MovieViewController.swift
//  MovieProj
//
//  Created by Yvan Elessa on 16/05/2018.
//  Copyright © 2018 Yvan Elessa. All rights reserved.
//

import UIKit

class MovieViewController: UIViewController {
    
    @IBOutlet weak var backgroundMovieImageView: UIImageView!
    @IBOutlet weak var originalTitleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var viewedDateLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var castCollectionView: UICollectionView!
    
    var movie: Movie?
    var cast: [CastDB] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let movie = movie else {
            return
        }

        title = movie.original_title
        
        fetchImage(imageUrl: movie.poster_path ?? "", imageView: backgroundMovieImageView)
        originalTitleLabel.text = movie.original_title ?? ""
        releaseDateLabel.text = "Released: \(movie.release_date ?? "")"
        viewedDateLabel.text = "Viewed: \(movie.viewed_at ?? "")"
        overviewLabel.text = movie.overview ?? ""
        fetchCast()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchImage(imageUrl: String, imageView: UIImageView) {
        let session = URLSession.shared
        let urlString = "https://image.tmdb.org/t/p/w185\(imageUrl)"
        let url = URL(string: urlString)
        
        if let url = url {
            
            let task = session.dataTask(with: url) {
                (data, response, error) in
                
                guard let data = data, error == nil else { return }
                
                DispatchQueue.main.async() {
                    if imageUrl != "" {
                        imageView.image = UIImage(data: data)
                    } else {
                        imageView.image = UIImage(named: "no-image")
                    }
                }
            }
            task.resume()
        }
    }
    
    func fetchCast() {
        let session = URLSession.shared
        let api_key = "b753bea3c6fd7e64a2e07a4538ee6aa9"
        
        guard let movieId = movie?.id else{
            return
        }
        
        let urlString = "https://api.themoviedb.org/3/movie/\(movieId)/credits?api_key=\(api_key)"
        let url = URL(string: urlString)
        
        if let url = url {
            let task = session.dataTask(with: url) {
                (data, response, error) in
                
                if let data = data, let json = try! JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject], let dataCast = json["cast"] as? [[String: AnyObject]]{
                    
                    self.cast = dataCast.reduce([]) {
                        (result, data) in
                        
                        var res = result
                        
                        let actor = CastDB(data)
                        
                        res.append(actor)
                        
                        return res
                    }
                    
                    DispatchQueue.main.async {
                        self.castCollectionView?.reloadData()
                    }
                    
                }
            }
            
            task.resume()
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MovieViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cast.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = castCollectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollectionViewCell", for: indexPath) as! CustomCollectionViewCell
        
        
//        cell.selectionStyle = .none
        cell.name?.text = cast[indexPath.row].name
        fetchImageCast(cell: cell, imageUrl: cast[indexPath.row].imageUrl!, indexPath: indexPath)
        
        return cell
    }
    
    func fetchImageCast(cell: CustomCollectionViewCell, imageUrl: String, indexPath: IndexPath) {
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
                        cell.profileImageView?.image = UIImage(data: data)
                    } else {
                        cell.profileImageView?.image = UIImage(named: "no-image")
                    }
                }
            }
            task.resume()
        }
    }
    
}

extension MovieViewController: UICollectionViewDelegate {
    
}
