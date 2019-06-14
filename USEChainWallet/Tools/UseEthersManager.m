//
//  UseEthersManager.m
//  UseChain
//
//  Created by Jacob on 2019/2/28.
//  Copyright © 2019 Jacob. All rights reserved.
//

#import "UseEthersManager.h"
#import "USEChainWallet-Swift.h"
#import "pkcs10header.h"

@interface UseEthersManager()
@property (nonatomic, copy)NSString *json;
@end

@implementation UseEthersManager
+(Account *)createAccount {
    return  [Account randomMnemonicAccount];
}
+(Account *)getAccountWithMnemonicPhrase:(NSString *)MnemonicPhrase {
   // return [Account accountWithMnemonicPhrase:MnemonicPhrase];
    return  [Account accountWithMnemonicPhrase:MnemonicPhrase slot:0];
}
+(Account *)getAccountWithPrivateKey:(NSData *)privateKey {
    return [Account accountWithPrivateKey:privateKey];
}
+(void)getAccountWithJsonKey:(NSString *)jsonKey andPassword:(NSString *)password finished:(void (^)(Account *, NSError *))finished {
    [Account decryptSecretStorageJSON:jsonKey password:password callback:^(Account *account, NSError *NSError) {
        finished(account, nil);
    }];
}
+(void)encryptAccount:(Account *)account WithPassword:(NSString *)password finished:(void (^)(id, NSError *))finished {
    [account encryptSecretStorageJSON:password callback:^(NSString *json) {
        finished(json, nil);
    }];
}
    
    +(void)account:(Account *)account sendTransactionWithGaslimit:(NSString *)gaslimit GasPrice:(NSString *)gasPrice AndValue:(NSString *)value Flag:(int)flag_int ToAddress:(NSString *)address AndData:(NSData *)data finished:(void (^)(id result, NSError *error))finished {

        NSString *toAddress = [UseChainNetTools recoverToNormalAddressWithUmAddress:address];
        NSData *privateKey = account.privateKey;
        SecureData *publickKey = [Account getPublicKeyWithPrivateKey:privateKey];
        NSLog(@"%@", publickKey);
        NSString *umAddress = [UseChainNetTools getUMAddressWithPublicKey:publickKey.hexString];
        NSLog(@"%@", umAddress);
        Transaction *transaction = [[Transaction alloc] init];
        //nonce处理一下
        [UseChainNetTools getUSENonceWithAddress:umAddress resource:^(id result, NSError * error) {
            if (error) {
                finished(nil, error);
            } else {
                NSNumber *nonce = [self numberHexString:result];
                int intNonce = [nonce intValue];
                transaction.nonce = intNonce;
                transaction.gasLimit = [BigNumber bigNumberWithDecimalString:gaslimit];
                transaction.gasPrice = [BigNumber bigNumberWithDecimalString:gasPrice];
                transaction.toAddress = [Address addressWithString:toAddress];
                transaction.value = [Payment parseEther:value];
                NSNumber *flag = [NSNumber numberWithInt:flag_int];
                int intFlag = [flag intValue];
                transaction.flag = intFlag;
                transaction.data = data;
                transaction.chainId = ChainIdHomestead;
                [account sign:transaction];
                NSData *signedTransaction = [transaction serialize];
                SecureData *hexTransaction = [SecureData dataToHexString:signedTransaction];
                finished(hexTransaction, nil);
            }
        }];
        
    }
    

//+(void)account:(Account *)account sendTransactionWithGaslimit:(NSString *)gaslimit GasPrice:(NSString *)gasPrice AndValue:(NSString *)value ToAddress:(NSString *)address AndData:(NSData *)data finished:(void (^)(id result, NSError *error))finished {
//
//    NSData *privateKey = account.privateKey;
//    SecureData *publickKey = [Account getPublicKeyWithPrivateKey:privateKey];
//    NSLog(@"%@", publickKey);
//    NSString *umAddress = [UseChainNetTools getUMAddressWithPublicKey:publickKey.hexString];
//    NSLog(@"%@", umAddress);
//    // TODO:-
//    NSString *toAddress = [UseChainNetTools recoverToNormalAddressWithUmAddress:address];
//    Transaction *transaction = [[Transaction alloc] init];
//    //nonce处理一下
//    [UseChainNetTools getUSENonceWithAddress:umAddress resource:^(id result, NSError * error) {
//        if (error) {
//            finished(nil, error);
//        } else {
//            NSNumber *nonce = [self numberHexString:result];
//            int intNonce = [nonce intValue];
//            transaction.nonce = intNonce;
//            transaction.gasLimit = [BigNumber bigNumberWithDecimalString:gaslimit];
//            transaction.gasPrice = [BigNumber bigNumberWithDecimalString:gasPrice];
//            transaction.toAddress = [Address addressWithString:toAddress];
//            transaction.value = [Payment parseEther:value];
//            NSNumber *flag = [NSNumber numberWithInt:0];
//            int intFlag = [flag intValue];
//            transaction.flag = intFlag;
//            transaction.data = data;
//            transaction.chainId = ChainIdHomestead;
//            [account sign:transaction];
//            NSData *signedTransaction = [transaction serialize];
//            SecureData *hexTransaction = [SecureData dataToHexString:signedTransaction];
//            finished(hexTransaction, nil);
//        }
//    }];
//}

+(void)getBalanceFromAddress:(NSString *)address finished:(void (^)(id, NSError *))finished {
    
    [UseChainNetTools getBalanceWithAddress:address resource:^(id result, NSError * error) {
        finished(result, error);
    }];
}

+(void)getEstimateGasfinished:(void (^)(id result, NSError *error))finished {
    [UseChainNetTools getEstimateGasToAddress:@"0xAD12Ed26b3d8F2E31d9BA864Ffa07D0d2d5EE5A0" resource:^(id result, NSError * error) {
        finished(result, error);
    }];
}
+(void)getTxListByAddress:(NSString *)address finished:(void (^)(id result, NSError *error))finished {
    [UseChainNetTools getTxListWithAddress:address resource:^(id result, NSError * error) {
        finished(result, error);
    }];
}
+(void)getCopycatBalanceWithCoinType:(NSString *)coinType andAddress:(NSString *)address finished:(void (^)(id result, NSError *error))finished {
    [UseChainNetTools getCopycatBalanceWithCopyCatCoinType:coinType address:address resource:^(id result, NSError * error) {
        finished(result, error);
    }];
}

+ (void)confimBlockOfTx:(NSString *)txHashStr finished:(void (^)(id result, NSError *error))finished {
    [UseChainNetTools getCurrentBlockNumWithResource:^(id result, NSError * error) {
        if (!error) {
            NSString *blockNumHexString = result[@"result"];
            NSInteger currentBlcokNum = [self numberHexString:blockNumHexString].integerValue;
            [UseChainNetTools getTransactionByHashWithHash:txHashStr resource:^(id result, NSError * error) {
                NSLog(@"%@", txHashStr);
                NSLog(@"%@", result);
                if (result[@"result"] == nil || [result[@"result"] isEqual:[NSNull null]]) {
                    return;
                }
                NSString *txBlockNumHexString = result[@"result"][@"blockNumber"];
                NSInteger txBlcokNum = [self numberHexString:txBlockNumHexString].integerValue;
                NSInteger confimBlockNum = currentBlcokNum - txBlcokNum;
                NSString *confimBlockNumStr = [NSString stringWithFormat:@"%ld", (long)confimBlockNum];
                finished(confimBlockNumStr, error);
            }];
        }
    }];
}

+ (void)isPending:(NSString *)txHashStr finished:(void (^)(id result, NSError *error))finished {
    [UseChainNetTools getTransactionByHashWithHash:txHashStr resource:^(id result, NSError * error) {
        NSLog(@"%@", result[@"result"]);
        NSNull *temp = result[@"result"];
        if (temp == [NSNull null]) {
            
            finished(@"isPending", error);
        } else {
            finished(@"isComplete", error);
        }
    }];
}

+ (BOOL)isValidMnemonicWord:(NSString *)word {
    return [Account isValidMnemonicWord:word];
}

+ (void)getERC20AddressInfoWithAddress:(NSString *)address finished:(void (^)(id result, NSError *error))finished {
    [UseChainNetTools getERC20AddressInfoWithAddress:address resource:^(id result, NSError * error) {
        finished(result, error);
    }];
    
}

+ (void)getAltcoinBalanceWithContractAddress:(NSString *)contractAddress andAddress:(NSString *)address finished:(void (^)(id result, NSError *error))finished {
    [UseChainNetTools getAltcoinBalanceWithContractAddress:contractAddress address:address resource:^(id result, NSError * error) {
        finished(result, error);
    }];
}

// 16进制转10进制
+ (NSNumber *) numberHexString:(NSString *)aHexString
{
    // 为空,直接返回.
    if (nil == aHexString || [aHexString isEqual:[NSNull null]])
    {
        return nil;
    }
    NSScanner * scanner = [NSScanner scannerWithString:aHexString];
    unsigned long long longlongValue;
    [scanner scanHexLongLong:&longlongValue];
    //将整数转换为NSNumber,存储到数组中,并返回.
    NSNumber * hexNumber = [NSNumber numberWithLongLong:longlongValue];
    return hexNumber;
}
/**
 十进制转换十六进制
 
 @param decimal 十进制数
 @return 十六进制数
 */
+ (NSString *)getHexByDecimal:(long long)decimal {
    
    NSString *hex =@"";
    NSString *letter;
    long long number;
    while (decimal != 0) {
        number = decimal % 16;
        decimal = decimal / 16;
        switch (number) {
            case 10:
                letter =@"A"; break;
            case 11:
                letter =@"B"; break;
            case 12:
                letter =@"C"; break;
            case 13:
                letter =@"D"; break;
            case 14:
                letter =@"E"; break;
            case 15:
                letter =@"F"; break;
            default:
                letter = [NSString stringWithFormat:@"%lld", number];
        }
        hex = [letter stringByAppendingString:hex];
    }
    return hex;
}
//MARK: -替补
+ (void)ethplorerConfimBlockOfTx:(NSString *)txHashStr finished:(void (^)(id result, NSError *error))finished {
    [UseChainNetTools getTransactionFromEthploreByTxHashWithHash:txHashStr resource:^(id result, NSError * error) {
        finished(result[@"confirmations"], error);
    }];
}
+ (void)ethploreIsPending:(NSString *)txHashStr finished:(void (^)(id result, NSError *error))finished {
    [UseChainNetTools getTransactionFromEthploreByTxHashWithHash:txHashStr resource:^(id result, NSError * error) {
        
    }];
}

// CSR 是Certificate Signing Request的缩写，即证书签名请求，这不是证书，可以简单理解成公钥，生成证书时要把这个提交给权威的证书颁发机构。
//    CRT 即 certificate的缩写，即证书。
//
//    X.509 是一种证书格式.对X.509证书来说，认证者总是CA或由CA指定的人，一份X.509证书是一些标准字段的集合，这些字段包含有关用户或设备及其相应公钥的信息。
//
//    X.509的证书文件，一般以.crt结尾，根据该文件的内容编码格式，可以分为以下二种格式：
//
//    PEM - Privacy Enhanced Mail,打开看文本格式,以"-----BEGIN..."开头, "-----END..."结尾,内容是BASE64编码.
//    Apache和*NIX服务器偏向于使用这种编码格式.
//
//    DER - Distinguished Encoding Rules,打开看是二进制格式,不可读.

// 返回的数组的第一个为PKCS10 CSR证书请求，第二个值为（未加密的）私钥
+ (NSString *)generateCsr:(NSString *)hashCertyWithId AndHashUserData:(NSString *)hashUserData {


    NSString *info = [NSString stringWithFormat:@"/CN=%@/serialNumber=%@/", hashCertyWithId, hashUserData];
    // 原来是255
    char chDN[2550] ;
    memcpy(chDN, [info cStringUsingEncoding:NSASCIIStringEncoding], 2*[info length]);
    char chCSR[2048] = {0};
    char privateKey[2048] = {0};
    long int rv = GenCSR(chDN, strlen(chDN), chCSR, sizeof(chCSR),privateKey);
    NSString* pkcs10=[NSString stringWithFormat:@"%s",chCSR];
    return  pkcs10;
}

+ (Address *)addressWithString:(NSString *)addressStr {
    return [Address addressWithString:addressStr];
}

+ (NSString *)addressFromIbanAddress: (NSString *)ibanAddress {
    return [[Address addressWithString:ibanAddress] checksumAddress];
}

@end

