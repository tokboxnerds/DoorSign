//
//  DoorSignCalendar.m
//  DoorSign
//
//  Created by Patrick Quinn-Graham on 26/06/2014.
//  Copyright (c) 2014 Patrick Quinn-Graham. All rights reserved.
//

#import "DoorSignCalendar.h"
#import "AppDelegate.h"

@interface DoorSignCalendar ()

@property (nonatomic) EKCalendar *calendar;

@end

@implementation DoorSignCalendar

- (instancetype)initWithCalendar:(EKCalendar*)calendar {
    if(self = [super init]) {
        self.calendar = calendar;
        
    }
    return self;
}

- (NSString*)title {
    return self.calendar.title;
}

- (NSArray*)currentEvents {
    NSPredicate *predicate = [[[AppDelegate sharedDelegate] eventStore] predicateForEventsWithStartDate:[NSDate date] endDate:[NSDate date] calendars:@[self.calendar]];
    return [[[AppDelegate sharedDelegate] eventStore] eventsMatchingPredicate:predicate];
}

- (NSArray*)todaysEvents {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents * tomorrowComponents = [[NSDateComponents alloc] init];
    tomorrowComponents.day = 1;
    NSDate *tomorrow = [calendar dateByAddingComponents:tomorrowComponents toDate:[NSDate date] options:0];

    tomorrow = [calendar dateFromComponents:[calendar components: (NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:tomorrow]];

    
    
    NSPredicate *predicated = [[[AppDelegate sharedDelegate] eventStore] predicateForEventsWithStartDate:[NSDate date] endDate:tomorrow calendars:@[self.calendar]];
    
    NSArray *events = [[[AppDelegate sharedDelegate] eventStore] eventsMatchingPredicate:predicated];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateStyle = NSDateFormatterMediumStyle;
    df.timeStyle = NSDateFormatterShortStyle;
    
    for(EKEvent *item in events) {
        NSLog(@"Event: %@ at %@ -> %@", item.title, [df stringFromDate:item.startDate], [df stringFromDate:item.endDate]);
    }
    return events;
    
}

- (EKEvent*)addEvent:(NSString*)title startTime:(NSDate*)startTime endTime:(NSDate*)endTime {
    EKEvent *event = [EKEvent eventWithEventStore:[[AppDelegate sharedDelegate] eventStore]];
    event.title = title;
    event.startDate = startTime;
    event.endDate = endTime;
    NSLog(@"my calendar is %@", self.calendar.title);
    event.calendar = self.calendar;
    NSError *err = nil;
    if(![[[AppDelegate sharedDelegate] eventStore] saveEvent:event span:EKSpanThisEvent error:&err]) {
        NSLog(@"Unable to save event! %@", err);
        [[[UIAlertView alloc] initWithTitle:err.localizedDescription message:err.localizedRecoverySuggestion delegate:nil cancelButtonTitle:@"Abandon all hope" otherButtonTitles:nil] show];
    }
    return event;
}

#pragma mark - Calendar API

@end
