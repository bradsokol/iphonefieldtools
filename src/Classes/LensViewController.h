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
//  LensViewController.h
//  FieldTools
//
//  Created by Brad on 2009/09/28.
//  Copyright 2009 Brad Sokol. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Lens;
@class LensViewTableDataSource;

@interface LensViewController : UITableViewController <UITableViewDelegate, UITextFieldDelegate>
{
	IBOutlet UITableViewCell* lensNameCell;
	IBOutlet UITextField* lensNameField;
	IBOutlet UILabel* lensNameLabel;

	IBOutlet UITableViewCell* minimumFocalLengthCell;
	IBOutlet UITextField* minimumFocalLengthField;
	IBOutlet UILabel* minimumFocalLengthLabel;
	
	IBOutlet UITableViewCell* maximumFocalLengthCell;
	IBOutlet UITextField* maximumFocalLengthField;
	IBOutlet UILabel* maximumFocalLengthLabel;
	
	IBOutlet UITableViewCell* minimumApertureCell;
	IBOutlet UITextField* minimumApertureField;
	IBOutlet UILabel* minimumApertureLabel;
	
	IBOutlet UITableViewCell* maximumApertureCell;
	IBOutlet UITextField* maximumApertureField;
	IBOutlet UILabel* maximumApertureLabel;
	
	LensViewTableDataSource* tableViewDataSource;
	Lens* lens;
	Lens* lensWorking;
	bool lensIsZoom;

	UIBarButtonItem* saveButton;
	
	NSNumberFormatter* numberFormatter;
}

// The designated initializer
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil forLens:(Lens*)lens;

@property(nonatomic, retain) LensViewTableDataSource* tableViewDataSource;

@property(nonatomic, retain, readonly) UITableViewCell* lensNameCell;
@property(nonatomic, retain, readonly) UITextField* lensNameField;
@property(nonatomic, retain, readonly) UILabel* lensNameLabel;

@property(nonatomic, retain, readonly) UITableViewCell* minimumApertureCell;
@property(nonatomic, retain, readonly) UITextField* minimumApertureField;
@property(nonatomic, retain, readonly) UILabel* minimumApertureLabel;

@property(nonatomic, retain, readonly) UITableViewCell* maximumApertureCell;
@property(nonatomic, retain, readonly) UITextField* maximumApertureField;
@property(nonatomic, retain, readonly) UILabel* maximumApertureLabel;

@property(nonatomic, retain, readonly) UITableViewCell* minimumFocalLengthCell;
@property(nonatomic, retain, readonly) UITextField* minimumFocalLengthField;
@property(nonatomic, retain, readonly) UILabel* minimumFocalLengthLabel;

@property(nonatomic, retain, readonly) UITableViewCell* maximumFocalLengthCell;
@property(nonatomic, retain, readonly) UITextField* maximumFocalLengthField;
@property(nonatomic, retain, readonly) UILabel* maximumFocalLengthLabel;

@end
