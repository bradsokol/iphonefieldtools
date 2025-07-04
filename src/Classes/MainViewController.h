// Copyright 2009-2025 Brad Sokol
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

#import "FlipsideViewController.h"
#import "SubjectDistanceSliderPolicy.h"

@class DistanceFormatter;
@class ResultView;

@protocol AnalyticsPolicy;

@interface MainViewController : UIViewController <FlipsideViewControllerDelegate, UIActionSheetDelegate>
{
	IBOutlet UIButton *cameraAndLensDescription;
	IBOutlet UIButton *infoButton;

	IBOutlet UILabel* apertureLabel;
	IBOutlet UISlider* apertureSlider;
	IBOutlet UILabel* apertureText;
	IBOutlet UILabel* apertureMinimum;
	IBOutlet UILabel* apertureMaximum;
	
	IBOutlet UISegmentedControl* distanceType;
	
	IBOutlet UISlider* focalLengthSlider;
	IBOutlet UILabel* focalLengthText;
	IBOutlet UILabel* focalLengthMinimum;
	IBOutlet UILabel* focalLengthMaximum;
    __weak IBOutlet NSLayoutConstraint*apertureToFocalLengthConstraint;
	
	IBOutlet UISlider* subjectDistanceSlider;
	IBOutlet UILabel* subjectDistanceLabel;
	IBOutlet UILabel* subjectDistanceText;
	IBOutlet UILabel* subjectDistanceMinimum;
	IBOutlet UILabel* subjectDistanceMaximum;
    IBOutlet UIButton* subjectDistanceRangeText;
	
	IBOutlet ResultView* resultView;
	
	DistanceFormatter* distanceFormatter;
	NSInteger apertureIndex;
	float circleOfLeastConfusion;
	float focalLength;
	float subjectDistance;
	
	NSMutableArray* apertures;
	
	SubjectDistanceSliderPolicy* subjectDistanceSliderPolicy;
}

- (IBAction)subjectDistanceRangeTextWasTouched:(id)sender;

- (IBAction)apertureDidChange:(id)sender;
- (IBAction)distanceTypeDidChange:(id)sender;
- (IBAction)focalLengthDidChange:(id)sender;
- (IBAction)subjectDistanceDidChange:(id)sender;

- (float)aperture;

- (IBAction)toggleView;

@property (nonatomic, strong) UIButton* cameraAndLensDescription;
@property (nonatomic, strong) UIButton *infoButton;

@property(assign) float circleOfLeastConfusion;
@property(assign) float focalLength;
@property(assign) float subjectDistance;

@property(nonatomic, strong) id<AnalyticsPolicy> analyticsPolicy;

@end
