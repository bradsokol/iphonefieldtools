// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to FTCoC.h instead.

#import <CoreData/CoreData.h>


extern const struct FTCoCAttributes {
	 NSString *name;
	 NSString *value;
} FTCoCAttributes;

extern const struct FTCoCRelationships {
	 NSString *camera;
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




@property (nonatomic, retain) NSNumber* name;


@property float nameValue;
- (float)nameValue;
- (void)setNameValue:(float)value_;

//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;




@property (nonatomic, retain) NSNumber* value;


@property float valueValue;
- (float)valueValue;
- (void)setValueValue:(float)value_;

//- (BOOL)validateValue:(id*)value_ error:(NSError**)error_;





@property (nonatomic, retain) FTCamera* camera;

//- (BOOL)validateCamera:(id*)value_ error:(NSError**)error_;





@end

@interface _FTCoC (CoreDataGeneratedAccessors)

@end

@interface _FTCoC (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveName;
- (void)setPrimitiveName:(NSNumber*)value;

- (float)primitiveNameValue;
- (void)setPrimitiveNameValue:(float)value_;




- (NSNumber*)primitiveValue;
- (void)setPrimitiveValue:(NSNumber*)value;

- (float)primitiveValueValue;
- (void)setPrimitiveValueValue:(float)value_;





- (FTCamera*)primitiveCamera;
- (void)setPrimitiveCamera:(FTCamera*)value;


@end
