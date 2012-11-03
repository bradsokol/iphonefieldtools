// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to FTCamera.h instead.

#import <CoreData/CoreData.h>


extern const struct FTCameraAttributes {
	 NSString *name;
} FTCameraAttributes;

extern const struct FTCameraRelationships {
	 NSString *coc;
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




@property (nonatomic, retain) NSString* name;


//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, retain) FTCoC* coc;

//- (BOOL)validateCoc:(id*)value_ error:(NSError**)error_;





@end

@interface _FTCamera (CoreDataGeneratedAccessors)

@end

@interface _FTCamera (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;





- (FTCoC*)primitiveCoc;
- (void)setPrimitiveCoc:(FTCoC*)value;


@end
