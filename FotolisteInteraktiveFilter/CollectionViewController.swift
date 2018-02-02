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

    @IBOutlet var myCollectionView: UICollectionView!
    let imagemanager = PHCachingImageManager()
    var photosArr: [PHAsset] = []
    var size = CGSize(width: 56, height: 56)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let photos = PHAsset.fetchAssets(with: .image, options: nil)
        for i in 0 ..< photos.count {
            photosArr.append(photos[i])
        }
        
        //'interfaceOrientation' was deprecated in iOS 8.0 :(
        if view.bounds.size.width > view.bounds.height {
            setLayoutForCellSizing(interfaceOrientation: .landscapeLeft)
        } else {
            setLayoutForCellSizing(interfaceOrientation: .portrait)
        }
        
        imagemanager.startCachingImages(for: photosArr, targetSize: size, contentMode: .aspectFill, options: nil)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Do any additional setup after loading the view.
    }
    
    func setLayoutForCellSizing(interfaceOrientation: UIInterfaceOrientation) {
        var itemSize: CGFloat
        switch interfaceOrientation {
        case .landscapeLeft:
            itemSize = UIScreen.main.bounds.width/16
        case .landscapeRight:
            itemSize = UIScreen.main.bounds.width/16
        default:
            itemSize = UIScreen.main.bounds.width/10
        }
        size = CGSize(width: itemSize, height: itemSize)
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 10, 0)
        layout.itemSize = CGSize(width: itemSize, height: itemSize)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        myCollectionView.collectionViewLayout = layout
    }
    
    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        //goes to main queue because we need the screen width of the new device orientation
        DispatchQueue.main.async {
            self.setLayoutForCellSizing(interfaceOrientation: toInterfaceOrientation)
        }
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
