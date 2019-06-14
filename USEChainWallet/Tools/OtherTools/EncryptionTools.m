//
//  encryptionTools.m
//  Dazui
//
//  Created by Mr_朱 on 2017/8/14.
//  Copyright © 2017年 you. All rights reserved.
//

#import "EncryptionTools.h"

@implementation EncryptionTools
-(NSString *) salt:(NSString *)pass{
    NSString *sha1Str = [pass sha1String];
    NSString *md5Str = [[NSString stringWithFormat:@"%@%@",pass,sha1Str] md5String];
    return md5Str;
}
@end
