// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to FTCoC.h instead.

#if __has_feature(modules)
    @import Foundation;
    @import CoreData;
#else
    #import <Foundation/Foundation.h>
    #import <CoreData/CoreData.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@class FTCamera;

@interface FTCoCID : NSManagedObjectID {}
@end

@interface _FTCoC : NSManagedObject
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) FTCoCID *objectID;

@property (nonatomic, strong) NSString* name;

@property (nonatomic, strong) NSNumber* value;

@property (atomic) float valueValue;
- (float)valueValue;
- (void)setValueValue:(float)value_;

@property (nonatomic, strong, nullable) FTCamera *camera;

@end

@interface _FTCoC (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;

- (NSNumber*)primitiveValue;
- (void)setPrimitiveValue:(NSNumber*)value;

- (float)primitiveValueValue;
- (void)setPrimitiveValueValue:(float)value_;

- (FTCamera*)primitiveCamera;
- (void)setPrimitiveCamera:(FTCamera*)value;

@end

@interface FTCoCAttributes: NSObject 
+ (NSString *)name;
+ (NSString *)value;
@end

@interface FTCoCRelationships: NSObject
+ (NSString *)camera;
@end

NS_ASSUME_NONNULL_END
