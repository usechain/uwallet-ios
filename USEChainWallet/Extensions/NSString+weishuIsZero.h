//
//  NSString+weishuIsZero.h
//  Dazui
//
//  Created by 顾雪飞 on 2017/7/28.
//  Copyright © 2017年 you. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (weishuIsZero)

// 保留inter位小数，小数尾数是0去掉
- (NSString *)eliminateZeroWithDouble:(NSInteger)integer;
// 除以10的18次方，并且保留integer位小数,小数尾数是0去掉
- (NSString *)realValueWithDouble:(NSInteger)integer;

+ (BOOL)isPureFloat:(NSString*)string;
// 去掉数字中间的逗号
- (NSString *)removeSeperate;
+ (BOOL)judgeWhetherContainSpecialCharacter:(NSString *)string;
// 给一个整数，精确计算除以10的8次方
//- (NSString *)convertToDecimalWithSquareNumber:(NSInteger)squareNumber;
- (NSString *)convertToDecimalWithSquareNumber2:(NSInteger)squareNumber;
- (BOOL)includeChinese;
- (NSString *)removeE;
- (NSString *)removeEWithDecimals:(NSInteger)decimals;
- (NSString *)removeNonNumAndLetter;
- (NSString *)removeNonNumAndLetter2;
- (NSString*)addComma;
- (NSString *)removeNonNum;

@end
