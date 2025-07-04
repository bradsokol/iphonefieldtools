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
//  CustomCoCViewController.h
//  FieldTools
//
//  Created by Brad on 2009/10/19.
//  Copyright 2009-2025 Brad Sokol. 
//

#import <UIKit/UIKit.h>

#define CUSTOM_COC_KEY	@"Custom"

@class CustomCoCViewTableDataSource;
@class FTCamera;

@interface CustomCoCViewController : UITableViewController <UITableViewDelegate, UITextFieldDelegate>
{
	IBOutlet UITableViewCell* cocValueCell;
	IBOutlet UITextField* cocValueField;
	IBOutlet UILabel* cocValueLabel;

	CustomCoCViewTableDataSource* tableViewDataSource;
	UIBarButtonItem* saveButton;
	
	NSNumberFormatter* numberFormatter;
	
	FTCamera* camera;

	float coc;
}

// The designated initializer.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil forCamera:(FTCamera*)camera;

@property(nonatomic, strong) CustomCoCViewTableDataSource* tableViewDataSource;
@property(nonatomic, strong, readonly) UITableViewCell* cocValueCell;
@property(nonatomic, strong, readonly) UITextField* cocValueField;
@property(nonatomic, strong, readonly) UILabel* cocValueLabel;

@end
