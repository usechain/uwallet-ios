//
//  UIImage+USEImage.h
//  USEChainWallet
//
//  Created by Jacob on 2019/3/29.
//  Copyright © 2019 Jacob. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (USEImage)

- (UIImage *)compressToByte:(NSUInteger)maxLength;

+ (UIImage *)getImageWithName:(NSString *)name;

+ (UIImage *)generateQrcode:(NSString *)string;

+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size ;

+ (NSData *)reSizeImageData:(UIImage *)sourceImage maxImageSize:(CGFloat)maxImageSize maxSizeWithKB:(CGFloat) maxSize;

@end

NS_ASSUME_NONNULL_END
