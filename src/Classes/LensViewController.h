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

#import "TableViewControllerWithAnalytics.h"

@class FTLens;
@class LensViewTableDataSource;

@interface LensViewController : TableViewControllerWithAnalytics <UITableViewDelegate, UITextFieldDelegate>
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
	FTLens* lens;
	bool lensIsZoom;

	UIBarButtonItem* saveButton;
	
	NSNumberFormatter* numberFormatter;
	
	bool newLens;
}

// The designated initializer
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil forLens:(FTLens*)lens;

@property(nonatomic, strong) LensViewTableDataSource* tableViewDataSource;

@property(nonatomic, strong, readonly) UITableViewCell* lensNameCell;
@property(nonatomic, strong, readonly) UITextField* lensNameField;
@property(nonatomic, strong, readonly) UILabel* lensNameLabel;

@property(nonatomic, strong, readonly) UITableViewCell* minimumApertureCell;
@property(nonatomic, strong, readonly) UITextField* minimumApertureField;
@property(nonatomic, strong, readonly) UILabel* minimumApertureLabel;

@property(nonatomic, strong, readonly) UITableViewCell* maximumApertureCell;
@property(nonatomic, strong, readonly) UITextField* maximumApertureField;
@property(nonatomic, strong, readonly) UILabel* maximumApertureLabel;

@property(nonatomic, strong, readonly) UITableViewCell* minimumFocalLengthCell;
@property(nonatomic, strong, readonly) UITextField* minimumFocalLengthField;
@property(nonatomic, strong, readonly) UILabel* minimumFocalLengthLabel;

@property(nonatomic, strong, readonly) UITableViewCell* maximumFocalLengthCell;
@property(nonatomic, strong, readonly) UITextField* maximumFocalLengthField;
@property(nonatomic, strong, readonly) UILabel* maximumFocalLengthLabel;

@end
