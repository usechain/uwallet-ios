//
//  encryptionTools.h
//  Dazui
//  加密工具
//  Created by Mr_朱 on 2017/8/14.
//  Copyright © 2017年 you. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EncryptionTools : NSObject
//登录密码加密
-(NSString *) salt:(NSString *)pass;
@end
