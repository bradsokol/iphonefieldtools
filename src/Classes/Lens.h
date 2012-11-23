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

@interface Lens : NSObject <NSCoding> 
{
	int identifier;
	NSString* description;
	NSNumber* minimumAperture;
	NSNumber* maximumAperture;
	NSNumber* minimumFocalLength;
	NSNumber* maximumFocalLength;
}

// The designated initializer
- (id)initWithDescription:(NSString*)aDescription 
		  minimumAperture:(NSNumber*)aMinimumAperture
		  maximumAperture:(NSNumber*)aMaximumAperture
	   minimumFocalLength:(NSNumber*)aMinimumFocalLength
	   maximumFocalLength:(NSNumber*)aMaximumFocalLength
			   identifier:(int)anIdentifier;

- (id)copyWithZone:(NSZone *)zone;

+ (Lens*)findFromDefaultsForIndex_deprecated:(int)index;

+ (int)count_deprecated;

- (NSDictionary*)asDictionary_deprecated;

- (bool)isZoom;

- (void)save_deprecated;

@property(nonatomic, strong) NSString* description;
@property(nonatomic) int identifier;
@property(nonatomic, strong) NSNumber* maximumAperture;
@property(nonatomic, strong) NSNumber* minimumAperture;
@property(nonatomic, strong) NSNumber* maximumFocalLength;
@property(nonatomic, strong) NSNumber* minimumFocalLength;

@end
