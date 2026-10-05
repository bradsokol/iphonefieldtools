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
//  FTPersistenceController.h
//  FieldTools
//
//  Created by Brad on 2026-10-05.
//
//

#import <CoreData/CoreData.h>
#import <Foundation/Foundation.h>

// Owns the application's Core Data stack. This used to live on the app
// delegate, which meant model code had to reach through
// [[UIApplication sharedApplication] delegate] to find the context.
@interface FTPersistenceController : NSObject

+ (FTPersistenceController*)sharedController;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end
