// Copyright 2012 Brad Sokol
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

//
//  GoogleAnalyticsPolicy.m
//  FieldTools
//
//  Created by Brad on 2012-10-14.
//
//

#import "GoogleAnalyticsPolicy.h"

#import "GoogleAnalytics.h"

@interface GoogleAnalyticsPolicy ()
@property id<GAITracker> tracker;
@end

@implementation GoogleAnalyticsPolicy

@synthesize debug;

- (id)init
{
    [self setDebug:NO];

    self.tracker = [[GAI sharedInstance] trackerWithTrackingId:kGANAccountId];
    [self.tracker set:kGAIAnonymizeIp value:@"1"];
    [GAI sharedInstance].dispatchInterval = kGANDispatchPeriodSec;

    return self;
}

- (void)setDebug:(BOOL)value
{
    debug = value;
    [GAI sharedInstance].dryRun = [self debug];
}

// Track display of a view. Returns YES on success or NO on error.
// set to the specific error, or nil).
- (BOOL)trackView:(NSString *)viewName
{
    DLog(@"Google Anlytics: Tracking view %@", viewName);

    [self.tracker set:kGAIScreenName value:viewName];
    [self.tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    return true;
}

// Track an event. The category and action are required. The label and
// value are optional (specify nil for no label and -1 or any negative integer
// for no value). Returns YES on success or NO on error.
- (BOOL)trackEvent:(NSString *)category
            action:(NSString *)action
             label:(NSString *)label
             value:(NSInteger)value
{
    DLog(@"Google Analytics: Tracking event: (%@, %@, %@, %ld)",
          category, action, label, (long)value);

    [self.tracker send:[[GAIDictionaryBuilder createEventWithCategory:category
                                                               action:action
                                                                label:label
                                                                value:[NSNumber numberWithLong:value]] build]];

    return true;
}

@end
