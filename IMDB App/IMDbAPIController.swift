//
//  IMDbAPIController.swift
//  IMDB App
//
//  Created by Kioko on 12/01/2016.
//  Copyright © 2016 Thomas Kioko. All rights reserved.
//

import UIKit

protocol IMDbAPIControllerDelegate{
    
    func didFinishIMDbSearch(jsonResult: Dictionary<String, String>)
}

class IMDbAPIController {
    
    var imdbDelegate : IMDbAPIControllerDelegate?
    
    init(imdbDelegate: IMDbAPIControllerDelegate){
        self.imdbDelegate = imdbDelegate
    }
    
    func searchIMDb(forContent: String){
        
        //String all the spaces and replace them with %. This ensures the string
        //is url encoded
        let spacelessString = forContent
            .stringByAddingPercentEncodingWithAllowedCharacters(
                .URLHostAllowedCharacterSet()
        )
        
        if let spacelessString = spacelessString{
            let urlPath = NSURL(string: "http://www.omdbapi.com/?t="
                + "\(spacelessString)&y=&plot=short&r=json")
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
                        
                        if let apiDelegate = self.imdbDelegate{
                            dispatch_async(dispatch_get_main_queue()){
                                if let jsonResult = jsonResult{
                                    apiDelegate.didFinishIMDbSearch(jsonResult)
                                }
                            }
                        }
                    }catch{
                        //TODO:: Print the error message
                    }
                }
                task.resume()
            }else{
                print(urlPath)
                print(spacelessString)
            }
        }else{
            print("Ohh no")
        }
        
    }
}
