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
//  MainViewController.h
//  FieldTools
//
//  Created by Brad on 2008/11/29.
//

#import <UIKit/UIKit.h>

@class DistanceFormatter;
@class ResultView;

@interface MainViewController : UIViewController 
{
	IBOutlet UISlider* apertureSlider;
	IBOutlet UILabel* apertureText;
	IBOutlet UISegmentedControl* distanceType;
	IBOutlet UISlider* focalLengthSlider;
	IBOutlet UILabel* focalLengthText;
	IBOutlet UISlider* subjectDistanceSlider;
	IBOutlet UILabel* subjectDistanceLabel;
	IBOutlet UILabel* subjectDistanceText;
	IBOutlet UILabel* subjectDistanceMinimum;
	IBOutlet UILabel* subjectDistanceMaximum;
	IBOutlet ResultView* resultView;
	
	DistanceFormatter* distanceFormatter;
	int apertureIndex;
	float circleOfLeastConfusion;
	float focalLength;
	float subjectDistance;
	
	NSMutableArray* apertures;
}

- (void)apertureDidChange:(id)sender;
- (void)distanceTypeDidChange:(id)sender;
- (void)focalLengthDidChange:(id)sender;
- (void)subjectDistanceDidChange:(id)sender;

- (float)aperture;

@property(assign) float circleOfLeastConfusion;
@property(assign) float focalLength;
@property(assign) float subjectDistance;

@end
