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
//  FlipsideTableViewDataSource.h
//  FieldTools
//
//  Created by Brad on 2009/05/28.
//  Copyright 2009 Brad Sokol. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FlipsideViewController;

extern const NSInteger SECTION_COUNT;
extern const NSInteger UNITS_COUNT;

// Enumerate sections in UITable
extern const NSInteger CAMERAS_SECTION;
extern const NSInteger LENSES_SECTION;
extern const NSInteger UNITS_SECTION;

@interface FlipsideTableViewDataSource : NSObject <UITableViewDataSource>
{
	BOOL editing;
	
	FlipsideViewController* __unsafe_unretained controller;
}

@property(nonatomic, getter=isEditing) BOOL editing;
@property(nonatomic, unsafe_unretained) FlipsideViewController* controller;

@end
