//
//  NSData+DataFromString.h
//  Dazui
//
//  Created by 顾雪飞 on 2017/8/31.
//  Copyright © 2017年 you. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (DataFromString)

+ (NSData *)convertHexStrToData:(NSString *)str;

@end
