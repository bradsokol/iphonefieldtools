// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to FTCamera.h instead.

#if __has_feature(modules)
    @import Foundation;
    @import CoreData;
#else
    #import <Foundation/Foundation.h>
    #import <CoreData/CoreData.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@class FTCoC;

@interface FTCameraID : NSManagedObjectID {}
@end

@interface _FTCamera : NSManagedObject
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) FTCameraID *objectID;

@property (nonatomic, strong) NSNumber* index;

@property (atomic) uint32_t indexValue;
- (uint32_t)indexValue;
- (void)setIndexValue:(uint32_t)value_;

@property (nonatomic, strong) NSString* name;

@property (nonatomic, strong) FTCoC *coc;

@end

@interface _FTCamera (CoreDataGeneratedPrimitiveAccessors)

- (NSNumber*)primitiveIndex;
- (void)setPrimitiveIndex:(NSNumber*)value;

- (uint32_t)primitiveIndexValue;
- (void)setPrimitiveIndexValue:(uint32_t)value_;

- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;

- (FTCoC*)primitiveCoc;
- (void)setPrimitiveCoc:(FTCoC*)value;

@end

@interface FTCameraAttributes: NSObject 
+ (NSString *)index;
+ (NSString *)name;
@end

@interface FTCameraRelationships: NSObject
+ (NSString *)coc;
@end

NS_ASSUME_NONNULL_END
