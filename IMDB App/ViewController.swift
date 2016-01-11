//
//  ViewController.swift
//  IMDB App
//
//  Created by Kioko on 11/01/2016.
//  Copyright © 2016 Thomas Kioko. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var plotLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    @IBAction func fetchMovieData(sender: UIButton) {
        
        self.searchIMDb("x-men")
    }
    
    func searchIMDb(forContent: String){
        
        //String all the spaces and replace them with %. This ensures the string
        //is url encoded
        let spacelessString = forContent.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())
        
            let urlPath = NSURL(string: "http://www.omdbapi.com/?t=\(spacelessString)&y=&plot=short&r=json")
            let session = NSURLSession.sharedSession()
            
            if let urlPath = urlPath{
                let task = session.dataTaskWithURL(urlPath){
                    data, response, error -> Void in
                    
                    if let errorMessage = error{
                        print(errorMessage.localizedDescription)
                    }
                    
                    do{
                        let jsonResult = try NSJSONSerialization.JSONObjectWithData(
                            data!, options: NSJSONReadingOptions.MutableContainers
                            ) as? Dictionary<String, String>
                        
                        self.titleLabel.text = jsonResult!["Title"]
                        self.releaseDateLabel.text = jsonResult!["Released"]
                        self.plotLabel.text = jsonResult!["Plot"]
                        self.ratingLabel.text = jsonResult!["Rated"]
                    }catch{
                        //TODO:: Print the error message
                    }
                    
                }
                task.resume()
            }else{
                print(urlPath)
                print(spacelessString)
            }
        
    }
    
}

