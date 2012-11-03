// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to FTLens.h instead.

#import <CoreData/CoreData.h>


extern const struct FTLensAttributes {
	 NSString *index;
	 NSString *maximumAperture;
	 NSString *maximumFocalLength;
	 NSString *minimumAperture;
	 NSString *minimumFocalLength;
	 NSString *name;
} FTLensAttributes;

extern const struct FTLensRelationships {
} FTLensRelationships;

extern const struct FTLensFetchedProperties {
} FTLensFetchedProperties;









@interface FTLensID : NSManagedObjectID {}
@end

@interface _FTLens : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (FTLensID*)objectID;




@property (nonatomic, retain) NSNumber* index;


@property int32_t indexValue;
- (int32_t)indexValue;
- (void)setIndexValue:(int32_t)value_;

//- (BOOL)validateIndex:(id*)value_ error:(NSError**)error_;




@property (nonatomic, retain) NSNumber* maximumAperture;


@property float maximumApertureValue;
- (float)maximumApertureValue;
- (void)setMaximumApertureValue:(float)value_;

//- (BOOL)validateMaximumAperture:(id*)value_ error:(NSError**)error_;




@property (nonatomic, retain) NSNumber* maximumFocalLength;


@property int32_t maximumFocalLengthValue;
- (int32_t)maximumFocalLengthValue;
- (void)setMaximumFocalLengthValue:(int32_t)value_;

//- (BOOL)validateMaximumFocalLength:(id*)value_ error:(NSError**)error_;




@property (nonatomic, retain) NSNumber* minimumAperture;


@property float minimumApertureValue;
- (float)minimumApertureValue;
- (void)setMinimumApertureValue:(float)value_;

//- (BOOL)validateMinimumAperture:(id*)value_ error:(NSError**)error_;




@property (nonatomic, retain) NSNumber* minimumFocalLength;


@property int32_t minimumFocalLengthValue;
- (int32_t)minimumFocalLengthValue;
- (void)setMinimumFocalLengthValue:(int32_t)value_;

//- (BOOL)validateMinimumFocalLength:(id*)value_ error:(NSError**)error_;




@property (nonatomic, retain) NSString* name;


//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;






@end

@interface _FTLens (CoreDataGeneratedAccessors)

@end

@interface _FTLens (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveIndex;
- (void)setPrimitiveIndex:(NSNumber*)value;

- (int32_t)primitiveIndexValue;
- (void)setPrimitiveIndexValue:(int32_t)value_;




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
