//
//  ThumbnailData.swift
//  Flickr Images
//
//  Created by Natalia on 30/03/2016.
//  Copyright © 2016 NataliaDeveloper. All rights reserved.
//

import Foundation
import UIKit

class ThumbnailData: NSObject {
    class var sharedInstance: ThumbnailData {
        struct Singleton {
            static let instance = ThumbnailData()
        }
        return Singleton.instance
    }

    fileprivate var thumbnailSet = [ImageObject]()
    fileprivate var userName: String = ""

    // MARK: Getter and Setter methods

    func setThumbnailData(_ imageData: [ImageObject]) {
        thumbnailSet = imageData
    }
    
    func setImage(_ index: Int, image: UIImage?) {
        thumbnailSet[index].thumbnail = image
    }
    
//    func loadImage(_ index: Int, @escaping completion (success: Bool) -> Void) {
//    let baseURL = thumbnailSet[index].baseImageAddress
//    }
    
    func getAllItems() -> [ImageObject] {
        return thumbnailSet
    }
    
    func getCountImageDataEntries() -> Int {
        return thumbnailSet.count
    }
    
    func getCountImages() -> Int {
        var count = 0
        for item in thumbnailSet  {
            if (item.thumbnail != nil) {
                count += 1
            }
        }
        return count
    }
    
    func getImageUrl(_ index: Int) -> String {
        return thumbnailSet[index].baseImageAddress
    }
    
    func getImage(_ index: Int) -> UIImage? {
        return thumbnailSet[index].thumbnail
    }
    
    func getImageName(_ index: Int) -> String {
        return thumbnailSet[index].title
    }
}
