//
//  ThumbnailData.swift
//  Flickr Collection
//
//  Created by Natalia on 30/03/2016.
//  Copyright © 2016 NataliaDeveloper. All rights reserved.
//

import Foundation
import UIKit

// could make a struct for the picture object instaed of a class to represent it
class ThumbnailData: NSObject {
    
    class var sharedInstance: ThumbnailData {
        struct Singleton {
            static let instance = ThumbnailData()
        }
        return Singleton.instance
    }

    private var thumbnailSet = [ImageObject]()
    
    func setThumbnailData(imageData: [ImageObject]) {
        thumbnailSet = imageData
    }
    
    func getImage(index: Int) -> UIImage?
    {
        return thumbnailSet[index].thumbnail
    }
    
    
    func setImage(index: Int, image: UIImage?) {
        thumbnailSet[index].thumbnail = image
    }
    
    func getAllItems() -> [ImageObject] {
        return thumbnailSet
    }
    
    func getImageUrl(index: Int) -> String
    {
        return thumbnailSet[index].imageAddress
    }
    
    func getImageName(index: Int) -> String
    {
        return thumbnailSet[index].title
    }
    
    
    func getCountImages() -> Int
    {
        return thumbnailSet.count
    }
}
