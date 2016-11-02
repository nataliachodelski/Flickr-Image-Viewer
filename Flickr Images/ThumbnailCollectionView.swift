
//  ThumbnailCollectionView.swift
//  Flickr Images
//
//  Created by Natalia on 30/03/2016.
//  Copyright © 2016 NataliaDeveloper. All rights reserved.
//


import UIKit
import SwiftyJSON

class ThumbnailCollectionView: UICollectionViewController {
    
    let myDataStore = ThumbnailData.sharedInstance
    let myDownloadHelper = DownloadHelper()
    
    private let reuseIdentifier = "reusableCell"
    private let sectionInsets = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)
    @IBOutlet var thisCollectionView: UICollectionView!

    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Harryyy's public flickr photos"
        let nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.Black
        nav?.barTintColor = UIColor.blackColor()
        nav?.tintColor = UIColor.blueColor()
        nav?.translucent = false
        nav?.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
       NSNotificationCenter.defaultCenter().addObserver(self,  selector: #selector(self.reloadCollection), name: "ReloadCollection", object: nil)
        
        // This method starts asynchronously downloading image data from flickr. Uses was_successful completion bool to initate thumbnail downloads only once all image metadata has been successfully retrieved.
        
        myDownloadHelper.downloadMetadata( { (was_successful) in
            if was_successful == true {
                self.myDownloadHelper.downloadImages()
            }
        })
    }
    
    func reloadCollection() {
        thisCollectionView.reloadData()
    }
    
    
    // MARK: - Collection View Data Source Methods

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myDataStore.getCountImageDataEntries()
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! ImageCell
        let index = indexPath.row
        
        // Configure the cell
        cell.backgroundColor = UIColor.lightGrayColor()
        cell.imageView.image = myDataStore.getImage(index)
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let index = indexPath.row
        let thumbnail = myDataStore.getImage(index)
        self.performSegueWithIdentifier("showDetail", sender: thumbnail)
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            let destination: DetailViewController = segue.destinationViewController as! DetailViewController
            destination.displayImage = sender as? UIImage
        }
    }
}


extension ThumbnailCollectionView: UICollectionViewDelegateFlowLayout {
    // this method adds a nice border around each image
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let index = indexPath.row
        if let currentPhoto = myDataStore.getImage(index) {
            var size = currentPhoto.size
            size.width += 5 ; size.height += 5
            return size
        } else {
            return CGSize(width: 0, height: 0)
        }
    }

    // this method adds padding around collection view edges to improve layout
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
}
