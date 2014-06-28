//
//  AddEventControllerTableViewController.m
//  DoorSign
//
//  Created by Chetan Angadi on 6/26/14.
//  Copyright (c) 2014 Patrick Quinn-Graham. All rights reserved.
//

#import "AddEventControllerTableViewController.h"
#import "DoorSignCalendar.h"

@interface AddEventControllerTableViewController ()
@property (weak, nonatomic) IBOutlet UITextField *eventNameField;
@property (weak, nonatomic) IBOutlet UIDatePicker *startDate;
@property (weak, nonatomic) IBOutlet UIDatePicker *endDate;

@end

@implementation AddEventControllerTableViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.eventNameField.text = @"Meeting";
    self.startDate.minimumDate = [NSDate date];
    self.endDate.minimumDate = [NSDate date];
    self.startDate.date = [NSDate date];
    self.endDate.date = [NSDate dateWithTimeIntervalSinceNow:30*60];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.eventNameField becomeFirstResponder];
}

#pragma mark - Actions

- (IBAction)cancelAddEvent:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)addEvent:(id)sender {
    [self.calendar addEvent:self.eventNameField.text startTime:self.startDate.date endTime:self.endDate.date];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)startDateChanged:(id)sender {
    self.endDate.minimumDate = self.startDate.date;
}

- (IBAction)endDateChanged:(id)sender {
    self.startDate.maximumDate = self.endDate.date;
}

@end
