//
//  NSString+Size.h
//  Dazui
//
//  Created by 顾雪飞 on 2017/7/24.
//  Copyright © 2017年 you. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Size)

// 计算字符串size
- (CGSize)sizeWithFont:(UIFont *)font textMaxSize:(CGSize)maxSize;
// 是否包含emoji
+ (BOOL)stringContainsEmoji:(NSString *)string;
- (BOOL)nowIsEmojiKeyBorad;
@end
