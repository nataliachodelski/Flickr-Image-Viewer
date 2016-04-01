
//  ThumbnailCollectionView.swift
//  Flickr Images
//
//  Created by Natalia on 30/03/2016.
//  Copyright © 2016 NataliaDeveloper. All rights reserved.
//


// Flickr Viewer
//Key: bd572be0a9130ed85862e0ca053e99df
//
//Secret: 69a2a7029940acc1


import UIKit
import SwiftyJSON // cocoapod helper class that

// TO DO LIST: hook test functions into bigger unit test framework
// write as a neat list of future directions for the app in README file
// ** Handle case of whether a account doesnt exist or has no images, so it wont crash. show message informing user perhaps? 
// ** handle huge image set - chose reasonable cutoff?  
// Make a couple testing functions at the bottom of the file

// ADD INFO ABOUT THIS CLASS XXXXX
// *XX  Cleanup public, priv _, etc


class ThumbnailCollectionView: UICollectionViewController
{
    let myDataStore = ThumbnailData.sharedInstance
    let myDownloadHelper = DownloadHelper()
    var userID : String = "77248535@N06"

    private let reuseIdentifier = "reusableCell"
    private let sectionInsets = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)
    
    @IBOutlet var thisCollectionView: UICollectionView!

    
    // MARK: - View lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        myDataStore.setUsername(userID)

        navigationItem.title = "\(myDataStore.getUsername())'s public photos"
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
    
    func reloadCollection()
    {
        thisCollectionView.reloadData()
    }
    
    
    // MARK: - Collection View Data Source Methods

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return myDataStore.getCountImageDataEntries()
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! ImageCell
        let index = indexPath.row
        
        // Configure the cell
        cell.backgroundColor = UIColor.grayColor()
        cell.imageView.image = myDataStore.getImage(index)
        return cell
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    deinit
    {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}


extension ThumbnailCollectionView
{
    // MARK: UICollectionViewDelegate
    
    //Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool
    {
        return true
    }
    
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool
    {
        return true
    }
    
    
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

extension ThumbnailCollectionView : UICollectionViewDelegateFlowLayout
{
    // this method adds a nice border around each image
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        let index = indexPath.row
        if let currentPhoto =  myDataStore.getImage(index) {
            var size = currentPhoto.size
            size.width += 10 ; size.height += 10
            return size
        } else {
            return CGSize(width: 0, height: 0)
        }
    }

    // this method adds padding around collection view edges to improve layout
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               insetForSectionAtIndex section: Int) -> UIEdgeInsets
    {
        return sectionInsets
    }
}
