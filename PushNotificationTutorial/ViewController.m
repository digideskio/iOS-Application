/**
 * Copyright (c) 2015-present, Parse, LLC.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import "ViewController.h"
#import <Parse/Parse.h>

@implementation ViewController
@synthesize webView;

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:NSLocalizedString(@"Parse Push Notifications", @"Parse Push Notifications")];
    NSString *urlString = @"http://harkerdev.github.io/bellschedule/";
    
    webView.scalesPageToFit = YES;
    webView.autoresizesSubviews = YES;
    webView.autoresizingMask=(UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if ([data length] > 0 && error == nil) [webView loadRequest:request];
         else if (error != nil) NSLog(@"Error: %@", error);
     }];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - UIViewController

/* Touch handler for the button */
- (IBAction)broadcastPushNotification:(id)sender  {
    [PFPush sendPushMessageToChannelInBackground:@"global" withMessage:@"Hello World!" block:^(BOOL succeeded, NSError *error) {
        if (error) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Send Push Failed"
                                                                                     message:@"Check the console for more information."
                                                                              preferredStyle:UIAlertControllerStyleAlert];
            
            [alertController addAction:[UIAlertAction actionWithTitle:@"OK"
                                                                style:UIAlertActionStyleCancel
                                                              handler:nil]];
            
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }];
}

- (IBAction)updateInstallation:(id)sender {
    NSString *gender = @"male";
    if (self.genderControl.selectedSegmentIndex == 1) {
        gender = @"female";
    }

    NSNumber *age = @((int)self.ageControl.value);
    [PFInstallation currentInstallation][@"age"] = age;
    [PFInstallation currentInstallation][@"gender"] = gender;
    [[PFInstallation currentInstallation] saveInBackground];
}

- (IBAction)updateAgeLabel:(id)sender {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterNoStyle;
    self.ageLabel.text = [formatter stringFromNumber:[NSNumber numberWithInt:(int)self.ageControl.value]];
}

- (void)loadInstallData {
    NSNumber *age = [PFInstallation currentInstallation][@"age"];
    NSString *gender = [PFInstallation currentInstallation][@"gender"];

    // Handle saved age, or populate default age.
    if (!age) {
        age = @(35);
        [PFInstallation currentInstallation][@"age"] = age;
    }
    self.ageLabel.text = [NSString stringWithFormat:@"%@", age];
    self.ageControl.value = [age floatValue];
    
    // Handle saved gender, or populate default gender.
    if ([gender isEqualToString:@"male"]) {
        self.genderControl.selectedSegmentIndex = 0;
    } else if ([gender isEqualToString:@"female"]) {
        self.genderControl.selectedSegmentIndex = 1;
    } else {
        self.genderControl.selectedSegmentIndex = 0;
        [PFInstallation currentInstallation][@"gender"] = @"male";
    }
    
    [[PFInstallation currentInstallation] saveInBackground];
}

- (void)viewDidLayoutSubviews {
    webView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}

@end
