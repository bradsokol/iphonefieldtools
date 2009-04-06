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
//  ResultView.h
//  FieldTools
//
//  Created by Brad on 2009/03/19.
//  Copyright 2009 Brad Sokol. All rights reserved.
//
// Implements a custom control for displaying one of two types of
// results:
//
//   - two values and the difference
// - a single value
//
// The control is a composite of three UILabels for the two distances and the difference,
// a UITextField for the single value result. A UIImageView is used to display
// an image of a line with arrows at both ends to signfiy the difference between
// two values.
//
// An instance of DistanceFormatter is used to format numbers. The metric or imperial
// units setting is read from user preferences.
//
// Use the setResult:distance method to display a single value. Use setResultsNear:far to
// display near, far and the difference.
//

#import <UIKit/UIKit.h>

@class DistanceFormatter;

@interface ResultView : UIView 
{
	IBOutlet UITextField* largeText;
	IBOutlet UILabel* leftNumber;
	IBOutlet UILabel* rightNumber;
	IBOutlet UILabel* difference;
	IBOutlet UIImageView* distanceArrows;
	
	bool displayRange;
	DistanceFormatter* distanceFormatter;
	bool firstDraw;
	CGFloat farDistance;
	CGFloat nearDistance;
	CGFloat distanceDifference;
}

- (void)setResult:(CGFloat)distance;
- (void)setResultNear:(CGFloat)nearDistance far:(CGFloat)farDistance;

@end
