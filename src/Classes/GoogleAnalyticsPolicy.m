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

@implementation GoogleAnalyticsPolicy

@synthesize debug;

- (id)init
{
    [self setDebug:NO];
    
    [[GANTracker sharedTracker] setAnonymizeIp:YES];
    [[GANTracker sharedTracker] startTrackerWithAccountID:kGANAccountId
                                           dispatchPeriod:kGANDispatchPeriodSec
                                                 delegate:nil];
    
    return self;
}

- (void)setDebug:(BOOL)value
{
    debug = value;
    
    [[GANTracker sharedTracker] setDryRun:[self debug]];
}

// Track display of a view. Returns YES on success or NO on error.
// set to the specific error, or nil).
- (BOOL)trackView:(NSString *)viewName
{
    NSLog(@"Google Anlytics: Tracking view %@", viewName);
    
    NSError *error;
    BOOL success = [[GANTracker sharedTracker] trackPageview:viewName
                                                   withError:&error];
    if (!success)
    {
        NSLog(@"Error recording analytics page view: %@", error);
    }
    
    return success;
}

// Track an event. The category and action are required. The label and
// value are optional (specify nil for no label and -1 or any negative integer
// for no value). Returns YES on success or NO on error.
- (BOOL)trackEvent:(NSString *)category
            action:(NSString *)action
             label:(NSString *)label
             value:(NSInteger)value
{
    NSLog(@"Google Analytics: Tracking event: (%@, %@, %@, %d)",
          category, action, label, value);
    
    NSError *error;
    BOOL success = [[GANTracker sharedTracker] trackEvent:category
                                                   action:action
                                                    label:label
                                                    value:value
                                                withError:&error];
    
    if (!success)
    {
        NSLog(@"Error recording analytics page view: %@", error);
    }
    
    return success;
}

@end
