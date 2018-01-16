### Flickr Images App

#### Created by Natalia Chodelski on 01/04/2016.


#### App architecture & Behaviour:

This is a single page app that downloads and displays public photos from a flickr user, currently the user is hardcoded and passed in via their user number.   The app consists of a UICollectionView embedded as a child view controller in a Container View of the parent view controller.   The collection view displays thumbnail photos that are downloaded from flickr. The collection view is a custom subclass of UICollectionViewController, and the UICollectionViewCell used to display images is also a custom subclass. 

The data model class contains a private array of "Image Objects", with a number of getter and setter methods used to access and store properties in the Image Objects. Image Objects are instances of an Image Object class: an NSObject that stores an image's Title and  URL in String format, and an optional UIImage. 

A helper class called DownloadHelper has methods to download and store information from flickr. downloadMetadata gets the image metadata for up to 150 images from a flickr account's public photostream using flickr's flickr.people.getPublicPhotos API. The UserID indicating which account to retrieve photos from is hardcoded in  DownloadHelper, along with a hardcoded Int representing the maximum number of images for download. 

 Image data is retrieved using NSURLSession's dataTaskWithURL method. This API returns a json object, which is parsed with the SwiftyJSON Cocoapod. By concatenating parsed Strings from the json metadata, a String URL representing where each image thumbnail is hosted is created. The parsed image title and hosting URL for each image is appended as an ImageObject into a temporary array, and then passed into the data storage using a completion handler that returns a bool indicating whether the data was successfully retrieved. 

If the downloadMetadata completion handler returns success, another DownloadHelper method, downloadImages, is then triggered. This method iterates through each ImageObject in the data model, and using the image URL created previously, downloads the image thumbnail using  NSURLSession's dataTaskWithURL method.  Once each image is retrieved, it is passed to a completion handler that stores it in the current ImageObject's thumbnail property.  Another method, checkImageCompletion, runs once each image has been stored in order to that all images are downloaded. When all are confirmed, imagecheckImageCompletion sends a global  notification to the main thread, which is then observed by the CollectionView controller, ThumbnailCollectionView, and triggers a UICollectionView reload.  This populates the CollectionView with the number of cells and displays an image thumbnail in each cell. 


#### Next Steps:

There were some additional features I would like to implement if I spent further time working on this app. These are:

	1.	Add UI and Unit Tests that perform automated checks confirming that certain key methods and behaviours work to ensure I know immediately if i have broken something while extending the functionality. 
	2.	Add a UITextField  at the top of the collection view that allows the user to input the user name of a flickr user and then retrieves the public images from their account.  I looked into this a bit and I would need to implement another flickr API, flickr.people.findByUsername, to translate flickr usernames into the alphanumerical UserIDs that the flickr.people.getPublicPhotos API requires.  I would also need to implement a function to check if entered usernames exist, and if not, to create a UIAlertView informing the user that the inputed username cannot retrieve any images.  
	3.	Implement a UITextField "number of images to display" where users can input an integer that customises the number of images retrieved by the API. 
	4.	Create a segue to another view. When a user taps an image in the collection view, it would then either download and present the full size image in a UIImageView, or it would open the image on the flickr website within a WebView using the SafariServicesframework. 
	5.	The "stretch goal' project could be creating this app with a TabBar interface, where each tab brings up image results with a different flickr API method, i.e. one tab would allow images to be retrieved by username, another would allow images to be searched and displayed  by inputting a name or tag, while another finds and retrieves photosets of images.


