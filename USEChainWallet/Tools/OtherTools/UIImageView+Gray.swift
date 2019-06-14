//
//  UIImageView+Gray.swift
//  Dazui
//
//  Created by wakaka on 2018/3/23.
//  Copyright © 2018年 you. All rights reserved.
//

import Foundation

extension UIImage {
    
    func grayImage() -> UIImage? {
        let colorSpace = CGColorSpaceCreateDeviceGray()
        let context = CGContext.init(data: nil, width: Int(self.size.width), height: Int(self.size.height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: 1)
        if context == nil {
            return nil
        }
        context?.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: Int(self.size.width), height: Int(self.size.height)))
        let grayImage = UIImage.init(cgImage: (context?.makeImage())!)
        return grayImage
    }
}

