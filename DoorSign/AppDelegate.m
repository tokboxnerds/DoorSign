//
//  AppDelegate.m
//  DoorSign
//
//  Created by Patrick Quinn-Graham on 26/06/2014.
//  Copyright (c) 2014 Patrick Quinn-Graham. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()
            

@end

@implementation AppDelegate

+ (EKEventStore*)eventStore {
    return [self.class sharedDelegate].eventStore;
}

+ (AppDelegate*)sharedDelegate {
    return [UIApplication sharedApplication].delegate;
}

+ (NSString*)timeForDate:(NSDate*)date {
    static dispatch_once_t onceToken;
    static NSDateFormatter *formatter;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        formatter.dateStyle = NSDateFormatterNoStyle;
        formatter.timeStyle = NSDateFormatterShortStyle;
    });
    return [formatter stringFromDate:date];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    application.idleTimerDisabled = YES;
    self.eventStore = [[EKEventStore alloc] init];
    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    application.idleTimerDisabled = NO;
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    application.idleTimerDisabled = YES;
}

@end
