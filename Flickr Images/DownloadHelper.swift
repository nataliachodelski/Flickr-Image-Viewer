//
//  DownloadHelper.swift
//  Flickr Images
//
//  Created by Natalia on 31/03/2016.
//  Copyright © 2016 NataliaDeveloper. All rights reserved.
//

import UIKit
import SwiftyJSON

let ReloadCollectionNotification = "ReloadCollection"

public class DownloadHelper
{
    let myDataStore = ThumbnailData.sharedInstance
    var downloadedImagesCompleteArray : [Bool] = []

    func downloadMetadata(completion: (sucess: Bool) -> Void)
    {
        fetchFlickrData() {(results) in
            if (results != nil)
            {
                self.myDataStore.setThumbnailData(results!)
                NSLog("[DownloadHelper] downloadMetadata: finished fetchingFlickrData and successfully returned results. \(self.myDataStore.getCountImageDataEntries()) items of image metadata were added to the data model.")
                completion(sucess: true)
                
            } else {
                NSLog("[DownloadHelper] downloadMetadata Error: No image meta data was returned by fetchFlickrData")
                completion(sucess: false)
            }
        }
    }
    
    // This method asynchronously accesses the flickr "people.getPublicPhotos" API and returns a json object. It uses the SwiftyJSON Cocoapod to  serialize and parse the response object to retrieve image ID, serverID, farmID, and secret from the json response, then concatenate these values into a imageURL for each thumbnail. It also parses the image title and owner username and stores these strings along with the thumbnail URLs in the data model."
    func fetchFlickrData(completion : (resultArray: [ImageObject]?) -> Void)
    {
        let apiKey : String = "bd572be0a9130ed85862e0ca053e99df"
        let flickrPhotosAPIcall = "https://api.flickr.com/services/rest/?method=flickr.people.getPublicPhotos&api_key=" + apiKey + "&user_id=" + myDataStore.getUsername() + "&format=json&nojsoncallback=1"
        
        let session = NSURLSession.sharedSession()
        let dataTask1 = session.dataTaskWithURL(NSURL(string: flickrPhotosAPIcall)!, completionHandler:  { (data, response, error) -> Void in
                
                guard error == nil else {
                    NSLog("[DownloadHelper] fetchFlickrData Error: \(error.debugDescription), when fetching image metadata from the flickr API.")
                    completion(resultArray: nil)
                    return
                }
                
                guard let responseData = data else {
                    completion(resultArray: nil)
                    return
                }
            
                let jsonObject = SwiftyJSON.JSON(data: responseData)
                let status = jsonObject["stat"]
                if status == "ok" {
                    var resultArray : [ImageObject] = []
                    
                    let photoSection = jsonObject["photos"]
                    let photoJsonAttributes = photoSection["photo"]
                    
                    for i in 0..<photoJsonAttributes.count
                    {
                        let title = photoJsonAttributes["title"].stringValue
                        let username = photoJsonAttributes["owner"].stringValue
                        let id = photoJsonAttributes[i]["id"].stringValue
                        let server = photoJsonAttributes[i]["server"].stringValue
                        let farm = photoJsonAttributes[i]["farm"].stringValue
                        let secret = photoJsonAttributes[i]["secret"].stringValue
                        
                        // URL format: https://farm{farm-id}.staticflickr.com/{server-id}/{id}_{secret}_{size-code}.jpg
                        let urlString = "https://farm" + (farm) + ".staticflickr.com/" + (server) + "/" + String(id) + "_" + (secret) + "_t.jpg"
                        
                        let tempPhotoObject = ImageObject(name: title, username: username, address: urlString, thumb: nil)
                        resultArray.append(tempPhotoObject)
                    }
                    completion(resultArray: resultArray)
                    
                } else {
                    NSLog("[DownloadHelper] fetchFlickrData API Error: response status was not OK")
                    completion(resultArray: nil)
                }
        })
        dataTask1.resume()
    }

    
    // Each time this method is called, it notes whether the current image is present, then checks whether all images are present. If all images are present, a notification to reload the collection view is triggered.
    
    func checkImageCompletion(index: Int, didSuceed: Bool) {
        var boolAllImagesPresent : Bool = true
        for item in downloadedImagesCompleteArray {
            if (item == false) { boolAllImagesPresent = false }
        }
        
        if (boolAllImagesPresent == true) {
            dispatch_async(dispatch_get_main_queue(), {
                NSNotificationCenter.defaultCenter().postNotificationName(ReloadCollectionNotification, object: self)
            })
        }
    }
    
    // This method uses an asynchronous block to download each thumbnail image from flickr, then uses a completion handler to store each downloaded image in the data model.  The checkImagesFunction is called to creates an array of bools that are used to determine when all the images are retrieved. Once all are present, a notification is sent out, the ThumbnailCollectionView controller receives this notification and uses it to reload the CollectionView.
    func downloadImages()
    {
        downloadedImagesCompleteArray = Array(count: myDataStore.getCountImages(), repeatedValue: false)
        
        for i in 0..<myDataStore.getCountImageDataEntries() {
            loadImagesFromUrls(myDataStore.getImageUrl(i)) {(image, error) in
                
                if error == nil {
                    self.myDataStore.setImage(i, image: image!)
                    self.checkImageCompletion(i, didSuceed: true)
                    
                } else {
                    NSLog("[DownloadHelper] loadImagesFromURLs Error: \(error.debugDescription)")
                    self.myDataStore.setImage(i,  image: nil)
                    self.checkImageCompletion(i, didSuceed: false)
                }
            }
        }
    }
    
    func loadImagesFromUrls(urlString: String, completion: (image: UIImage?, error: NSError?) -> Void)
    {
        if let url = NSURL(string: urlString) {
            var outputImg : UIImage?
            let request = NSURLRequest(URL: url)
            let session = NSURLSession.sharedSession()
            session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
                if (data != nil && error == nil) {
                    outputImg = UIImage(data: data!)
                    completion(image: outputImg, error: nil)
                    return
                } else {
                    NSLog("[DownloadHelper] loadImagesFromUrls Error: \(error?.debugDescription)")
                    completion(image: nil, error: error)
                    return
                }
            }).resume()
        }
    }
}