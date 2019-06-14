//
//  USEStoreTools.m
//  USEChainWallet
//
//  Created by Jacob on 2019/5/30.
//  Copyright © 2019 Jacob. All rights reserved.
//

#import "USEStoreTools.h"

@implementation USEStoreTools

+ (void)saveImageWithImage:(UIImage *)image AndName:(NSString *)name {
    UIImage * imgsave =image;
    NSString * path =NSHomeDirectory();
    NSString * Pathimg =[path stringByAppendingString:[NSString stringWithFormat:@"/Documents/%@.png", name]];
    [UIImagePNGRepresentation(imgsave) writeToFile:Pathimg atomically:YES];
    // 沙盒路径
    NSLog(@"%@",path);
}

@end
