//
//  imageObjects.m
//  Dazui
//
//  Created by Mr_朱 on 2017/7/25.
//  Copyright © 2017年 you. All rights reserved.
//

#import "imageObjects.h"

@implementation imageObjects
-(UIImage *)imageUserToCompressForSizeImage:(UIImage *)image newSize:(CGSize)size{
    
    UIImage *newImage = nil;
    
    CGSize originalSize = image.size;//获取原始图片size
    
    CGFloat originalWidth = originalSize.width;//宽
    
    CGFloat originalHeight = originalSize.height;//高
    
    if ((originalWidth <= size.width) && (originalHeight <= size.height)) {
        
        newImage = image;//宽和高同时小于要压缩的尺寸时返回原尺寸
        
    }
    
    else{
        
        //新图片的宽和高
        
        CGFloat scale = (float)size.width/originalWidth < (float)size.height/originalHeight ? (float)size.width/originalWidth : (float)size.height/originalHeight;
        
        CGSize newImageSize = CGSizeMake(originalWidth*scale , originalHeight*scale );
        
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(newImageSize.width , newImageSize.height ), NO, 0);
        
        [image drawInRect:CGRectMake(0, 0, newImageSize.width, newImageSize.height) blendMode:kCGBlendModeNormal alpha:1.0];
        
        newImage = UIGraphicsGetImageFromCurrentImageContext();
        
        if (newImage == nil) {
            
            NSLog(@"image ");
            
        }
        
        UIGraphicsEndImageContext();
        
    }
    
    return newImage;
}

@end
