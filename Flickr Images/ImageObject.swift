//
//  ImageObject.swift
//  Flickr Collection
//
//  Created by Natalia on 30/03/2016.
//  Copyright © 2016 NataliaDeveloper. All rights reserved.
//

import UIKit

class ImageObject: NSObject {
    
    var title : String = ""
    var id : String = ""
    var server : String  = ""
    var farm : String = ""
    var secret : String = ""
    var imageAddress : String = ""
    var thumbnail : UIImage?
    
    init(name: String, address: String, thumb: UIImage?) {
        super.init()
        self.title = name
        self.imageAddress = address
        self.thumbnail = thumb
    }
    
//    func loadImageFromUrl(urlString: String, completion: (image: UIImage?, error: NSError?) -> Void) {
//        if let url = NSURL(string: urlString) {
//            var outputImg : UIImage?
//            let request = NSURLRequest(URL: url)
//            let session = NSURLSession.sharedSession()
//            session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
//                if (data != nil && error == nil) {
//                    outputImg = UIImage(data: data!)
//                    print("data was not nil, output image created, size is \(outputImg?.size)")
//                    completion(image: outputImg, error: nil)
//                } else {
//                    print("error retreiving image")
//                    completion(image: nil, error: error)
//                }
//            })
//        }
//    }
//    
//    func completeInitalization(address: String) {
//        loadImageFromUrl(address) {(image, error) in
//            print("running completeInitalization")
//            if error == nil {
//                self.thumbnail = image
//            } else {
//                self.thumbnail = nil
//            }
//        }
//    }

}