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
//  FlipsideViewController.h
//  FieldTools
//
//  Created by Brad on 2008/11/29.
//

#import <UIKit/UIKit.h>

@class FlipsideTableViewDataSource;
@class FlipsideTableViewDelegate;
@class FlipsideViewController;

@protocol FlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller;
@end

@interface FlipsideViewController : UITableViewController
{
	FlipsideTableViewDataSource* tableViewDataSource;
	FlipsideTableViewDelegate* tableViewDelegate;
	UINavigationController* navigationController;
}

@property (unsafe_unretained, nonatomic) id <FlipsideViewControllerDelegate> delegate;
@property(nonatomic, strong) FlipsideTableViewDataSource* tableViewDataSource;
@property(nonatomic, strong) FlipsideTableViewDelegate* tableViewDelegate;
@property(nonatomic, strong) UINavigationController* navigationController;

@end
