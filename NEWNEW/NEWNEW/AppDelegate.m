//
//  AppDelegate.m
//  NEWNEW
//
//  Created by mac on 16/1/4.
//  Copyright © 2016年 孙晓东. All rights reserved.
//

#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>
#import "notify.h"
@interface AppDelegate ()
{
    NSTimer *_timer;
    NSInteger _count;
}
@property (assign, nonatomic) UIBackgroundTaskIdentifier backgroundUpdateTask;
@property (nonatomic) int oldValue;
@end
static int setScreenStateCb() {
    uint64_t locked;
    
    __block int token = 0;
    
    notify_register_dispatch("com.apple.iokit.hid.displayStatus",&token,dispatch_get_main_queue(),^(int t){
        
    });
    
    notify_get_state(token, &locked);
    
    
    //    NSLog(@"状态：%d",(int)locked);
    
    return (int)locked;
}

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //应用可以后台运行的设置
    NSError *setCategoryErr = nil;
    NSError *activationErr = nil;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&setCategoryErr];
    [[AVAudioSession sharedInstance] setActive:YES error:&activationErr];
    //添加定时器
    _timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(startListen:) userInfo:nil repeats:YES];
    //暂停
    [_timer setFireDate:[NSDate distantFuture]];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    UIApplication *app = [UIApplication sharedApplication];
    __block UIBackgroundTaskIdentifier bgTask;
    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid) {
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    }];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid) {
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    });
    //开启
    [_timer setFireDate:[NSDate distantPast]];
    _count = 0;

}
- (void)startListen:(NSTimer *)timer {
    _count ++;
    self.oldValue = setScreenStateCb();
    
    [self addObserver:self forKeyPath:@"oldValue" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
    
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    int new = [(NSNumber *)change[@"new"] intValue];
    int old = [(NSNumber *)change[@"old"] intValue];
    if (new - old == 1) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeNameNotification" object:self userInfo:nil];
    }
}
- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    //暂停
    [_timer setFireDate:[NSDate distantFuture]];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
