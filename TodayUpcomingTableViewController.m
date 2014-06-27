//
//  TodayUpcomingTableViewController.m
//  DoorSign
//
//  Created by Patrick Quinn-Graham on 26/06/2014.
//  Copyright (c) 2014 Patrick Quinn-Graham. All rights reserved.
//

#import "TodayUpcomingTableViewController.h"
#import "TodayUpcomingTableViewCell.h"
#import "DoorSignCalendar.h"

@interface TodayUpcomingTableViewController ()

@property (nonatomic) NSArray *events;
@property (nonatomic) EKEventStore *store;
@property (nonatomic) NSTimer *timer;

@end

@implementation TodayUpcomingTableViewController

- (void)viewWillAppear:(BOOL)animated {
    
    self.view.backgroundColor = [UIColor clearColor];
    
    NSLog(@"how about now? %@", self.calendar);
    self.store = [[EKEventStore alloc] init];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:60.0 target:self selector:@selector(refresh) userInfo:nil repeats:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refresh)
                                                 name:EKEventStoreChangedNotification
                                               object:self.store];
    [self refresh];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EKEventStoreChangedNotification object:self.store];
    self.store = nil;
    [self.timer invalidate];
    self.timer = nil;
}

- (void)refresh {
    self.events = [self.calendar todaysEvents];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.events.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TodayUpcomingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"eventCell" forIndexPath:indexPath];
    cell.event = self.events[indexPath.row];
    [cell configure];
    [[cell contentView] setBackgroundColor:[UIColor clearColor]];
    [[cell backgroundView] setBackgroundColor:[UIColor clearColor]];
    [cell setBackgroundColor:[UIColor clearColor]];
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
