// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to FTLens.h instead.

#if __has_feature(modules)
    @import Foundation;
    @import CoreData;
#else
    #import <Foundation/Foundation.h>
    #import <CoreData/CoreData.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@interface FTLensID : NSManagedObjectID {}
@end

@interface _FTLens : NSManagedObject
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) FTLensID *objectID;

@property (nonatomic, strong) NSNumber* index;

@property (atomic) uint32_t indexValue;
- (uint32_t)indexValue;
- (void)setIndexValue:(uint32_t)value_;

@property (nonatomic, strong) NSNumber* maximumAperture;

@property (atomic) float maximumApertureValue;
- (float)maximumApertureValue;
- (void)setMaximumApertureValue:(float)value_;

@property (nonatomic, strong) NSNumber* maximumFocalLength;

@property (atomic) int32_t maximumFocalLengthValue;
- (int32_t)maximumFocalLengthValue;
- (void)setMaximumFocalLengthValue:(int32_t)value_;

@property (nonatomic, strong) NSNumber* minimumAperture;

@property (atomic) float minimumApertureValue;
- (float)minimumApertureValue;
- (void)setMinimumApertureValue:(float)value_;

@property (nonatomic, strong) NSNumber* minimumFocalLength;

@property (atomic) int32_t minimumFocalLengthValue;
- (int32_t)minimumFocalLengthValue;
- (void)setMinimumFocalLengthValue:(int32_t)value_;

@property (nonatomic, strong) NSString* name;

@end

@interface _FTLens (CoreDataGeneratedPrimitiveAccessors)

- (NSNumber*)primitiveIndex;
- (void)setPrimitiveIndex:(NSNumber*)value;

- (uint32_t)primitiveIndexValue;
- (void)setPrimitiveIndexValue:(uint32_t)value_;

- (NSNumber*)primitiveMaximumAperture;
- (void)setPrimitiveMaximumAperture:(NSNumber*)value;

- (float)primitiveMaximumApertureValue;
- (void)setPrimitiveMaximumApertureValue:(float)value_;

- (NSNumber*)primitiveMaximumFocalLength;
- (void)setPrimitiveMaximumFocalLength:(NSNumber*)value;

- (int32_t)primitiveMaximumFocalLengthValue;
- (void)setPrimitiveMaximumFocalLengthValue:(int32_t)value_;

- (NSNumber*)primitiveMinimumAperture;
- (void)setPrimitiveMinimumAperture:(NSNumber*)value;

- (float)primitiveMinimumApertureValue;
- (void)setPrimitiveMinimumApertureValue:(float)value_;

- (NSNumber*)primitiveMinimumFocalLength;
- (void)setPrimitiveMinimumFocalLength:(NSNumber*)value;

- (int32_t)primitiveMinimumFocalLengthValue;
- (void)setPrimitiveMinimumFocalLengthValue:(int32_t)value_;

- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;

@end

@interface FTLensAttributes: NSObject 
+ (NSString *)index;
+ (NSString *)maximumAperture;
+ (NSString *)maximumFocalLength;
+ (NSString *)minimumAperture;
+ (NSString *)minimumFocalLength;
+ (NSString *)name;
@end

NS_ASSUME_NONNULL_END
