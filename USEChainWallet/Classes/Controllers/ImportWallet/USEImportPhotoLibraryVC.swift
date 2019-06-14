//
//  HWHTempViewcontroller.swift
//  USEChainWallet
//
//  Created by Jacob on 2019/4/2.
//  Copyright © 2019 Jacob. All rights reserved.
//

import UIKit
import QRCodeReader
import AVFoundation

class USEImportPhotoLibraryVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = UIImagePickerController.SourceType.photoLibrary
        present(imagePickerController, animated: true, completion: {
            imagePickerController.delegate = self
        })
    }
}

extension USEImportPhotoLibraryVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
         let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        let ciImage : CIImage = CIImage(image: image)!
        let context = CIContext(options: nil)
        let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: context, options: [CIDetectorAccuracy:CIDetectorAccuracyHigh])
         let features = detector?.features(in: ciImage)
        UserDefaults.standard.setValue((features?.last as! CIQRCodeFeature).messageString, forKey: "scanPrivateKeyStr")
        picker.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: false)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: false)
    }
    
}
