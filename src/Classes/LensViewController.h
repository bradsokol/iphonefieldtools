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

@interface LensViewController : UITableViewController 
{
	LensViewTableDataSource* tableViewDataSource;
	Lens* lens;
	Lens* lensWorkingCopy;

	UIBarButtonItem* saveButton;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil forLens:(Lens*)lens;

@property(nonatomic, retain) LensViewTableDataSource* tableViewDataSource;

@end
