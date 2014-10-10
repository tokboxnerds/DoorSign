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
    NSPredicate *predicate = [[AppDelegate eventStore] predicateForEventsWithStartDate:[NSDate date] endDate:[NSDate date] calendars:@[self.calendar]];
    return [[[AppDelegate sharedDelegate] eventStore] eventsMatchingPredicate:predicate];
}

- (NSArray*)todaysEvents {
    EKEventStore *store = [AppDelegate eventStore];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *tomorrowComponents = [[NSDateComponents alloc] init];
    tomorrowComponents.day = 1;

    NSDate *tomorrow = [calendar dateByAddingComponents:tomorrowComponents toDate:[NSDate date] options:0];
    tomorrow = [calendar dateFromComponents:[calendar components: (NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:tomorrow]];
    
    return [store eventsMatchingPredicate:[store predicateForEventsWithStartDate:[NSDate date]
                                                                         endDate:tomorrow
                                                                       calendars:@[self.calendar]]];
}

- (EKEvent*)addEvent:(NSString*)title startTime:(NSDate*)startTime endTime:(NSDate*)endTime {
    EKEventStore *store = [AppDelegate eventStore];
    EKEvent *event = [EKEvent eventWithEventStore:store];
    event.title = title;
    event.startDate = startTime;
    event.endDate = endTime;
    event.calendar = self.calendar;
    NSError *err = nil;
    if(![store saveEvent:event span:EKSpanThisEvent error:&err]) {
        [[[UIAlertView alloc] initWithTitle:err.localizedDescription message:err.localizedRecoverySuggestion delegate:nil cancelButtonTitle:@"Abandon all hope" otherButtonTitles:nil] show];
    }
    return event;
}

@end
