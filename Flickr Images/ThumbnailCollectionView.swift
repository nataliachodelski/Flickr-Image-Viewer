
//Flickr Viewer
//Key:
//bd572be0a9130ed85862e0ca053e99df
//
//Secret:
//69a2a7029940acc1

// test url https://farm8.staticflickr.com/7215/7299456770_7324bb3f2f_t.jpg

// with my apps api key " https://api.flickr.com/services/rest/?method=flickr.people.getPublicPhotos&api_key=bd572be0a9130ed85862e0ca053e99df&user_id=11349317%40N02&format=json&nojsoncallback=1"


// TO DO LIST: hook test functions into bigger unit test framework
// Make a couple testing functions at the bottom of the file
//


// download an image, put in data store. test verifies if image is in data store

// test loads things in collection view and then check 



//  ThumbnailCollectionView.swift
//  Flickr Viewer
//
//  Created by Natalia on 30/03/2016.
//  Copyright © 2016 NataliaDeveloper. All rights reserved.
//


import UIKit
import SwiftyJSON // cocoapod helper class that

// ADD INFO ABOUT THIS CLASS XXXXX
// *XX  Cleanup public, priv _, etc


class ThumbnailCollectionView: UICollectionViewController
{
    let myDataStore = ThumbnailData()
    let myDownloadHelper = DownloadHelper()
    
    private let reuseIdentifier = "reusableCell"
    private let sectionInsets = UIEdgeInsets(top: 30.0, left: 20.0, bottom: 30.0, right: 20.0)
    var tempImg : UIImage?
    
    var testThumbnailURL = "https://farm8.staticflickr.com/7215/7299456770_7324bb3f2f_t.jpg"

    
    // MARK: - View lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        NSNotificationCenter.defaultCenter().addObserver(self,  selector: #selector(self.reloadCollection), name: "ReloadCollection", object: nil)
        
        
        
        
        myDownloadHelper.downloadMetadata()
        
        // load images from URL and insert Dispatch_async
    
        // customize colours, title of nav bar
        let nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.Black
        nav?.barTintColor = UIColor.blackColor()
        nav?.tintColor = UIColor.blueColor()
        nav?.translucent = false
        nav?.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        navigationItem.title = "flickr"
    }

    
    func reloadCollection() {
        collectionView?.reloadData()
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
    
    
    
    func loadImagesFromUrls(urlString: String, completion: (image: UIImage?, error: NSError?) -> Void) {
        if let url = NSURL(string: urlString) {
            var outputImg : UIImage?
            let request = NSURLRequest(URL: url)
            let session = NSURLSession.sharedSession()
            session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
                if (data != nil && error == nil) {
                    outputImg = UIImage(data: data!)
                    print("output image created, size is \(outputImg?.size)")
                    completion(image: outputImg, error: nil)
                } else {
                    print("error retreiving image with loadImagesFromUrls")
                    completion(image: nil, error: error)
                }
            }).resume()
        }
    }
    
    
    
    
    func completeInitalization(address: String)  {
        loadImagesFromUrls(address) {(image, error) in
            print("running completeInitalization")
            if error != nil {
                print("error completing intialization in loadimagefromURL block")
            }
        }
    }

    
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    // MARK: UICollectionViewDelegate
    
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    //    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool
    //    {
    //        return true
    //    }
    //
    //Uncomment this method to specify if the specified item should be selected
    //    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool
    //    {
    //        return true
    //    }
    
    
    /*
     // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
     override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
     return false
     }
     
     override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
     return false
     }
     
     override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
     }
     */
}

extension ThumbnailCollectionView
{
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        //return DataStore.getCountImages()
        return 5
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! ImageCell
        let index = indexPath.row
        print("index is \(index)")
        
        // Configure the cell
        cell.backgroundColor = UIColor.blueColor()
        cell.imageView?.image = UIImage(named: "Image")

        //cell.imageView?.imageFromUrl(DataStore.getImageUrl(index))
        
        return cell
    }
}

//extension ThumbnailCollectionView : UICollectionViewDelegateFlowLayout
//{
//    func collectionView(collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                               sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
//    {
//        let index = indexPath.row
//        //XXX if let currentPhoto =  DataStore.getImage(index) {
//        if let currentPhoto = tempImg {
//        
//            var size = currentPhoto.size
//            size.width += 10 ; size.height += 10
//            print("size is \(size)")
//            return size
//        } else {
//            return CGSize(width: 0, height: 0)
//        }
//    }
//    
//    func collectionView(collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                               insetForSectionAtIndex section: Int) -> UIEdgeInsets
//    {
//        return sectionInsets
//    }
//}


extension UIImageView {
    public func imageFromUrl(urlString: String) {
        if let url = NSURL(string: urlString) {
            let request = NSURLRequest(URL: url)
            let session = NSURLSession.sharedSession()
            session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
                if (data != nil && error == nil) {
                    self.image = UIImage(data: data!)
                } else {
                    print("error retreiving image")
                }
            })
        }
    }
}
