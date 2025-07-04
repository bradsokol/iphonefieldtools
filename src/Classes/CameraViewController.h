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
//  CameraViewController.h
//  FieldTools
//
//  Created by Brad on 2009/04/14.
//  Copyright 2009-2025 Brad Sokol. 
//

#import <UIKit/UIKit.h>

@class CameraViewTableDataSource;
@class FTCamera;

@interface CameraViewController : UITableViewController <UIAlertViewDelegate, UITableViewDelegate, UITextFieldDelegate>
{
	IBOutlet UITableViewCell* cameraNameCell;
	IBOutlet UITextField* cameraNameField;
	IBOutlet UILabel* cameraNameLabel;

	CameraViewTableDataSource* tableViewDataSource;
	UIBarButtonItem* saveButton;
	FTCamera* camera;
	
	bool newCamera;
}

// The designated initializer.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil forCamera:(FTCamera*)camera;

@property(nonatomic, strong) CameraViewTableDataSource* tableViewDataSource;
@property(nonatomic, strong, readonly) UITableViewCell* cameraNameCell;
@property(nonatomic, strong, readonly) UITextField* cameraNameField;
@property(nonatomic, strong, readonly) UILabel* cameraNameLabel;

@end
