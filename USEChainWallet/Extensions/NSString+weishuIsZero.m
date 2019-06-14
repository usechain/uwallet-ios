//
//  NSString+weishuIsZero.m
//  Dazui
//
//  Created by 顾雪飞 on 2017/7/28.
//  Copyright © 2017年 you. All rights reserved.
//

#import "NSString+weishuIsZero.h"

@implementation NSString (weishuIsZero)

// 保留inter位小数，小数尾数是0去掉
- (NSString *)eliminateZeroWithDouble:(NSInteger)integer {
    
    NSString *str = [self copy];
//    NSString *str = @"200,324,213.123560079";
    NSString *newStr = @"";
    
    NSArray *array = [str componentsSeparatedByString:@","];
    for (NSInteger i = 0; i<array.count; i++) {
        NSString *s = array[i];
        newStr = [NSString stringWithFormat:@"%@%@", newStr, s];
    }
    double fdouble = newStr.doubleValue;
    
    NSString *ftotal;
    switch (integer) {
        case 1:
            ftotal = [NSString stringWithFormat:@"%.1f", fdouble];
            break;
        case 2:
            ftotal = [NSString stringWithFormat:@"%.2f", fdouble];
            break;
        case 3:
            ftotal = [NSString stringWithFormat:@"%.3f", fdouble];
            break;
        case 4:
            ftotal = [NSString stringWithFormat:@"%.4f", fdouble];
            break;
        case 5:
            ftotal = [NSString stringWithFormat:@"%.5f", fdouble];
            break;
        case 6:
            ftotal = [NSString stringWithFormat:@"%.6f", fdouble];
            break;
        case 7:
            ftotal = [NSString stringWithFormat:@"%.7f", fdouble];
            break;
        case 8:
            ftotal = [NSString stringWithFormat:@"%.8f", fdouble];
            break;
        default:
            break;
    }
    
    while ([ftotal hasSuffix:@"0"]) {
        ftotal = [ftotal substringToIndex:[ftotal length]-1];
    }
    
    if ([ftotal hasSuffix:@"."]) {
        ftotal = [ftotal substringToIndex:[ftotal length]-1];
    }
    
    return ftotal;
    
}

// 除以10的18次方，并且保留integer位小数,小数尾数是0去掉
- (NSString *)realValueWithDouble:(NSInteger)integer {
    long long ll = self.longLongValue;
    double value = ll / 1000000000000000000.0;
    NSString *valueStr = [NSString stringWithFormat:@"%f", value];
    return [valueStr eliminateZeroWithDouble:integer];
}
// 是否为浮点
+ (BOOL)isPureFloat:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return [scan scanFloat:&val] && [scan isAtEnd];
}

- (NSString *)removeSeperate {
    NSString *str = @"";
    NSArray *array = [self componentsSeparatedByString:@","];
    for (NSInteger i = 0; i<array.count; i++) {
        NSString *s = array[i];
        str = [NSString stringWithFormat:@"%@%@", str, s];
    }
    return str;
}

+ (BOOL)judgeWhetherContainSpecialCharacter:(NSString *)string {
    //提示 标签不能输入特殊字符
    NSString *str =@"^[A-Za-z0-9]+$";
    NSPredicate* emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", str];
    if (![emailTest evaluateWithObject:string]) {
        return YES;
    }
    return NO;
}



- (NSString *)convertToDecimalWithSquareNumber2:(NSInteger)squareNumber {
    if (self.length > squareNumber) { // 添加小数点
        NSString *sub1 = [self substringToIndex:self.length - squareNumber];
        NSString *sub2 = [self substringFromIndex:self.length - squareNumber];
        return [NSString stringWithFormat:@"%@.%@", sub1, sub2];
    } else if (self.length < squareNumber) { // 添加小数点并加0
        NSString *zero;
        for (NSInteger i = 0; i<squareNumber - self.length; i++) {
            if (i==0) {
                zero = @"0";
            } else {
                zero = [NSString stringWithFormat:@"%@0", zero];
            }
        }
        return [NSString stringWithFormat:@"0.%@%@", zero, self];
    } else { // 在前面加0.
        return [NSString stringWithFormat:@"0.%@", self];
    }
}

- (BOOL)includeChinese {
    for(int i=0; i< [self length];i++) {
        int a =[self characterAtIndex:i];
        if (a>0x4e00 && a<0x9fff){
            return YES;
        }
    }
    return NO;
}

// btc矿工费和eth余额
- (NSString *)removeE {
    if ([self containsString:@"e"]) {
        NSArray *array = [self componentsSeparatedByString:@"e"];
        NSString *baseString = [NSString stringWithFormat:@"%@", array[0]];
        NSInteger multiple = 1;
        if ([self containsString:@"+"]) {
            NSArray *array = [self componentsSeparatedByString:@"+"];
            NSString *ciFang = array[1];
            while ([ciFang hasPrefix:@"0"]) {
                ciFang = [ciFang substringFromIndex:1];
                NSLog(@"压缩之后的tempString:%@",ciFang);
                for (NSInteger i = 0; i<ciFang.integerValue; i++) {
                    multiple *= 10;
                }
            }
            return [NSString stringWithFormat:@"%f", baseString.doubleValue * multiple];
            //                baseString.doubleValue * 10的负5次方
        } else if ([self containsString:@"-"]) {
            NSArray *array = [self componentsSeparatedByString:@"-"];
            NSString *ciFang = array[1];
            while ([ciFang hasPrefix:@"0"]) {
                ciFang = [ciFang substringFromIndex:1];
                NSLog(@"压缩之后的tempString:%@",ciFang);
                for (NSInteger i = 0; i<ciFang.integerValue; i++) {
                    multiple *= 10;
                }
            }
            return [NSString stringWithFormat:@"%f", baseString.doubleValue / multiple];
        }
    } else {
        return [NSString stringWithFormat:@"%@", self];
    }
    return @"0";
}

// eth代币余额
- (NSString *)removeEWithDecimals:(NSInteger)decimals {
    if ([self containsString:@"e"]) {
        NSArray *array = [self componentsSeparatedByString:@"e"];
        NSString *prefixStr = array[0];
        NSString *suffixStr = array[1];
        if ([suffixStr containsString:@"+"]) { // +
            NSArray *tempArray = [suffixStr componentsSeparatedByString:@"+"];
            NSString *cifang = tempArray[1];
            if (decimals > cifang.integerValue) { // 除以
                double multiple = 1.0;
                for (NSInteger i = 0; i<decimals - cifang.integerValue; i++) {
                    multiple *= 0.1;
                }
                return [NSString stringWithFormat:@"%f", prefixStr.doubleValue * multiple];

            } else { // 乘以
                NSInteger multiple = 1;
                for (NSInteger i = 0; i<cifang.integerValue - decimals; i++) {
                    multiple *= 10;
                }
                return [NSString stringWithFormat:@"%f", prefixStr.doubleValue * multiple];
            }

        } else { // -
            NSArray *tempArray = [suffixStr componentsSeparatedByString:@"-"];
            NSString *cifang = tempArray[1];
            double multiple = 1.0;
            for (NSInteger i = 0; i<decimals + cifang.integerValue; i++) {
                multiple *= 0.1;
            }
            return [NSString stringWithFormat:@"%f", prefixStr.doubleValue * multiple];
        }
    } else { // 不包含e
        double multiple = 1;
        for (NSInteger i = 0; i<decimals; i++) {
            multiple *= 0.1;
        }
        return [NSString stringWithFormat:@"%f", self.doubleValue * multiple];
    }
}

#pragma mark - 地址过滤非数字字母内容
- (NSString *)removeNonNumAndLetter {
    
    NSCharacterSet *setToRemove = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789.ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"] invertedSet];
    
    NSString *newString = [[self componentsSeparatedByCharactersInSet:setToRemove] componentsJoinedByString:@""];
    return newString;
}
// 图片验证码
- (NSString *)removeNonNumAndLetter2 {
    
    NSCharacterSet *setToRemove = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"] invertedSet];
    
    NSString *newString = [[self componentsSeparatedByCharactersInSet:setToRemove] componentsJoinedByString:@""];
    return newString;
}

- (NSString*)addComma {
    NSString *intStr;
    NSString *floStr;
    if ([self containsString:@"."]) {
        
        NSRange range = [self rangeOfString:@"."];
        
        floStr = [self substringFromIndex:range.location];
        
        intStr = [self substringToIndex:range.location];
        
    }else {
        floStr = @"";
        intStr = self;
    }
    if (intStr.length <=3) {
        return [intStr stringByAppendingString:floStr];
    } else {
        NSInteger length = intStr.length;
        NSInteger count = length/3;
        NSInteger y = length%3;
        NSString *tit = [intStr substringToIndex:y] ;
        NSMutableString *det = [[intStr substringFromIndex:y] mutableCopy];
        for (int i =0; i < count; i ++) {
            NSInteger index = i + i *3;
            [det insertString:@","atIndex:index];
        }
        if (y ==0) {
            det = [[det substringFromIndex:1]mutableCopy];
        }
        intStr = [tit stringByAppendingString:det];
        return [intStr stringByAppendingString:floStr];
    }
}

#pragma mark - 金额等自动过滤非数字内容
- (NSString *)removeNonNum {
    NSCharacterSet *setToRemove = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789."] invertedSet];
    NSString *newString = [[self componentsSeparatedByCharactersInSet:setToRemove] componentsJoinedByString:@""];
    return newString;
}

@end
