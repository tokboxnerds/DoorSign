//
//  ViewController.m
//  DoorSign
//
//  Created by Patrick Quinn-Graham on 26/06/2014.
//  Copyright (c) 2014 Patrick Quinn-Graham. All rights reserved.
//

#import "ViewController.h"
#import "DoorSignCalendar.h"

#import <EventKit/EventKit.h>

@interface ViewController ()

@property (nonatomic) EKEventStore *eventStore;
@property (nonatomic) DoorSignCalendar *calendar;
            

@end

@implementation ViewController
            
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.eventStore = [[EKEventStore alloc] init];
    
    
    [self.eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        NSAssert(granted, @"Access not granted");
        if(error) {
            NSLog(@"Error accessing calendar %@", error);
            NSAssert(error == nil, @"Error accessing calendars");
        }
        
        NSLog(@"Access granted");
        [self getCalendars];
        
        UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"calendarList"];
        [self presentViewController:vc animated:YES completion:nil];
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getCalendars {
    NSArray *calendars = [self.eventStore calendarsForEntityType:EKEntityTypeEvent];
    for(EKCalendar *cal in calendars) {
        if(cal.type == EKCalendarTypeExchange && [cal.title isEqualToString:@"TokRoom"]) {
            NSLog(@"Getting events for %@", cal);
            DoorSignCalendar *calendar = [[DoorSignCalendar alloc] initWithCalendar:cal];
            [calendar getEvents];
        }
    }
}

@end


//[[NSNotificationCenter defaultCenter] addObserver:self
//                                         selector:@selector(storeChanged:)
//                                             name:EKEventStoreChangedNotification
//                                           object:eventStore];

