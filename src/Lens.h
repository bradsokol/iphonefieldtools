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
//  Lens.h
//  FieldTools
//
//  Created by Brad on 2009/08/27.
//  Copyright 2009 Brad Sokol. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Lens : NSObject 
{
	int identifier;
	NSString* description;
	float minimumAperture;
	float maximumAperture;
	int minimumFocalLength;
	int maximumFocalLength;
}

+ (int)count;

- (id)initWithDescription:(NSString*)aDescription 
		  minimumAperture:(float)aMinimumAperture
		  maximumAperture:(float)aMaximumAperture
	   minimumFocalLength:(int)aMinimumFocalLength
	   maximumFocalLength:(int)aMaximumFocalLength
			   identifier:(int)anIdentifier;

- (NSDictionary*)asDictionary;

- (bool)isZoom;

- (void)save;

@property(nonatomic, retain) NSString* description;
@property(nonatomic) int identifier;
@property(nonatomic) float maximumAperture;
@property(nonatomic) float minimumAperture;
@property(nonatomic) int maximumFocalLength;
@property(nonatomic) int minimumFocalLength;

@end
