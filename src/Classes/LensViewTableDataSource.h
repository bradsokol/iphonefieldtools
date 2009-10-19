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
//  LensViewTableDataSource.h
//  FieldTools
//
//  Created by Brad on 2009/09/28.
//  Copyright 2009 Brad Sokol. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString* CellIdentifier;
extern NSString* EditableCellIdentifier;
extern NSString* EditableNumericCellIdentifier;

@class Lens;

@interface LensViewTableDataSource : NSObject <UITableViewDataSource>
{
	Lens* lens;
	bool lensIsZoom;
	UIViewController* controller;
}

- (Lens*)lens;
- (void)setLens:(Lens*)aLens;

@property(nonatomic) bool lensIsZoom;

// Weak reference to avoid retain cycles.
@property(nonatomic, assign) UIViewController* controller;

@end
