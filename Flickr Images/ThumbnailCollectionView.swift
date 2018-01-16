
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
    
    fileprivate let reuseIdentifier = "reusableCell"

    @IBOutlet var thisCollectionView: UICollectionView!
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Harryyy's public flickr photos"
        let nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.black
        nav?.barTintColor = UIColor.black
        nav?.tintColor = UIColor.blue
        nav?.isTranslucent = false
        nav?.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        NotificationCenter.default.addObserver(self,  selector: #selector(self.reloadCollection), name: NSNotification.Name(rawValue: "ReloadCollection"), object: nil)
        
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
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myDataStore.getCountImageDataEntries()
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ImageCell
        let index = indexPath.row
        
        // Configure the cell
        cell.backgroundColor = UIColor.lightGray
        cell.imageView.image = myDataStore.getImage(index)
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.row
        let thumbnail = myDataStore.getImage(index)
        let baseURL = myDataStore.getImage(index)
        self.performSegue(withIdentifier: "showDetail", sender: thumbnail)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let destinationVC: DetailViewController = segue.destination as! DetailViewController {
                
                
                destinationVC.largerImage = sender as? UIImage
            }
        }
    }
}


extension ThumbnailCollectionView: UICollectionViewDelegateFlowLayout {
    // this method adds a nice border around each image
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
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
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)

    }
}
