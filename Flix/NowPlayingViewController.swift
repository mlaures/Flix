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

    // outlet of the tableview to link things to it
    @IBOutlet weak var movieTable: UITableView!
    
    // mutable list of dictionaries for the movies information
    var movies: [[String: Any]] = []
    
    // loading signal for startup
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // start the loading symbol (the movies are loading)
        activityIndicator.startAnimating()
        
        // enable refresh control for the table view
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(NowPlayingViewController.didPullToRefresh(_:)), for: .valueChanged)
        
        movieTable.insertSubview(refreshControl, at: 0)
        
        // using this script as the datasource, delegate for the tableview
        movieTable.dataSource = self
        movieTable.delegate = self
        
        fetchMovies()
    }
    
    // calls the fetch function whenever the refresh control is called
    func didPullToRefresh(_ refreshControl: UIRefreshControl) {
        fetchMovies()
    }
    
    /* function: To get movie data
     * param: N/A
     * returns: N/A
     * This function fetches data from the internet by using an API the from The Movie Database. Instantiates only one session and task to do so. Stores the data within a view variable of a list of dictionaries.
     */
    func fetchMovies() {
        // This is the networking request
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed&language=en-US")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                // store the JSON data in a recognizeable way
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                print(dataDictionary)
                
                // put the wanted data (the movies) into an array of dictionaries
                let movies = dataDictionary["results"] as! [[String:Any]]
                self.movies = movies
                // reload the table so that it displays the information from the networking request
                self.movieTable.reloadData()
                
                // the network has finished fetching data, so if table is refreshing, end the loading signal
                self.refreshControl.endRefreshing()
                
                // turn off the animation of the indicator
                self.activityIndicator.stopAnimating()
                
            }
        }
        
        task.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // however many cells is how many movies the network loads to begin with
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // set where the cell is coming from
        let cell = movieTable.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        
        let movie = movies[indexPath.row]
        
        // store information from the movie data that will need to be displayed in the list
        let title = movie["title"] as! String
        let desc = movie["overview"] as! String
        let path = movie["poster_path"] as! String
        let base = "https://image.tmdb.org/t/p/w500"
        let posterURL = URL(string: base + path)!
        
        // set the elements in the cell to be what needs to be displayed
        cell.movieTitle.text = title
        cell.movieDescription.text = desc
        cell.movieImage.af_setImage(withURL: posterURL)
        
        return cell
    }

}
