//
//  ImageObject.swift
//  Flickr Images
//
//  Created by Natalia on 30/03/2016.
//  Copyright © 2016 NataliaDeveloper. All rights reserved.
//

import UIKit

class ImageObject: NSObject
{    
    var title : String = ""
    var username : String = ""
    var imageAddress : String = ""
    var thumbnail : UIImage?
    
    init(name: String, username: String, address: String, thumb: UIImage?)
    {
        super.init()
        self.title = name
        self.imageAddress = address
        self.thumbnail = thumb
    }
}