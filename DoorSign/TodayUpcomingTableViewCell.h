//
//  TodayUpcomingTableViewCell.h
//  DoorSign
//
//  Created by Patrick Quinn-Graham on 26/06/2014.
//  Copyright (c) 2014 Patrick Quinn-Graham. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>

@interface TodayUpcomingTableViewCell : UITableViewCell

@property (nonatomic) EKEvent *event;

- (void)configure;

@end
