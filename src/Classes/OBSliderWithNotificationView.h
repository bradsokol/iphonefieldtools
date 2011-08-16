//
//  OBSliderWithNotificationView.h
//  FieldTools
//
//  Created by Brad Sokol on 11-08-07.
//  Copyright 2011 Cubic Apps. All rights reserved.
//

#import "OBSlider.h"

@class GCDiscreetNotificationView;

@interface OBSliderWithNotificationView : OBSlider

@property (nonatomic, retain, readonly) GCDiscreetNotificationView *notificationView;

@end
