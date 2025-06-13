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

#import "FTCoC.h"

#import "FTCameraBag.h"

static NSDictionary* cocPresets;

@implementation FTCoC

+ (NSDictionary*)cocPresets
{
	if (nil == cocPresets)
	{
		NSString* path = [[NSBundle mainBundle] pathForResource:@"CoC" ofType:@"plist"];
		cocPresets = [NSDictionary dictionaryWithContentsOfFile:path];
		for (NSString* key in cocPresets)
		{
			DLog(@"%@ %@", key, [cocPresets objectForKey:key]);
		}
	}
	
	return cocPresets;
}

+ (FTCoC*)findFromPresets:(NSString*)cocDescription
{
	if (nil == cocDescription || [cocDescription length] == 0 ||
        [[FTCoC cocPresets] objectForKey:cocDescription] == nil)
	{
		return nil;
	}
	
	float value = [[cocPresets objectForKey:cocDescription] floatValue];
    FTCoC* coc = [[FTCameraBag sharedCameraBag] newCoC];
    [coc setName:cocDescription];
    [coc setValueValue:value];

    return coc;
}

- (NSString*)description
{
    return [self name];
}

@end
