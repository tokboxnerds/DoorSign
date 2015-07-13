//
//  CalendarManager.m
//  DoorSigns2
//
//  Created by Patrick Quinn-Graham on 18/5/2015.
//  Copyright (c) 2015 Facebook. All rights reserved.
//

#import "CalendarManager.h"

#import "AppDelegate.h"

#import "RCTBridge.h"
#import "RCTEventDispatcher.h"

NSDictionary *PQGMakeError(NSString *message, id toStringify, NSDictionary *extraData)
{
  if (toStringify) {
    message = [NSString stringWithFormat:@"%@%@", message, toStringify];
  }
  NSMutableDictionary *error = [@{@"message": message} mutableCopy];
  if (extraData) {
    [error addEntriesFromDictionary:extraData];
  }
  return error;
}

@implementation NSArray (PQG_Map)

- (NSArray*)pqg_map:(id (^)(id obj, NSUInteger idx))iterator {
  NSMutableArray *returnableEvents = [NSMutableArray arrayWithCapacity:self.count];
  [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    id newObj = iterator(obj, idx);
    [returnableEvents addObject:newObj];
  }];
//  NSLog(@"pqg_map is going to return %@", returnableEvents);
  return returnableEvents;
}

@end


@implementation CalendarManager

@synthesize bridge = _bridge;


RCT_EXPORT_MODULE()

#pragma mark - Lifecycle

- (instancetype)init
{
  if ((self = [super init])) {
    [[NSNotificationCenter defaultCenter] addObserverForName:EKEventStoreChangedNotification
                                                      object:[AppDelegate eventStore]
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification *note) {
      [self.bridge.eventDispatcher sendDeviceEventWithName:@"eventStoreChanged"
                                                      body:@{}];
      
    }];
  }
  return self;
}

- (dispatch_queue_t)methodQueue
{
  return dispatch_get_main_queue(); //dispatch_queue_create("com.tokbox.DoorSign2.CalendarManager", DISPATCH_QUEUE_SERIAL);
}

#pragma mark - Public API

RCT_EXPORT_METHOD(bundleInfo:(RCTResponseSenderBlock)callback)
{
  NSDictionary *foo = [[NSBundle mainBundle] infoDictionary];
  
  NSMutableDictionary *bundleDictionary = [NSMutableDictionary dictionary];
  
  [[foo allKeys] enumerateObjectsUsingBlock:^(id key, NSUInteger idx, BOOL *stop) {
    id value = foo[key];
    if (![value isKindOfClass:[NSURL class]]) {
      bundleDictionary[key] = value;
    }
  }];
  
  callback(@[bundleDictionary]);
}

RCT_EXPORT_METHOD(requestAccessToCalendarEvents:(RCTResponseSenderBlock)callback)
{
  [[AppDelegate eventStore] requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
    NSDictionary *userInfo;
    if(!granted) {
      userInfo = @{ @"recoverySuggestion": @"Access to the calendar is required for DoorSign to function. You will need to enable it in Settings to continue." };
      NSDictionary *notGrantedError = PQGMakeError(@"Access to calendar denied", nil, userInfo);
      callback(@[notGrantedError]);
      
    } else if(error) {
      userInfo = @{ @"recoverySuggestion": error.localizedRecoverySuggestion };
      NSDictionary *fatalError = PQGMakeError(error.localizedFailureReason, nil, userInfo);
      callback(@[fatalError]);
      
    } else {
      callback(@[]);
    }
  }];
}

RCT_EXPORT_METHOD(calendarNames:(RCTResponseSenderBlock)callback)
{
  EKEventStore *store = [AppDelegate eventStore];

  NSPredicate *onlyGoodCalendars = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
    return ((EKCalendar*)evaluatedObject).type != EKCalendarTypeBirthday;
  }];
  
  NSArray *calendars = [[store calendarsForEntityType:EKEntityTypeEvent] filteredArrayUsingPredicate:onlyGoodCalendars];
  
  calendars = [calendars sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
    return [((EKCalendar *)obj1).title compare:((EKCalendar *)obj2).title options:NSNumericSearch];
  }];
  
  NSArray *calendarNames = [calendars pqg_map:^id(id obj, NSUInteger idx) {
    EKCalendar* calendar = obj;
    return @{
             @"title": calendar.title,
             @"calendarIdentifier": calendar.calendarIdentifier
             };
  }];
  
  callback(@[[NSNull null], calendarNames]);
}

RCT_EXPORT_METHOD(calendarNameForIdentifier:(NSString*)calendarIdentifier callback:(RCTResponseSenderBlock)callback)
{
  NSLog(@"Looking for calendar: %@", calendarIdentifier);
  EKCalendar *calendar = [[AppDelegate eventStore] calendarWithIdentifier:calendarIdentifier];
  if (!calendar) {
    NSLog(@"Calendar %@ not found", calendarIdentifier);
    callback(@[ PQGMakeError(@"Calendar %@ not found", calendarIdentifier, @{}) ]);
  } else {
    NSLog(@"Calendar %@ is called %@", calendarIdentifier, calendar.title);
    callback(@[ [NSNull null], calendar.title ]);
  }
}

RCT_EXPORT_METHOD(currentEventsInCalendar:(NSString*)calendarIdentifier callback:(RCTResponseSenderBlock)callback)
{
  EKCalendar *calendar = [[AppDelegate eventStore] calendarWithIdentifier:calendarIdentifier];
  
  NSLog(@"currentEventsInCalendar: %@ => %@", calendarIdentifier, calendar);
  
  NSArray *currentEvents = [self currentEventsFromCalendar:calendar];

  NSLog(@"&wham, currentEvents = %@", currentEvents);

  
  NSArray *events = [currentEvents pqg_map:^id(id obj, NSUInteger idx) {
    return [self serializeEvent:(EKEvent*)obj];
  }];
  NSLog(@"Attempting to return: %@, %@", NSNull.null, events);
  callback(@[ NSNull.null, events]);
}

RCT_EXPORT_METHOD(todaysUpcomingEventsInCalendar:(NSString*)calendarIdentifier callback:(RCTResponseSenderBlock)callback)
{
  EKCalendar *calendar = [[AppDelegate eventStore] calendarWithIdentifier:calendarIdentifier];

  NSLog(@"&todaysUpcomingEventsInCalendary: calendar = %@", calendar);

  NSArray *events = [[self upcomingEventsTodayInCalendar:calendar] pqg_map:^id(id obj, NSUInteger idx) {
    return [self serializeEvent:(EKEvent*)obj];
  }];
  
  NSLog(@"&todaysUpcomingEventsInCalendary: events = %@", events);
  
  callback(@[ [NSNull null], events]);
}

#pragma mark - EventKit Helpers

- (NSString*)timeForDate:(NSDate*)date {
  static dispatch_once_t onceToken;
  static NSDateFormatter *formatter;
  dispatch_once(&onceToken, ^{
    formatter = [[NSDateFormatter alloc] init];
    formatter.dateStyle = NSDateFormatterNoStyle;
    formatter.timeStyle = NSDateFormatterShortStyle;
  });
  return [formatter stringFromDate:date];
}

- (NSDictionary*)serializeEvent:(EKEvent*)event {
  NSMutableArray *attendeeNames = [NSMutableArray arrayWithCapacity:event.attendees.count];
  for(EKParticipant *attendee in event.attendees) {
    if(![attendee.name isEqualToString:event.calendar.title]) {
      [attendeeNames addObject:attendee.name];
    }
  }
  
  
  
  return @{
           @"title": event.title,
           @"attendeeNames": attendeeNames,
           @"startsAt": @(event.startDate.timeIntervalSince1970 * 1000),
           @"startsAtPretty": [self timeForDate:event.startDate],
           @"endsAt": @(event.endDate.timeIntervalSince1970 * 1000),
           @"endsAtPretty": [self timeForDate:event.endDate]
           };
}

- (NSArray*)currentEventsFromCalendar:(EKCalendar*)calendar {
  NSPredicate *predicate = [[AppDelegate eventStore] predicateForEventsWithStartDate:[NSDate date] endDate:[NSDate date] calendars:@[calendar]];
  NSArray *events = [[[AppDelegate sharedDelegate] eventStore] eventsMatchingPredicate:predicate];
  if (!events) {
    return @[];
  }
  return events;
}

- (NSArray*)upcomingEventsTodayInCalendar:(EKCalendar*)inCalendar {
  EKEventStore *store = [AppDelegate eventStore];
  
  NSCalendar *calendar = [NSCalendar currentCalendar];
  
  NSDateComponents *tomorrowComponents = [[NSDateComponents alloc] init];
  tomorrowComponents.day = 1;
  
  NSDate *tomorrow = [calendar dateByAddingComponents:tomorrowComponents toDate:[NSDate date] options:0];
  tomorrow = [calendar dateFromComponents:[calendar components: (NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:tomorrow]];
  
  NSArray *events = [store eventsMatchingPredicate:[store predicateForEventsWithStartDate:[NSDate date]
                                                                       endDate:tomorrow
                                                                     calendars:@[inCalendar]]];
  
  if (!events) {
    return @[];
  }
  return events;
}

//- (EKEvent*)addEvent:(NSString*)title startTime:(NSDate*)startTime endTime:(NSDate*)endTime toCalendar:(EKCalendar*)calendar {
//  EKEventStore *store = [AppDelegate eventStore];
//  EKEvent *event = [EKEvent eventWithEventStore:store];
//  event.title = title;
//  event.startDate = startTime;
//  event.endDate = endTime;
//  event.calendar = calendar;
//  NSError *err = nil;
//  if(![store saveEvent:event span:EKSpanThisEvent error:&err]) {
//    [[[UIAlertView alloc] initWithTitle:err.localizedDescription message:err.localizedRecoverySuggestion delegate:nil cancelButtonTitle:@"Abandon all hope" otherButtonTitles:nil] show];
//  }
//  return event;
//}

@end
