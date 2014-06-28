//
//  StartupViewController.m
//  DoorSign
//
//  Created by Patrick Quinn-Graham on 27/06/2014.
//  Copyright (c) 2014 Patrick Quinn-Graham. All rights reserved.
//

#import "StartupViewController.h"
#import "AppDelegate.h"

@interface StartupViewController ()

@end

@implementation StartupViewController

-(BOOL)prefersStatusBarHidden {
    return YES;
}

-(void)viewDidAppear:(BOOL)animated {
    [[AppDelegate eventStore] requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        if(!granted) {
            [[[UIAlertView alloc] initWithTitle:@"Access to calendar denied" message:@"Access to the calendar is required for DoorSign to function. You will need to enable it in Settings to continue." delegate:nil cancelButtonTitle:@"Abandon all hope" otherButtonTitles:nil] show];
        } else if(error) {
            [[[UIAlertView alloc] initWithTitle:error.localizedFailureReason message:error.localizedRecoverySuggestion delegate:nil cancelButtonTitle:@"Abandon all hope" otherButtonTitles:nil] show];
        } else {
            UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"roomPicker"];
            [self presentViewController:vc animated:NO completion:^{
                [self removeFromParentViewController];
            }];
        }
    }];
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
