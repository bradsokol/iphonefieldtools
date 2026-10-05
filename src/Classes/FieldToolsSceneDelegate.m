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
//  FieldToolsSceneDelegate.m
//  FieldTools
//
//  Created by Brad on 2026/10/05.
//

#import "FieldToolsSceneDelegate.h"

#import "MainViewController.h"

@implementation FieldToolsSceneDelegate

@synthesize window;

# pragma mark "UIWindowSceneDelegate methods"

- (void)scene:(UIScene *)scene
willConnectToSession:(UISceneSession *)session
      options:(UISceneConnectionOptions *)connectionOptions
{
    if (![scene isKindOfClass:[UIWindowScene class]])
    {
        return;
    }

    UIWindowScene* windowScene = (UIWindowScene*)scene;

    UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MainViewController* mainViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"main"];

    [self setWindow:[[UIWindow alloc] initWithWindowScene:windowScene]];
    [[self window] setRootViewController:mainViewController];
    [[self window] makeKeyAndVisible];
}

@end
