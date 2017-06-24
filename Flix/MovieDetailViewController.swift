//
//  MovieDetailViewController.swift
//  Flix
//
//  Created by Mei-Ling Laures on 6/22/17.
//  Copyright © 2017 Mei-Ling Laures. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {

    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var descriptionScroll: UIScrollView!
    @IBOutlet weak var relatedButton: UIBarButtonItem!
    
    var movie: [String: Any] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // store information from the movie data that will need to be displayed in the list
    override func viewWillAppear(_ animated: Bool) {
        
        // store and display title
        let title = movie["title"] as! String
        titleLabel.text = title

        let desc = movie["overview"] as! String
        descriptionLabel.text = desc
        descriptionLabel.sizeToFit()
        descriptionScroll.contentSize = CGSize(width: 288.0, height: descriptionLabel.frame.size.height + 20.0)
        
        let release = movie["release_date"] as! String
        releaseLabel.text = "Release: \(release)"
        
        let base = "https://image.tmdb.org/t/p/w500"

        // store and display poster
        if let path = movie["poster_path"] as? String {
            let posterURL = URL(string: base + path)
            
            // set the elements in the cell to be what needs to be displayed
            posterImage.af_setImage(withURL: posterURL!)
            
        } else {
            posterImage.image = nil
        }
        
        // store and display background image
        if let path = movie["backdrop_path"] as? String {
            let posterURL = URL(string: base + path)
            
            // set the elements in the cell to be what needs to be displayed
            backgroundImage.af_setImage(withURL: posterURL!)
            
        } else {
            backgroundImage.image = nil
        }
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        // set up the destination, cell, and index of the cell to grab information
        
            let control = segue.destination as! UINavigationController
            let view = control.viewControllers.first as! RelatedViewController
            let id = movie["id"] as! Int
        
            // pass the correct information from the movie to the next view
            view.movieOrigin = id
        
    }


}
