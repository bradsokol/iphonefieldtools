// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to FTCamera.h instead.

#import <CoreData/CoreData.h>


extern const struct FTCameraAttributes {
	__unsafe_unretained NSString *index;
	__unsafe_unretained NSString *name;
} FTCameraAttributes;

extern const struct FTCameraRelationships {
	__unsafe_unretained NSString *coc;
} FTCameraRelationships;

extern const struct FTCameraFetchedProperties {
} FTCameraFetchedProperties;

@class FTCoC;




@interface FTCameraID : NSManagedObjectID {}
@end

@interface _FTCamera : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (FTCameraID*)objectID;




@property (nonatomic, strong) NSNumber* index;


@property int32_t indexValue;
- (int32_t)indexValue;
- (void)setIndexValue:(int32_t)value_;

//- (BOOL)validateIndex:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSString* name;


//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) FTCoC* coc;

//- (BOOL)validateCoc:(id*)value_ error:(NSError**)error_;





@end

@interface _FTCamera (CoreDataGeneratedAccessors)

@end

@interface _FTCamera (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveIndex;
- (void)setPrimitiveIndex:(NSNumber*)value;

- (int32_t)primitiveIndexValue;
- (void)setPrimitiveIndexValue:(int32_t)value_;




- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;





- (FTCoC*)primitiveCoc;
- (void)setPrimitiveCoc:(FTCoC*)value;


@end
