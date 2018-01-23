//
//  ImageViewController.swift
//  FotolisteInteraktiveFilter
//
//  Created by Markus Fox on 21.01.18.
//  Copyright © 2018 Markus Fox. All rights reserved.
//

import UIKit
import Photos
import CoreImage

class ImageViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var image: UIImage? {
        get {
            return imageView.image
        }
        set {
            imageView.image = newValue
            activityIndicator.stopAnimating()
        }
    }
    
    private var initialPosition: CGPoint?
    private var context = CIContext(options: nil)
    
    func setDisplayImage(_ image: PHAsset, imageManager: PHCachingImageManager) {
        activityIndicator.startAnimating()
        /*
         might be unneccessary in this assignment but: use [weak self] to prevent a memory cycle loop
         we don't want the imagerequest to keep the controller alive, although it might not even be used anymore
        */
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            imageManager.requestImageData(for: image, options: nil) { (data, _, _, _) in
                let retrievedPhoto = UIImage(data: data!)
                DispatchQueue.main.async {
                    self?.image = retrievedPhoto
                }
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        initialPosition = touches.first?.location(in: self.view)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let from = initialPosition, let to = touches.first?.location(in: self.view) {
            let xDiff = max(from.x, to.x) - min(from.x, to.x)
            let yDiff = max(from.y, to.y) - min(from.y, to.y)
            //print(xDiff)
            //print(yDiff)
            if xDiff >= yDiff {
                //Sättigung Filter
                let percentage = to.x / self.view.frame.width
                let inputImg = CIImage(image: self.image!)
                DispatchQueue.global(qos: .userInitiated).async {
                    let filter = CIFilter(name: "CIColorControls")
                    filter?.setValue(inputImg, forKey: "inputImage")
                    filter?.setValue(percentage, forKey: "inputSaturation")
                    
                    let cgImage = self.context.createCGImage(filter!.outputImage!, from: filter!.outputImage!.extent)
                    let newImage = UIImage(cgImage: cgImage!)
                    DispatchQueue.main.async {
                        self.image = newImage
                    }
                }
            } else {
                //Pixellate Filter
                let percentage = to.y / self.view.frame.height
                let scale = 50.00 * percentage
                let inputImg = CIImage(image: self.image!)
                DispatchQueue.global(qos: .userInitiated).async {
                    let filter = CIFilter(name: "CIPixellate")
                    filter?.setValue(inputImg, forKey: "inputImage")
                    filter?.setValue(scale, forKey: "inputScale")
                    
                    let cgImage = self.context.createCGImage(filter!.outputImage!, from: filter!.outputImage!.extent)
                    let newImage = UIImage(cgImage: cgImage!)
                    DispatchQueue.main.async {
                        self.image = newImage
                    }
                }
            }
        }
        initialPosition = nil
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
