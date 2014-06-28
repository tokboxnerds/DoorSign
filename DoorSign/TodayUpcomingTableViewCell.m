//
//  TodayUpcomingTableViewCell.m
//  DoorSign
//
//  Created by Patrick Quinn-Graham on 26/06/2014.
//  Copyright (c) 2014 Patrick Quinn-Graham. All rights reserved.
//

#import "TodayUpcomingTableViewCell.h"
#import "AppDelegate.h"

@interface TodayUpcomingTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *startTime;
@property (weak, nonatomic) IBOutlet UILabel *eventTitle;

@end

@implementation TodayUpcomingTableViewCell

- (void)configure {
    self.startTime.text = [AppDelegate timeForDate:self.event.startDate];
    self.eventTitle.text = self.event.title;
}

@end
