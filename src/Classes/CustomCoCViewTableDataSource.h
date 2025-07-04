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
//  CustomCoCViewTableDataSource.h
//  FieldTools
//
//  Created by Brad on 2009/10/19.
//  Copyright 2009-2025 Brad Sokol. 
//

#import <Foundation/Foundation.h>

@class FTCamera;

@interface CustomCoCViewTableDataSource : NSObject <UITableViewDataSource>
{
	FTCamera* camera;
	UIViewController* __unsafe_unretained controller;
}

@property(nonatomic, strong) FTCamera* camera;

// Weak reference to prevent retain cycles.
@property(nonatomic, unsafe_unretained) UIViewController* controller;

@end
