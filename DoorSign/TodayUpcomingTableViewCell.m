//
//  TodayUpcomingTableViewCell.m
//  DoorSign
//
//  Created by Patrick Quinn-Graham on 26/06/2014.
//  Copyright (c) 2014 Patrick Quinn-Graham. All rights reserved.
//

#import "TodayUpcomingTableViewCell.h"

@interface TodayUpcomingTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *startTime;
@property (weak, nonatomic) IBOutlet UILabel *eventTitle;

@end

@implementation TodayUpcomingTableViewCell

- (void)configure {
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    f.dateStyle = NSDateFormatterNoStyle;
    f.timeStyle = NSDateFormatterShortStyle;
    self.startTime.text = [f stringFromDate:self.event.startDate];
    self.eventTitle.text = self.event.title;
}

@end
