//
//  CalendarListTableViewController.m
//  DoorSign
//
//  Created by Patrick Quinn-Graham on 26/06/2014.
//  Copyright (c) 2014 Patrick Quinn-Graham. All rights reserved.
//

#import "CalendarListTableViewController.h"
#import <EventKit/EventKit.h>
#import "DoorSignCalendar.h"
#import "TodayViewController.h"
#import "AppDelegate.h"

@interface CalendarListTableViewController ()

@property (nonatomic) NSArray *calendars;

@end

@implementation CalendarListTableViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(refresh)
                                                 name:EKEventStoreChangedNotification
                                               object:[AppDelegate eventStore]];
    [self refresh];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:EKEventStoreChangedNotification
                                                  object:[AppDelegate eventStore]];
}

#pragma mark - Update UI

- (void)refresh {
    EKEventStore *store = [AppDelegate eventStore];
    
    NSPredicate *onlyGoodCalendars = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return ((EKCalendar*)evaluatedObject).type != EKCalendarTypeBirthday;
    }];
    
    NSArray *calendars = [[store calendarsForEntityType:EKEntityTypeEvent] filteredArrayUsingPredicate:onlyGoodCalendars];
    
    self.calendars = [calendars sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [((EKCalendar *)obj1).title compare:((EKCalendar *)obj2).title options:NSNumericSearch];
    }];
    
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.calendars.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"calendarNameCell"];
    EKCalendar *calendar = self.calendars[indexPath.row];
    cell.textLabel.text = calendar.title;
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.backgroundView.backgroundColor = [UIColor clearColor];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.highlightedTextColor = [UIColor darkGrayColor];
    return cell;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"showRoomSegue"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        TodayViewController *vc = segue.destinationViewController;
        vc.calendar = [[DoorSignCalendar alloc] initWithCalendar:self.calendars[indexPath.row]];
    }
}

@end
