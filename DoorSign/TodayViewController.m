//
//  TodayViewController.m
//  DoorSign
//
//  Created by Patrick Quinn-Graham on 26/06/2014.
//  Copyright (c) 2014 Patrick Quinn-Graham. All rights reserved.
//

#import "TodayViewController.h"
#import "TodayUpcomingTableViewController.h"

#import "DoorSignCalendar.h"

@interface TodayViewController ()

@property (weak, nonatomic) IBOutlet UIButton *roomNameButton;

@property (weak, nonatomic) IBOutlet UILabel *currentEventTitle;
@property (weak, nonatomic) IBOutlet UILabel *currentEventMoreInfo;
@property (weak, nonatomic) IBOutlet UILabel *currentEventTime;

@property (nonatomic) EKEventStore *store;
@property (nonatomic) NSTimer *timer;

@end

@implementation TodayViewController

- (IBAction)changeRoom:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.roomNameButton setTitle:self.calendar.title forState:UIControlStateNormal];
    self.store = [[EKEventStore alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refresh)
                                                 name:EKEventStoreChangedNotification
                                               object:self.store];
    [self refresh];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:60.0 target:self selector:@selector(refresh) userInfo:nil repeats:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EKEventStoreChangedNotification object:self.store];
    [self.timer invalidate];
    self.timer = nil;
    self.store = nil;
}

-(BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark - Update UI

- (void)refresh {
    [self refreshCurrentEvent];
}

- (void)refreshCurrentEvent {
    NSArray *currentEvents = [self.calendar currentEvents];
    self.currentEventMoreInfo.text = @"";
    self.currentEventTime.text = @"";
    if(currentEvents.count == 0) {
        self.currentEventTitle.text = @"Available";
    } else if(currentEvents.count > 1) {
        self.currentEventTitle.text = @"Oh no!";
        self.currentEventMoreInfo.text = @"There are conflicting events in this room.";
    } else {
        EKEvent *event = currentEvents[0];
        self.currentEventTitle.text = event.title;
        
        NSMutableArray *attendeeNames = [NSMutableArray arrayWithCapacity:event.attendees.count];
        
        for(EKParticipant *attendee in event.attendees) {
            if(attendee.name != self.calendar.title) {
                [attendeeNames addObject:attendee.name];
            }
        }
        
        self.currentEventMoreInfo.text = [attendeeNames componentsJoinedByString:@", "];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateStyle = NSDateFormatterNoStyle;
        formatter.timeStyle = NSDateFormatterShortStyle;
        self.currentEventTime.text = [NSString stringWithFormat:@"%@-%@",
                                      [formatter stringFromDate:event.startDate],
                                      [formatter stringFromDate:event.endDate]];
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if([segue.identifier isEqualToString:@"todayUpcomingEmbed"]) {
        NSLog(@"prepare for segue... %@", segue);
        TodayUpcomingTableViewController *vc = segue.destinationViewController;
        vc.calendar = self.calendar;
    }
}

@end
