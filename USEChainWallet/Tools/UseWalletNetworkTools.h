//
//  UseWalletNetworkTools.h
//  UseChain
//
//  Created by Jacob on 2019/2/28.
//  Copyright © 2019 Jacob. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

@interface UseWalletNetworkTools : AFHTTPSessionManager

//+ (instancetype)sharedTools;
+ (instancetype)sharedETHTools;
+ (instancetype)sharedEtherscanTools;
+ (instancetype)sharedEthplorerTools;
//+ (instancetype)sharedBTC123Tools;
+ (instancetype)sharedBlockChainTools;
+ (instancetype)sharedCATools;
+ (instancetype)sharedGetCRTTools;
+ (instancetype)sharedUSETools;
+ (instancetype)sharedUSEBrowserTools;

/**
 *  网络方法
 */
- (void)request:(NSString *)method URLString:(NSString *)URLString parameters:(id)parameters finished:(void (^)(id result, NSError *error))finished;

- (void)upload:(NSString *)method Userdata:(NSDictionary *)userdata URLString:(NSString *)URLString parameters:(NSDictionary *)parameters finished:(void (^)(id result, NSError *error))finished;



@end
