/**
 * Copyright (c) 2015-present, Parse, LLC.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import <Foundation/Foundation.h>

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIWebView *webView;

/* Touch handler for the button */
-(IBAction)broadcastPushNotification:(id)sender;
@property (strong, nonatomic) IBOutlet UISegmentedControl *genderControl;
@property (strong, nonatomic) IBOutlet UISlider *ageControl;

@property (strong, nonatomic) IBOutlet UILabel *ageLabel;
- (IBAction)updateInstallation:(id)sender;
- (IBAction)updateAgeLabel:(id)sender;
@end
