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
    NSDateComponents * tomorrowComponents = [[NSDateComponents alloc] init];
    tomorrowComponents.day = 1;
    NSDate *tomorrow = [calendar dateByAddingComponents:tomorrowComponents toDate:[NSDate date] options:0];

    tomorrow = [calendar dateFromComponents:[calendar components: (NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:tomorrow]];

    
    
    NSPredicate *predicated = [self.store predicateForEventsWithStartDate:[NSDate date] endDate:tomorrow calendars:@[self.calendar]];
    
    NSArray *events = [self.store eventsMatchingPredicate:predicated];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateStyle = NSDateFormatterMediumStyle;
    df.timeStyle = NSDateFormatterShortStyle;
    
    for(EKEvent *item in events) {
        NSLog(@"Event: %@ at %@ -> %@", item.title, [df stringFromDate:item.startDate], [df stringFromDate:item.endDate]);
    }
    return events;
    
}

- (EKEvent*)addEvent:(NSString*)title startTime:(NSDate*)startTime endTime:(NSDate*)endTime {
    _store =[[EKEventStore alloc] init];
    __block NSString *savedEventId =[[NSString alloc] init];

    EKEvent *event = [EKEvent eventWithEventStore:_store];
    event.title = title;
    event.startDate = startTime; //today
    event.endDate = endTime;  //set 1 hour meeting
    [event setCalendar:[_store defaultCalendarForNewEvents]];
    NSError *err = nil;
    if(![_store saveEvent:event span:EKSpanThisEvent commit:YES error:&err]) {
        NSLog(@"Unable to save event! %@", err);
        [[[UIAlertView alloc] initWithTitle:err.localizedDescription message:err.localizedRecoverySuggestion delegate:nil cancelButtonTitle:@"Abandon all hope" otherButtonTitles:nil] show];
    }
    savedEventId = event.eventIdentifier;  //this is so you can access this event later
    return event;
}

#pragma mark - Calendar API

@end
