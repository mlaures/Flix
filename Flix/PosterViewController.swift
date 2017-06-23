//
//  PosterViewController.swift
//  Flix
//
//  Created by Mei-Ling Laures on 6/22/17.
//  Copyright © 2017 Mei-Ling Laures. All rights reserved.
//

import UIKit

class PosterViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    // collection of posters being displayed
    @IBOutlet weak var posterCollection: UICollectionView!
    
    // when loading the collection of posters
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // the list of movies that will be displayed
    var movies: [[String : Any]] = []
    
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // indicate that movies are being loaded
        activityIndicator.startAnimating()
        
        // enable refresh control for the table view
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(PosterViewController.didPullToRefresh(_:)), for: .valueChanged)
        
        // where the refresh view will be shown
        posterCollection.insertSubview(refreshControl, at: 0)
        
        // set this controller as the data for the collection
        posterCollection.dataSource = self
        posterCollection.delegate = self
        
        // perform network call
        fetchSuperheros()

    }
    
    // calls the fetch function whenever the refresh control is called
    func didPullToRefresh(_ refreshControl: UIRefreshControl) {
//        loadingData = true
//        pageCount = 1
        fetchSuperheros()
    }
    
    func fetchSuperheros() {
        // This is the networking request
        let url = URL(string: "https://api.themoviedb.org/3/movie/297762/similar?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed&language=en-US")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                // store the JSON data in a recognizeable way
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                
                // put the wanted data (the movies) into an array of dictionaries
                let movies = dataDictionary["results"] as! [[String:Any]]
                self.movies = movies
                
                // reload the table so that it displays the information from the networking request
                self.posterCollection.reloadData()
                
                // the network request finished so stop loading
                self.activityIndicator.stopAnimating()
                
                // the network has finished fetching data, so if table is refreshing, end the loading signal
                self.refreshControl.endRefreshing()
                
            }
        }
        
        task.resume()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // get the cell that is going to be filled
        let cell = posterCollection.dequeueReusableCell(withReuseIdentifier: "PosterCell", for: indexPath) as! PosterCell
        let movie = movies[indexPath.row]
        
        let base = "https://image.tmdb.org/t/p/w500"
        
        // store and display poster in cell
        if let path = movie["poster_path"] as? String {
            let posterURL = URL(string: base + path)
            
            // set the elements in the cell to be what needs to be displayed
            cell.posterImage.af_setImage(withURL: posterURL!)
            
        } else {
            cell.posterImage.image = nil
        }
        
        
        return cell
    }
    
    // make sure to give the data that the detail view needs
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // set up the destination, cell, and index of the cell to grab information
        let control = segue.destination as! MovieDetailViewController
        let cell = sender as! UICollectionViewCell
        let index = posterCollection.indexPath(for: cell)!
        
        // pass the correct information from the list of movies to the next view
        let movie = movies[index.row]
        control.movie = movie
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
