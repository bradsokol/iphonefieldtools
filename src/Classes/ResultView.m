// Copyright 2009 Brad Sokol
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
//  ResultView.m
//  FieldTools
//
//  Created by Brad on 2009/03/19.
//  Copyright 2009 Brad Sokol. All rights reserved.
//

#import "ResultView.h"

const static float CORNER_RADIUS = 8.0;

@implementation ResultView

- (id)initWithFrame:(CGRect)frame 
{
    if (nil == [super initWithFrame:frame]) 
	{
		return nil;
    }
	
    return self;
}

- (void)drawRect:(CGRect)rect 
{
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetRGBFillColor(context, 255.0, 255.0, 255.0, 1.0);
	CGContextSetRGBStrokeColor(context, 255.0, 255.0, 255.0, 1.0);
	
	CGContextBeginPath(context);
	CGContextAddArc(context, CORNER_RADIUS, CORNER_RADIUS, CORNER_RADIUS, M_PI, 1.5 * M_PI, 0);
	CGContextAddLineToPoint(context, rect.size.width - CORNER_RADIUS, 0.0);
	CGContextAddArc(context, rect.size.width - CORNER_RADIUS, CORNER_RADIUS, CORNER_RADIUS, 1.5 * M_PI, 0.0, 0);
	CGContextAddLineToPoint(context, rect.size.width, rect.size.height - CORNER_RADIUS);
	CGContextAddArc(context, rect.size.width - CORNER_RADIUS, rect.size.height - CORNER_RADIUS, CORNER_RADIUS, 0.0, 0.5 * M_PI, 0);
	CGContextAddLineToPoint(context, CORNER_RADIUS, rect.size.height);
	CGContextAddArc(context, CORNER_RADIUS, rect.size.height - CORNER_RADIUS, CORNER_RADIUS, 0.5 * M_PI, M_PI, 0);
	CGContextClosePath(context);
	CGContextFillPath(context);
}

- (void)dealloc 
{
    [super dealloc];
}

@end
