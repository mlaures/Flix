//
//  NowPlayingViewController.swift
//  Flix
//
//  Created by Mei-Ling Laures on 6/21/17.
//  Copyright © 2017 Mei-Ling Laures. All rights reserved.
//

import UIKit
import AlamofireImage

class NowPlayingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var movieTable: UITableView!
    
    var movies: [[String: Any]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieTable.dataSource = self
        movieTable.delegate = self
        
        // This is the networking request
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed&language=en-US")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                print(dataDictionary)
                
                
                let movies = dataDictionary["results"] as! [[String:Any]]
                self.movies = movies
                self.movieTable.reloadData()
                
            }
        }
        
        task.resume()	
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = movieTable.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        
        let movie = movies[indexPath.row]
        
        let title = movie["title"] as! String
        let desc = movie["overview"] as! String
        let path = movie["poster_path"] as! String
        let base = "https://image.tmdb.org/t/p/w500"
        let posterURL = URL(string: base + path)!
        
        cell.movieTitle.text = title
        cell.movieDescription.text = desc
        cell.movieImage.af_setImage(withURL: posterURL)
        
        return cell
    }

}
