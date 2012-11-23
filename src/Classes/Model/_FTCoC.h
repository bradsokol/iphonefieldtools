// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to FTCoC.h instead.

#import <CoreData/CoreData.h>


extern const struct FTCoCAttributes {
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *value;
} FTCoCAttributes;

extern const struct FTCoCRelationships {
	__unsafe_unretained NSString *camera;
} FTCoCRelationships;

extern const struct FTCoCFetchedProperties {
} FTCoCFetchedProperties;

@class FTCamera;




@interface FTCoCID : NSManagedObjectID {}
@end

@interface _FTCoC : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (FTCoCID*)objectID;




@property (nonatomic, strong) NSString* name;


//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSNumber* value;


@property float valueValue;
- (float)valueValue;
- (void)setValueValue:(float)value_;

//- (BOOL)validateValue:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) FTCamera* camera;

//- (BOOL)validateCamera:(id*)value_ error:(NSError**)error_;





@end

@interface _FTCoC (CoreDataGeneratedAccessors)

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
