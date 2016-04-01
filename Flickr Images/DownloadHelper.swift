//
//  DownloadHelper.swift
//  Flickr Viewer
//
//  Created by Natalia on 31/03/2016.
//  Copyright © 2016 NataliaDeveloper. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

let ReloadCollection = "ReloadCollection"

public class DownloadHelper {
    
    let DataStore = ThumbnailData.sharedInstance
    //let CollectionController = ThumbnailCollectionView()
    
    
    
    //    let apiURL = https://api.flickr.com/services/rest/
    //    let method = flickr.people.getPublicPhotos
    //    let api_key = bd572be0a9130ed85862e0ca053e99df
    //    var user_id = 11349317%40N02
    //    let format = json
    //    let jsoncallback = 1
    
    var testThumbnailURL = "https://farm8.staticflickr.com/7215/7299456770_7324bb3f2f_t.jpg"
    
    
    public func downloadMetadata()
    {
        fetchFlickrData() {(results) in
            if (results != nil) {
                
                print("finished setup, returned img array via callback. Count of images in results array is \(self.DataStore.getCountImages())")
                //print("results array, /(resultsArray)")
                
                self.DataStore.setThumbnailData(results!)
                
                //print(results)
                print("finished setup, returned img array via callback. Count of images in results array is \(self.DataStore.getCountImages())")
            }
        }
    }
    
    func downloadImages()
    {
        let dataArray : [ImageObject] = DataStore.getAllItems()
        for i in 0..<dataArray.count {
            loadImagesFromUrls(DataStore.getImageUrl(i)) {(image, error) in
                print("running loadImageFromUrl, image size is \(image!.size)")
                if error == nil {
                    print("setting item thumbnail to image from loadimages")
                    dataArray[i].thumbnail = image
                    self.DataStore.setImage(i, image: image!)
                } else {
                    print("error completing intialization in loadimagefromURL block")
                    self.DataStore.setImage(i,  image: nil)
                }
                
                NSNotificationCenter.defaultCenter().postNotificationName(ReloadCollection, object: self)
//                dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                    //self.CollectionController.collectionView?.reloadData()
//                })
            }
        }
    }
    
    
    func loadImagesFromUrls(urlString: String, completion: (image: UIImage?, error: NSError?) -> Void) {
        if let url = NSURL(string: urlString) {
            var outputImg : UIImage?
            let request = NSURLRequest(URL: url)
            let session = NSURLSession.sharedSession()
            session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
                if (data != nil && error == nil) {
                    outputImg = UIImage(data: data!)
                    print("data was not nil, output image created, size is \(outputImg?.size)")
                    completion(image: outputImg, error: nil)
                } else {
                    print("error retreiving image with loadImagesFromUrls")
                    completion(image: nil, error: error)
                }
            }).resume()
        }
    }
    
    // " To retreive the thumbnails of each public image on the accont, must parse the image ID, serverID, farmID, and secret from the json response, then concatenate these values into a imageURL for each thumbnail. URL format is https://farm{farm-id}.staticflickr.com/{server-id}/{id}_{secret}_{size-code}.jpg. Using SwiftyJSON Cocoapod to serialize and parse flickr response. "
    func fetchFlickrData(completion : (resultArray: [ImageObject]?) -> Void)
    {
        let userID : String = "11349317%40N02"
        let apiKey : String = "bd572be0a9130ed85862e0ca053e99df"
        let flickrPhotosURL = "https://api.flickr.com/services/rest/?method=flickr.people.getPublicPhotos&api_key=" + apiKey + "&user_id=" + userID + "&format=json&nojsoncallback=1"
        
        let session = NSURLSession.sharedSession()
        
        let dataTask1 = session.dataTaskWithURL(NSURL(string: flickrPhotosURL)!, completionHandler:
            { (data, response, error) -> Void in
                
                guard error == nil else {
                    print("Error returned when retreiving data from the flickr API: \(error.debugDescription)")
                    completion(resultArray: nil)
                    return
                }
                
                guard let responseData = data else {
                    print("Error: nil data returned from dataTaskWithURL")
                    completion(resultArray: nil)
                    return
                }
                
                // using SwiftyJSON cocoapod to for easier JSON parsing
                let jsonObject = SwiftyJSON.JSON(data: responseData)
                
                " To retreive the thumbnails of each public image on the accont, must parse the image ID, serverID, farmID, and secret from the json response, then concatenate these values into a imageURL for each thumbnail. URL format is https://farm{farm-id}.staticflickr.com/{server-id}/{id}_{secret}_{size-code}.jpg. Using SwiftyJSON Cocoapod to serialize and parse flickr response. "
                
                let status = jsonObject["stat"]
                if status == "ok" {
                    print("API call successful")
                    
                    let photoSection = jsonObject["photos"]
                    
                    let photoJsonAttributes = photoSection["photo"]
                    
                    var resultArray = [ImageObject]()
                    
                    for i in 1..<photoJsonAttributes.count
                    {
                        print("parsing json")
                        let title = photoJsonAttributes["title"].stringValue
                        let id = photoJsonAttributes[i]["id"].stringValue
                        let server = photoJsonAttributes[i]["server"].stringValue
                        let farm = photoJsonAttributes[i]["farm"].stringValue
                        let secret = photoJsonAttributes[i]["secret"].stringValue
                        
                        let urlString = "https://farm" + (farm) + ".staticflickr.com/" + (server) + "/" + String(id) + "_" + (secret) + "_t.jpg"
                        print(urlString)
                        
                        let photo = ImageObject(name: title, address: urlString, thumb: nil)
                        resultArray.append(photo)
                        completion(resultArray: resultArray)
                    }
                    return
                } else {
                    print("API error = status is not OK")
                    completion(resultArray: nil)
                    return
                }
        })
        dataTask1.resume()
    }
}