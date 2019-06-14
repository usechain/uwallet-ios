//
//  UseWalletNetworkTools.m
//  UseChain
//
//  Created by Jacob on 2019/2/28.
//  Copyright © 2019 Jacob. All rights reserved.
//

#import "UseWalletNetworkTools.h"
#import "AppDelegate.h"
#import "YYCategories.h"
#import "UIImage+USEImage.h"
@implementation UseWalletNetworkTools

static id _instace = nil;
//+(instancetype)sharedTools {
//    static UseWalletNetworkTools *instance;
//    
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        NSURL *baseUrl = [NSURL URLWithString:@"https://api.yunzic.com/api/"];
//        //        NSURL *baseUrl = [NSURL URLWithString:@"http://192.168.11.22/yunzicDzb/public/api/"];
//        instance = [[UseWalletNetworkTools alloc] initWithBaseURL:baseUrl];
//        instance.responseSerializer = [AFJSONResponseSerializer serializer];
//        instance.requestSerializer = [AFJSONRequestSerializer serializer];
//        [instance.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//        instance.responseSerializer.acceptableContentTypes = [instance.responseSerializer.acceptableContentTypes setByAddingObjectsFromArray:@[@"text/plain", @"text/html"]];
//    });
//    instance.requestSerializer.timeoutInterval = 50;
//    NSDictionary *login = [[NSUserDefaults standardUserDefaults] objectForKey:@"login"];
//    NSString *token = login[@"token"];
//    if (token) {
//        [instance.requestSerializer setValue:token forHTTPHeaderField:@"token-id"];
//    }
//    NSString *languageType = @"1";
//    if (isTraditionalChinese) {
//        languageType = @"2";
//    } else if (isEnglish) {
//        languageType = @"3";
//    }
//    [instance.requestSerializer setValue:languageType forHTTPHeaderField:@"trans"];
//    return instance;
//}
+(instancetype)sharedETHTools {
    static UseWalletNetworkTools *instance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL *baseUrl = [NSURL URLWithString:@"https://mainnet.infura.io/"];
        instance = [[UseWalletNetworkTools alloc] initWithBaseURL:baseUrl];
        instance.responseSerializer = [AFJSONResponseSerializer serializer];
        instance.requestSerializer = [AFJSONRequestSerializer serializer];
        [instance.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        instance.responseSerializer.acceptableContentTypes = [instance.responseSerializer.acceptableContentTypes setByAddingObjectsFromArray:@[@"text/plain", @"text/html"]];
    });
    instance.requestSerializer.timeoutInterval = 50;
    NSDictionary *login = [[NSUserDefaults standardUserDefaults] objectForKey:@"login"];
    NSString *token = login[@"token"];
    if (token) {
        [instance.requestSerializer setValue:token forHTTPHeaderField:@"token-id"];
    }
    NSString *languageType = @"1";
    if (isTraditionalChinese) {
        languageType = @"2";
    } else if (isEnglish) {
        languageType = @"3";
    }
    [instance.requestSerializer setValue:languageType forHTTPHeaderField:@"trans"];
    return instance;
}
+(instancetype)sharedEtherscanTools {
    static UseWalletNetworkTools *instance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        NSURL *baseUrl = [NSURL URLWithString:@"https://api.etherscan.io/api/"];
        instance = [[UseWalletNetworkTools alloc] initWithBaseURL:baseUrl];
        instance.responseSerializer = [AFJSONResponseSerializer serializer];
        instance.requestSerializer = [AFJSONRequestSerializer serializer];//请求
        [instance.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        instance.responseSerializer.acceptableContentTypes = [instance.responseSerializer.acceptableContentTypes setByAddingObjectsFromArray:@[@"text/plain", @"text/html"]];
    });
    
    return instance;
}

+ (instancetype)sharedEthplorerTools {
    static UseWalletNetworkTools *instance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        NSURL *baseUrl = [NSURL URLWithString:@"https://api.ethplorer.io/"];
        instance = [[UseWalletNetworkTools alloc] initWithBaseURL:baseUrl];
        instance.responseSerializer = [AFJSONResponseSerializer serializer];
        instance.requestSerializer = [AFJSONRequestSerializer serializer];//请求
        [instance.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        instance.responseSerializer.acceptableContentTypes = [instance.responseSerializer.acceptableContentTypes setByAddingObjectsFromArray:@[@"text/plain", @"text/html"]];
    });
    
    return instance;
}

+ (instancetype)sharedBlockChainTools {
    static UseWalletNetworkTools *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL *baseUrl = [NSURL URLWithString:@"https://blockchain.info/"];
        instance = [[UseWalletNetworkTools alloc] initWithBaseURL:baseUrl];
        instance.responseSerializer = [AFJSONResponseSerializer serializer];
        instance.requestSerializer = [AFJSONRequestSerializer serializer];
        [instance.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        instance.responseSerializer.acceptableContentTypes = [instance.responseSerializer.acceptableContentTypes setByAddingObjectsFromArray:@[@"text/plain", @"text/html"]];
    });
    return instance;
}
//https://chain.api.btc.com/v3/tx/d3e96b421807eaae49432d40d8605b6afeca178384ac542b97e0a4db7333ee74?verbose=3&_ga=2.255868555.121280017.1511851203-1185178067.1504063275
//+ (instancetype)sharedChainTools {
//    static UseWalletNetworkTools *instance;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        NSURL *baseUrl = [NSURL URLWithString:@"https://chain.api.btc.com/v3/tx/"];
//        instance = [[UseWalletNetworkTools alloc] initWithBaseURL:baseUrl];
//        instance.responseSerializer = [AFJSONResponseSerializer serializer];
//        instance.requestSerializer = [AFJSONRequestSerializer serializer];
//        [instance.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//        instance.responseSerializer.acceptableContentTypes = [instance.responseSerializer.acceptableContentTypes setByAddingObjectsFromArray:@[@"text/plain", @"text/html"]];
//    });
//    return instance;
//}

+ (instancetype)sharedUSETools {
    static UseWalletNetworkTools *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // http://39.97.174.114:8848/ beta

        NSURL *baseUrl = [NSURL URLWithString:@"http://39.97.174.114:8848/"];
        instance = [[UseWalletNetworkTools alloc] initWithBaseURL:baseUrl];
        instance.responseSerializer = [AFJSONResponseSerializer serializer];
        instance.requestSerializer = [AFJSONRequestSerializer serializer];
        [instance.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        instance.responseSerializer.acceptableContentTypes = [instance.responseSerializer.acceptableContentTypes setByAddingObjectsFromArray:@[@"text/plain", @"text/html"]];
    });
    return instance;
}

+ (instancetype)sharedUSEBrowserTools {
    static UseWalletNetworkTools *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // moonet 47.112.117.48
        // 39.105.89.191:
        NSURL *baseUrl = [NSURL URLWithString:@"https://mainnet.usechain.cn/api/v1/"];
        instance = [[UseWalletNetworkTools alloc] initWithBaseURL:baseUrl];
        instance.responseSerializer = [AFJSONResponseSerializer serializer];
        instance.requestSerializer = [AFJSONRequestSerializer serializer];
        [instance.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        instance.responseSerializer.acceptableContentTypes = [instance.responseSerializer.acceptableContentTypes setByAddingObjectsFromArray:@[@"text/plain", @"text/html"]];
    });
    return instance;
}

+ (instancetype)sharedCATools {
    static UseWalletNetworkTools *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL *baseUrl = [NSURL URLWithString:@"http://mainca.usechain.cn/cert/cerauth"];
        instance = [[UseWalletNetworkTools alloc] initWithBaseURL:baseUrl];
        instance.responseSerializer = [AFJSONResponseSerializer serializer];
        instance.requestSerializer = [AFJSONRequestSerializer serializer];
        instance.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:
                                                              @"application/json",
                                                              @"text/html"       ,
                                                              @"image/jpeg"      ,
                                                              @"image/png"       ,
                                                              @"image/jpg"       ,
                                                              @"application/octet-stream",
                                                              @"text/json"      ,
                                                              nil] ;
        instance.responseSerializer.acceptableContentTypes = [instance.responseSerializer.acceptableContentTypes setByAddingObjectsFromArray:@[@"text/plain", @"text/html"]];
        
    });
    return instance;
}

+ (instancetype)sharedGetCRTTools {
    static UseWalletNetworkTools *instance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL *baseUrl = [NSURL URLWithString:@"http://mainca.usechain.cn/cert/getCertByCertId"];
        instance = [[UseWalletNetworkTools alloc] initWithBaseURL:baseUrl];
        instance.responseSerializer = [AFJSONResponseSerializer serializer];
        instance.requestSerializer = [AFJSONRequestSerializer serializer];
        [instance.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        instance.responseSerializer.acceptableContentTypes = [instance.responseSerializer.acceptableContentTypes setByAddingObjectsFromArray:@[@"text/plain", @"text/html"]];
    });
    return instance;
}

- (void)request:(NSString *)method URLString:(NSString *)URLString parameters:(NSDictionary *)parameters finished:(void (^)(id result, NSError *error))finished {
    NSString *token = [[NSUserDefaults standardUserDefaults] valueForKey:@"token"];
    if (token) {
        [self.requestSerializer setValue: token forHTTPHeaderField:@"token-id"];
    }
    if ([method  isEqual: @"GET"]) {
        [self GET:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            finished(responseObject, nil);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            finished(nil, error);
        }];
    } else {
        [self POST:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            finished(responseObject, nil);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            finished(nil, error);
        }];
    }
}


- (void)upload:(NSString *)method Userdata:(NSDictionary *)userdata URLString:(NSString *)URLString parameters:(NSDictionary *)parameters finished:(void (^)(id result, NSError *error))finished {
    [self POST:@"" parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData *csrData = [method dataUsingEncoding:NSUTF8StringEncoding];
        [formData appendPartWithFormData:csrData name:@"csr"];

        NSData *dataData = [NSJSONSerialization dataWithJSONObject:userdata options:0 error:NULL];
        [formData appendPartWithFormData:dataData name:@"data"];
        // image 从沙盒里取3张图片

        NSString * frontPATH =[NSString stringWithFormat:@"%@/Documents/frontImage.png",NSHomeDirectory()];
        NSString * backPATH =[NSString stringWithFormat:@"%@/Documents/BackImage.png",NSHomeDirectory()];
        NSString * holdPATH =[NSString stringWithFormat:@"%@/Documents/HoldImage.png",NSHomeDirectory()];

        NSData *frontImageData = [NSData dataWithContentsOfFile:frontPATH];

        NSData *backImageData = [NSData dataWithContentsOfFile:backPATH];

        NSData *holdImageData = [NSData dataWithContentsOfFile:holdPATH];
   
        NSString *cardType = [[NSUserDefaults standardUserDefaults] valueForKey:@"kKycCardType"];
        NSLog(@"%@", cardType);
        if ([cardType  isEqual: @"IDCard"]) {
            [formData appendPartWithFileData:frontImageData name:@"front" fileName:@"front" mimeType:@"application/octet-stream"];
            [formData appendPartWithFileData:backImageData name:@"back" fileName:@"back" mimeType:@"application/octet-stream"];
            [formData appendPartWithFileData:holdImageData name:@"hold" fileName:@"hold" mimeType:@"application/octet-stream"];
        } else {
            // passport
            [formData appendPartWithFileData:frontImageData name:@"front" fileName:@"front" mimeType:@"application/octet-stream"];
            [formData appendPartWithFileData:holdImageData name:@"hold" fileName:@"hold" mimeType:@"application/octet-stream"];
        }
        

    } progress:nil
       success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        finished(responseObject, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        finished(nil, error);
    }];
}

@end

