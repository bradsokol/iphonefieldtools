//
//  OBSlider.h
//
//  Created by Ole Begemann on 02.01.11.
//  Copyright 2011 Ole Begemann. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface OBSlider : UISlider
{
    float scrubbingSpeed;
    NSArray *scrubbingSpeeds;
    NSArray *scrubbingSpeedChangePositions;
    
    CGPoint beganTrackingLocation;
	
    float realPositionValue;
    
    UIImage* normalThumb;
    UIImage* highlightedThumb;

}

- (void)scrubbingZoneDidChangeFrom:(NSUInteger)oldZone to:(NSUInteger)newZone;

@property (assign, readonly) float scrubbingSpeed;
@property (strong) NSArray *scrubbingSpeeds;
@property (strong) NSArray *scrubbingSpeedChangePositions;

@end
