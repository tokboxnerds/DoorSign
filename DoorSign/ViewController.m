//
//  ViewController.m
//  DoorSign
//
//  Created by Patrick Quinn-Graham on 26/06/2014.
//  Copyright (c) 2014 Patrick Quinn-Graham. All rights reserved.
//

#import "ViewController.h"
#import "TodayViewController.h"

#import <EventKit/EventKit.h>

@interface ViewController ()

@end

@implementation ViewController
            
- (void)viewDidLoad {
    [super viewDidLoad];
    [[[EKEventStore alloc] init] requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        NSAssert(granted, @"Access not granted");
        if(error) {
            NSLog(@"Error accessing calendar %@", error);
            NSAssert(error == nil, @"Error accessing calendars");
        }
        
        NSLog(@"Access granted");
    }];
}

-(BOOL)prefersStatusBarHidden {
    return YES;
}

@end

