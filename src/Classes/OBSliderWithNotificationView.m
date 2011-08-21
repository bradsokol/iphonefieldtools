//
//  OBSliderWithNotificationView.m
//  FieldTools
//
//  Created by Brad Sokol on 11-08-07.
//  Copyright 2011 Cubic Apps. All rights reserved.
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
