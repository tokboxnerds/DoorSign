//
//  TodayViewController.m
//  DoorSign
//
//  Created by Patrick Quinn-Graham on 26/06/2014.
//  Copyright (c) 2014 Patrick Quinn-Graham. All rights reserved.
//

#import "TodayViewController.h"
#import "TodayUpcomingTableViewController.h"
#import "AddEventControllerTableViewController.h"

#import "AppDelegate.h"
#import "DoorSignCalendar.h"

@interface TodayViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *roomLogo;
@property (weak, nonatomic) IBOutlet UIButton *roomNameButton;

@property (weak, nonatomic) IBOutlet UILabel *roomStatus;

@property (weak, nonatomic) IBOutlet UILabel *currentEventTitle;
@property (weak, nonatomic) IBOutlet UILabel *currentEventMoreInfo;
@property (weak, nonatomic) IBOutlet UILabel *currentEventTime;

@property (nonatomic) NSTimer *timer;

@end

@implementation TodayViewController

- (IBAction)changeRoom:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated {
  
  
  UIImage *image = [UIImage imageNamed:self.calendar.title];
  if(!image) {
    image = [UIImage imageNamed:@"TokRoom"];
  }
  
  self.roomLogo.image = image;
  
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refresh)
                                                 name:EKEventStoreChangedNotification
                                               object:[AppDelegate eventStore]];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:60.0
                                                  target:self
                                                selector:@selector(refresh)
                                                userInfo:nil
                                                 repeats:YES];
    [self refresh];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:EKEventStoreChangedNotification
                                                  object:[AppDelegate eventStore]];
    [self.timer invalidate];
    self.timer = nil;
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
      
        NSArray *upcomingEvents = [self.calendar todaysEvents];
      
        if(upcomingEvents.count == 0) {
          self.roomStatus.text = @"Available";
          self.currentEventTitle.text = @"";
        } else {
          EKEvent *nextEvent = upcomingEvents.firstObject;
          
          NSTimeInterval interval = [nextEvent.startDate timeIntervalSinceNow] / 60;
          
          self.roomStatus.text = @"Available";
          
          if(interval > 60) {
            self.currentEventTitle.text = @"";

          } else if(interval > 55) {
            self.currentEventTitle.text = @"For an hour";
            
          } else if(interval > 50) {
            self.currentEventTitle.text = @"For 50 minutes";
            
          } else if(interval > 45) {
            self.currentEventTitle.text = @"For 45 minutes";
            
          } else if(interval > 40) {
            self.currentEventTitle.text = @"For 40 minutes";
            
          } else if(interval > 35) {
            self.currentEventTitle.text = @"For 35 minutes";
            
          } else if(interval > 30) {
            self.currentEventTitle.text = @"For 30 minutes";
            
          } else if(interval > 25) {
            self.currentEventTitle.text = @"For 25 minutes";
            
          } else if(interval > 20) {
            self.currentEventTitle.text = @"For 20 minutes";
            
          } else if(interval > 15) {
            self.currentEventTitle.text = @"For 15 minutes";
            
          } else if(interval > 10) {
            self.currentEventTitle.text = @"For ten minutes";
            
          } else if(interval > 5) {
            self.currentEventTitle.text = @"For five minutes";
            
          } else {
            self.roomStatus.text = @"In use";
            self.currentEventTitle.text = @"In five minutes";
            
          }
          
          self.currentEventMoreInfo.text = nextEvent.title;
          self.currentEventTime.text = [NSString stringWithFormat:@"%@ at %@", nextEvent.title, [AppDelegate timeForDate:nextEvent.startDate]];
        }
      
    } else if(currentEvents.count > 1) {
        self.roomStatus.text = @"Oh no!";
        self.currentEventTitle.text = @"There are conflicting events in this room.";
    } else {
        self.roomStatus.text = @"In use";
        EKEvent *event = currentEvents.firstObject;
        
        NSMutableArray *attendeeNames = [NSMutableArray arrayWithCapacity:event.attendees.count];
        for(EKParticipant *attendee in event.attendees) {
            if(attendee.name != self.calendar.title) {
                [attendeeNames addObject:attendee.name];
            }
        }
        
        self.currentEventTitle.text = event.title;
        self.currentEventMoreInfo.text = [attendeeNames componentsJoinedByString:@", "];
        self.currentEventTime.text = [NSString stringWithFormat:@"Ends at %@",
                                      [AppDelegate timeForDate:event.endDate]];
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //if([segue.identifier isEqualToString:@"todayUpcomingEmbed"]) {
    //    ((TodayUpcomingTableViewController *)segue.destinationViewController).calendar = self.calendar;
    //}
    if([segue.identifier isEqualToString:@"addEventSegue"]) {
        UINavigationController *root = segue.destinationViewController;
        ((AddEventControllerTableViewController *)root.topViewController).calendar = self.calendar;
    }
}

@end
