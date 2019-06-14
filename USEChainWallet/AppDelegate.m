//
//  AppDelegate.m
//  USEChainWallet
//
//  Created by Jacob on 2019/3/3.
//  Copyright © 2019 Jacob. All rights reserved.
//

#import "AppDelegate.h"
#import "USEChainWallet-Swift.h"
#import "UseEthersManager.h"
#import "pkcs10header.h"
#import "UseWalletNetworkTools.h"

#import "UICKeyChainStore.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    NSMutableArray *tempArray = [[NSUserDefaults standardUserDefaults] valueForKey:@"USECurrentAccountInfo"];
    if (tempArray.count != 0) {
        self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[USEWalletMainOldVC alloc]init]];
    } else {
        self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[USEWalletMainNewVC alloc]init]];
    }
    [self.window makeKeyAndVisible];
    [self initCommunityPubkey];
    return YES;
    
}

- (void)initCommunityPubkey {
    [UseChainNetTools getCommunityPublicKeyWithResource:^(id result, NSError * error) {
        NSLog(@"%@", result);
        if (error != nil || result == nil) {
            return;
        }
        NSString *contractAbiCode = result[@"result"];
        NSString *communityPublicKey = [UseChainNetTools decodeCommunityPubKeyWithContractAbiCode:contractAbiCode];
        [[NSUserDefaults standardUserDefaults] setValue:communityPublicKey forKey:@"communityPulickKey"];
    }];
}

- (void)applicationWillResignActive:(UIApplication *)application {

}


- (void)applicationDidEnterBackground:(UIApplication *)application {

}


- (void)applicationWillEnterForeground:(UIApplication *)application {

}


- (void)applicationDidBecomeActive:(UIApplication *)application {

}


- (void)applicationWillTerminate:(UIApplication *)application {

}


@end
