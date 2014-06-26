//
//  DoorSignCalendar.h
//  DoorSign
//
//  Created by Patrick Quinn-Graham on 26/06/2014.
//  Copyright (c) 2014 Patrick Quinn-Graham. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>


@interface DoorSignCalendar : NSObject

@property (readonly) NSString *title;

- (instancetype)initWithCalendar:(EKCalendar*)calendar;
- (NSArray*)currentEvents;
- (NSArray*)todaysEvents;

@end
