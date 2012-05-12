// Copyright 2011 Brad Sokol
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

//
//  OBSliderWithNotificationView.m
//  FieldTools
//
//  Created by Brad Sokol on 11-08-07.
//  Copyright 2011 by Brad Sokol. All rights reserved.
//

#import "OBSliderWithNotificationView.h"

#import "GCDiscreetNotificationView.h"

@implementation OBSliderWithNotificationView

@synthesize notificationView;

- (id)init
{
    self = [super init];
    
    return self;
}

- (void)awakeFromNib 
{
    [super awakeFromNib];
    
    notificationView = [[GCDiscreetNotificationView alloc] initWithText:@"" 
                                                           showActivity:NO
                                                     inPresentationMode:GCDiscreetNotificationViewPresentationModeTop
                                                                 inView:self.superview];
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    BOOL beginTracking = [super beginTrackingWithTouch:touch withEvent:event];
    if (beginTracking)
    {
        [notificationView setTextLabel:NSLocalizedString(@"SCRUBBING_HIGH", "Hi-Speed Scrubbing") animated:YES];
        [notificationView setSecondaryTextLabel:NSLocalizedString(@"SCRUBBING_TIP", "SCRUBBING_TIP")];
        [notificationView show:YES];
    }
    
    return beginTracking;
}

- (BOOL) continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    BOOL superTracking = [super continueTrackingWithTouch:touch withEvent:event];
    if (superTracking)
    {
        
    }
    
    return superTracking;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    [super endTrackingWithTouch:touch withEvent:event];
    if (self.tracking)
    {
        [notificationView hide:YES];
    }
}

- (void)scrubbingZoneDidChangeFrom:(NSUInteger)oldZone to:(NSUInteger)newZone
{
    switch (newZone)
    {
        case 1:
            [notificationView setTextLabel:NSLocalizedString(@"SCRUBBING_HIGH", "Hi-Speed Scrubbing") animated:NO];
            break;
        case 2:
            [notificationView setTextLabel:NSLocalizedString(@"SCRUBBING_HALF", "Half Speed Scrubbing") animated:NO];
            break;
        case 3:
            [notificationView setTextLabel:NSLocalizedString(@"SCRUBBING_QUARTER", "Quarter Speed Scrubbing") animated:NO];
            break;
        case 4:
            [notificationView setTextLabel:NSLocalizedString(@"SCRUBBING_FINE", "Fine Scrubbing") animated:NO];
            break;
            
        default:
            break;
    }
}

- (void)dealloc
{
    [notificationView release], notificationView = nil;
    
    [super dealloc];
}

@end
