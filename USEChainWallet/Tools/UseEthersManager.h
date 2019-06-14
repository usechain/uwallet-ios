//
//  UseEthersManager.h
//  UseChain
//
//  Created by Jacob on 2019/2/28.
//  Copyright © 2019 Jacob. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ethers/ethers.h>

@interface UseEthersManager : Account

+ (NSString *)getHexByDecimal:(long long)decimal;

+ (Account *)createAccount;

+ (Account *)getAccountWithMnemonicPhrase:(NSString *)MnemonicPhrase;

+ (Account *)getAccountWithPrivateKey:(NSData *)privateKey;

+ (void)getAccountWithJsonKey:(NSString *)jsonKey andPassword:(NSString *)password finished:(void (^)(Account *account, NSError *error))finished;

+ (void)encryptAccount:(Account *)account WithPassword:(NSString *)password finished:(void (^)(id result, NSError *error))finished;

+ (void)getBalanceFromAddress:(NSString *)address finished:(void (^)(id result, NSError *error))finished;

+ (void)getEstimateGasfinished:(void (^)(id result, NSError *error))finished;

+ (void)getTxListByAddress:(NSString *)address finished:(void (^)(id result, NSError *error))finished;

+ (void)getCopycatBalanceWithCoinType:(NSString *)coinType andAddress:(NSString *)address finished:(void (^)(id result, NSError *error))finished;

+ (NSNumber *)numberHexString:(NSString *)aHexString;

+ (void)confimBlockOfTx:(NSString *)txHashStr finished:(void (^)(id result, NSError *error))finished;

+ (void)isPending:(NSString *)txHashStr finished:(void (^)(id result, NSError *error))finished;

+ (BOOL)isValidMnemonicWord:(NSString *)word;

+ (void)getERC20AddressInfoWithAddress:(NSString *)address finished:(void (^)(id result, NSError *error))finished;

+ (void)getAltcoinBalanceWithContractAddress:(NSString *)contractAddress andAddress:(NSString *)address finished:(void (^)(id result, NSError *error))finished;

//+(void)account:(Account *)account sendTransactionWithGaslimit:(NSString *)gaslimit GasPrice:(NSString *)gasPrice AndValue:(NSString *)value ToAddress:(NSString *)address AndData:(NSData *)data finished:(void (^)(id result, NSError *error))finished;
    
    +(void)account:(Account *)account sendTransactionWithGaslimit:(NSString *)gaslimit GasPrice:(NSString *)gasPrice AndValue:(NSString *)value Flag:(int)flag ToAddress:(NSString *)address AndData:(NSData *)data finished:(void (^)(id result, NSError *error))finished;


+ (NSString *)generateCsr:(NSString *)hashCertyWithId AndHashUserData:(NSString *)hashUserData;

+ (Address *)addressWithString:(NSString *)addressStr;

+ (NSString *)addressFromIbanAddress: (NSString *)ibanAddress;



@end
