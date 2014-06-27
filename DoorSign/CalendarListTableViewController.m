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

@interface CalendarListTableViewController ()

@property (nonatomic) EKEventStore *eventStore;
@property (nonatomic) NSArray *calendars;

@end

@implementation CalendarListTableViewController

- (void)viewWillAppear:(BOOL)animated {
    self.eventStore = [[EKEventStore alloc] init];
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(refresh)
                                                 name:EKEventStoreChangedNotification
                                               object:self.eventStore];
    [self refresh];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EKEventStoreChangedNotification object:self.eventStore];
    self.eventStore = nil;
}

#pragma mark - Update UI

- (void)refresh
{
    NSArray *calendars = [self.eventStore calendarsForEntityType:EKEntityTypeEvent];
    self.calendars = [calendars sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [((EKCalendar *)obj1).title compare:((EKCalendar *)obj2).title options:NSNumericSearch];
    }];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.calendars.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"showRoomSegue"]) {
        TodayViewController *vc = segue.destinationViewController;
        NSIndexPath *selected = [self.tableView indexPathForSelectedRow];
        vc.calendar = [[DoorSignCalendar alloc] initWithCalendar:self.calendars[selected.row]];
        
    }
}
@end
