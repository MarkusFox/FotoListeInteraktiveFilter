//
//  CollectionViewController.swift
//  FotolisteInteraktiveFilter
//
//  Created by Markus Fox on 20.01.18.
//  Copyright © 2018 Markus Fox. All rights reserved.
//

import UIKit
import Photos

private let reuseIdentifier = "Cell"

class CollectionViewController: UICollectionViewController {

    let imagemanager = PHCachingImageManager()
    var photosArr: [PHAsset] = []
    let size = CGSize(width: 56, height: 56)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let photos = PHAsset.fetchAssets(with: .image, options: nil)
        for i in 0 ..< photos.count {
            photosArr.append(photos[i])
        }
        
        imagemanager.startCachingImages(for: photosArr, targetSize: size, contentMode: .aspectFill, options: nil)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photosArr.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CollectionViewCell
        let ph = photosArr[indexPath.item]
        imagemanager.requestImage(for: ph, targetSize: size, contentMode: .aspectFill, options: nil, resultHandler:{ (photo, nil) in
                cell.imageView.image = photo
        })
    
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let ph = photosArr[indexPath.item]
        imagemanager.requestImageData(for: ph, options: nil) { (data, _, _, _) in
            let retrievedPhoto = UIImage(data: data!)
            let photoView = UIImageView(frame: self.view.frame)
            photoView.image = retrievedPhoto
            self.view.addSubview(photoView)
        }
    }

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
