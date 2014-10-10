//
//  AppDelegate.h
//  DoorSign
//
//  Created by Patrick Quinn-Graham on 26/06/2014.
//  Copyright (c) 2014 Patrick Quinn-Graham. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) EKEventStore *eventStore;

+ (AppDelegate*)sharedDelegate;
+ (EKEventStore*)eventStore;

+ (NSString*)timeForDate:(NSDate *)date;

@end

