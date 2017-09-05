// Copyright 2009-2017 Brad Sokol
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
//  CameraViewTableDataSource.m
//  FieldTools
//
//  Created by Brad on 2009/06/10.
//  Copyright 2009-2017 Brad Sokol. 
//

#import "CameraViewTableDataSource.h"

#import "CameraViewController.h"
#import "FTCamera.h"
#import "FTCoC.h"

static const int CAMERA_NAME_ROW = 0;
static const int NUM_SECTIONS = 1;

@interface CameraViewTableDataSource ()

- (UITableViewCell*) cellForCameraNameRowAtIndexPath:(NSIndexPath *)indexPath inTableView:(UITableView *) tableView;
- (UITableViewCell*) cellForCoCRowAtIndexPath:(NSIndexPath *)indexPath inTableView:(UITableView *) tableView;

@end

@implementation CameraViewTableDataSource

@synthesize camera;
@synthesize controller;

- (id)init
{
	return [super init];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return NUM_SECTIONS;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	return 2;
}

// Customize the appearance of table view cells. Cells for the units and
// camera sections are formatted differently and handled by helper methods.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	if ([indexPath row] == CAMERA_NAME_ROW)
	{
		return [self cellForCameraNameRowAtIndexPath:indexPath inTableView:tableView];
	}
	else
	{
		return [self cellForCoCRowAtIndexPath:indexPath inTableView:tableView];
	}
}

- (UITableViewCell*) cellForCameraNameRowAtIndexPath:(NSIndexPath *)indexPath inTableView:(UITableView *) tableView
{
	CameraViewController* cameraViewController = (CameraViewController*)[self controller];
	[[cameraViewController cameraNameLabel] setText:NSLocalizedString(@"CAMERA_NAME_TITLE", "Camera")];
	[[cameraViewController cameraNameField] setText:[[self camera] description]];
	
	return [cameraViewController cameraNameCell];
}

- (UITableViewCell*) cellForCoCRowAtIndexPath:(NSIndexPath *)indexPath inTableView:(UITableView *) tableView
{
	static NSString* CellIdentifier = @"Cell";

    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (nil == cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }

    cell.textLabel.text = NSLocalizedString(@"COC_TITLE", "CoC");
    cell.detailTextLabel.text = self.camera.coc.description;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

	return cell;
}


@end
