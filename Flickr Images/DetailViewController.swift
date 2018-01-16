//
//  DetailViewController.swift
//  Flickr Images
//
//  Created by Natalia on 14/04/2016.
//  Copyright © 2016 NataliaDeveloper. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    var largerImage: UIImage?
    
    @IBOutlet weak var detailImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailImageView.image = largerImage
    }
    
    /*
    func setImage(imageURL: NSURL) {
        

        detailImageView.af_setImageWithURL(imageURL, placeholderImage: <#T##UIImage?#>, filter: <#T##ImageFilter?#>, progress: <#T##ProgressHandler?##ProgressHandler?##(bytesRead: Int64, totalBytesRead: Int64, totalExpectedBytesToRead: Int64) -> Void#>, progressQueue: <#T##dispatch_queue_t#>, imageTransition: <#T##UIImageView.ImageTransition#>, runImageTransitionIfCached: <#T##Bool#>, completion: <#T##(Response<UIImage, NSError> -> Void)?##(Response<UIImage, NSError> -> Void)?##Response<UIImage, NSError> -> Void#>)
        
        cell.imageView.af_setImageWithURL(URL, placeholderImage: UIImage(named: "placeholder"), filter: nil, imageTransition: .None, completion: { (response) -> Void in
            print("image: \(cell.imageView.image)")
        })
        
        let url = URL(string: "https://httpbin.org/image/png")!
        let placeholderImage = UIImage(named: "placeholder")!
        
        imageView.af_setImage(withURL: url, placeholderImage: placeholderImage)
    }
 */
}
