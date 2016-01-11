//
//  ViewController.swift
//  IMDB App
//
//  Created by Kioko on 11/01/2016.
//  Copyright © 2016 Thomas Kioko. All rights reserved.
//

import UIKit

class ViewController: UIViewController, IMDbAPIControllerDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var plotLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    
    lazy var apiController : IMDbAPIController = IMDbAPIController(imdbDelegate: self)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.apiController.imdbDelegate = self
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func fetchMovieData(sender: UIButton) {
        self.apiController.searchIMDb("x-men")
    }
    
    func didFinishIMDbSearch(jsonResult: Dictionary<String, String>) {
        
        self.titleLabel.text = jsonResult["Title"]
        self.releaseDateLabel.text = jsonResult["Released"]
        self.plotLabel.text = jsonResult["Plot"]
        self.ratingLabel.text = jsonResult["Rated"]
        
        if let posterUrl = jsonResult["Poster"]{
            self.formatImageFromUrl(posterUrl)
        }
    }
    
    func formatImageFromUrl(imageUrl: String){
        
        let posterImageUrl = NSURL(string: imageUrl)
        
        if let posterImageUrl = posterImageUrl{
            let posterImageData = NSData(contentsOfURL: posterImageUrl)
            
            if let posterImageData = posterImageData{
                self.posterImageView.clipsToBounds = true
                self.posterImageView.image = UIImage(data: posterImageData)
            }
        }
        
        
    }
    
}

