//
//  DoorSignCalendar.m
//  DoorSign
//
//  Created by Patrick Quinn-Graham on 26/06/2014.
//  Copyright (c) 2014 Patrick Quinn-Graham. All rights reserved.
//

#import "DoorSignCalendar.h"

@interface DoorSignCalendar ()

@property (nonatomic) EKCalendar *calendar;
@property (nonatomic) EKEventStore *store;

@end

@implementation DoorSignCalendar

- (instancetype)initWithCalendar:(EKCalendar*)calendar {
    if(self = [super init]) {
        self.store = [[EKEventStore alloc] init];
        self.calendar = calendar;
        
    }
    return self;
}

- (NSString*)title {
    return self.calendar.title;
}

- (NSArray*)currentEvents {
    NSPredicate *predicate = [self.store predicateForEventsWithStartDate:[NSDate date] endDate:[NSDate date] calendars:@[self.calendar]];
    return [self.store eventsMatchingPredicate:predicate];
}

- (NSArray*)todaysEvents {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *oneDayAgoComponents = [[NSDateComponents alloc] init];
    oneDayAgoComponents.day = -1;
    NSDate *oneDayAgo = [calendar dateByAddingComponents:oneDayAgoComponents toDate:[NSDate date] options:0];
    
    NSDateComponents * tomorrowComponents = [[NSDateComponents alloc] init];
    tomorrowComponents.day = 1;
    NSDate *tomorrow = [calendar dateByAddingComponents:tomorrowComponents toDate:[NSDate date] options:0];
    
    NSPredicate *predicated = [self.store predicateForEventsWithStartDate:oneDayAgo endDate:tomorrow calendars:@[self.calendar]];
    
    NSArray *events = [self.store eventsMatchingPredicate:predicated];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateStyle = NSDateFormatterMediumStyle;
    df.timeStyle = NSDateFormatterShortStyle;
    
    for(EKEvent *item in events) {
        NSLog(@"Event: %@ at %@ -> %@", item.title, [df stringFromDate:item.startDate], [df stringFromDate:item.endDate]);
    }
    return events;
}

#pragma mark - Calendar API

@end
