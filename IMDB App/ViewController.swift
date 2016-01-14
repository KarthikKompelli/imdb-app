//
//  ViewController.swift
//  IMDB App
//
//  Created by Kioko on 11/01/2016.
//  Copyright © 2016 Thomas Kioko. All rights reserved.
//

import UIKit

class ViewController: UIViewController, IMDbAPIControllerDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tomatoeRating: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var plotLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    lazy var apiController : IMDbAPIController = IMDbAPIController(imdbDelegate: self)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.apiController.imdbDelegate = self
        let tapGesture = UITapGestureRecognizer(target: self, action: "gestureTapInView:")
        self.view.addGestureRecognizer(tapGesture)
        self.formatLabels(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func didFinishIMDbSearch(jsonResult: Dictionary<String, String>) {
        
        self.formatLabels(false)
        
        self.titleLabel.text = jsonResult["Title"]
        self.releaseDateLabel.text = "Release Date: " + jsonResult["Released"]!
        self.plotLabel.text = jsonResult["Plot"]
        self.ratingLabel.text = "Rating: " + jsonResult["Rated"]!
        
        if let posterUrl = jsonResult["Poster"]{
            self.formatImageFromUrl(posterUrl)
        }
        
        if let tomatoeMeterRating = jsonResult["tomatoMeter"]{
            self.tomatoeRating.text = tomatoeMeterRating + "%"
        }
    }
    
    func formatLabels(firstLaunch : Bool){
        
        let labelsArray = [self.titleLabel, self.ratingLabel, self.releaseDateLabel,
            self.plotLabel, self.tomatoeRating]
        
        if firstLaunch{
            for label in labelsArray{
                label.text = ""
            }
        }
        for label in labelsArray{
            label.textAlignment = .Center
            
            switch label{
            case self.titleLabel:
                label.font = UIFont(name: "Avenir Next", size: 28)
            case self.releaseDateLabel, self.ratingLabel:
                label.font = UIFont(name: "Avenir Next", size: 12)
            case self.plotLabel:
                label.font = UIFont(name: "Avenir Next", size: 16)
            case self.tomatoeRating:
                label.font = UIFont(name: "AvenirNext-UltraLight", size: 48)
                label.textColor = UIColor(red: 0.984, green: 0.256, blue: 0.184, alpha: 1.0)
            default:
                label.font = UIFont(name: "Avenir Next", size: 14)
            }
            
        }
    }
    
    func formatImageFromUrl(imageUrl: String){
        
        let posterImageUrl = NSURL(string: imageUrl)
        
        if let posterImageUrl = posterImageUrl{
            let posterImageData = NSData(contentsOfURL: posterImageUrl)
            
            if let posterImageData = posterImageData{
                self.posterImageView.clipsToBounds = true
                self.posterImageView.layer.cornerRadius = 100.0
                self.posterImageView.image = UIImage(data: posterImageData)
                self.blurBackGround(self.posterImageView.image!)
            }
        }
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        if let searchQuery = searchBar.text{
            //hide the keyboard when the user clicks search
            searchBar.resignFirstResponder()
            self.apiController.searchIMDb(searchQuery)
            searchBar.text = "" //clear the text
        }
    }
    
    
    func gestureTapInView(gesture : UITapGestureRecognizer){
        self.searchBar.resignFirstResponder()
    }
    
    /*!
    * @discussion This function uses an Image to create a blurr effect.
    * @param Image
    */
    func blurBackGround(image: UIImage){
        
        //Get the dimensions of the view
        let frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
        let imageView = UIImageView(frame: frame)
        imageView.image = image
        imageView.contentMode = .ScaleAspectFit
        
        
        //Set up blurr effect
        let blurEffect = UIBlurEffect(style: .Light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        
        let transparentWhiteView = UIView(frame: frame)
        transparentWhiteView.backgroundColor = UIColor(white: 1.0, alpha: 0.95)
        
        let viewsArray = [imageView, blurEffectView, transparentWhiteView]
        
        for index in 0..<viewsArray.count{
            if let oldView = self.view.viewWithTag(index + 1){
                oldView.removeFromSuperview()
            }
            
            let viewToInsert = viewsArray[index]
            self.view.insertSubview(viewToInsert, atIndex: index + 1)
            viewToInsert.tag = 1
        }
    }
    
}

