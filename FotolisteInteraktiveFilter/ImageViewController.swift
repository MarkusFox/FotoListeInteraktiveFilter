//
//  ImageViewController.swift
//  FotolisteInteraktiveFilter
//
//  Created by Markus Fox on 21.01.18.
//  Copyright © 2018 Markus Fox. All rights reserved.
//

import UIKit
import Photos

class ImageViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    func setDisplayImage(_ image: PHAsset, imageManager: PHCachingImageManager) {
        imageManager.requestImageData(for: image, options: nil) { (data, _, _, _) in
            let retrievedPhoto = UIImage(data: data!)
            self.imageView.image = retrievedPhoto
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
