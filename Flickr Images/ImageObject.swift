//
//  ImageObject.swift
//  Flickr Images
//
//  Created by Natalia on 30/03/2016.
//  Copyright © 2016 NataliaDeveloper. All rights reserved.
//

import UIKit

class ImageObject: NSObject {    
    var title: String = ""
    var baseImageAddress: String = ""
    var thumbAddress: String = ""
    var mediumAddress: String = ""
    var thumbnail: UIImage?
    
    init(name: String, address: String, thumb: UIImage?) {
        super.init()
        self.title = name
        self.baseImageAddress = address
        self.thumbAddress = baseImageAddress + "_t.jpg"
        self.mediumAddress = baseImageAddress + "_n.jpg"
        self.thumbnail = thumb
    }
}
