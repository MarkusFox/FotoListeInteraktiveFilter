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

    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let ph = photosArr[indexPath.item]
        let imagevc = storyboard?.instantiateViewController(withIdentifier: "imageVC") as! ImageViewController
        self.present(imagevc, animated: true) {
            imagevc.setDisplayImage(ph, imageManager: self.imagemanager)
        }
    }
}
