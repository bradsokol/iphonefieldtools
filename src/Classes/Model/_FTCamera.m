// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to FTCamera.m instead.

#import "_FTCamera.h"

const struct FTCameraAttributes FTCameraAttributes = {
	.index = @"index",
	.name = @"name",
};

const struct FTCameraRelationships FTCameraRelationships = {
	.coc = @"coc",
};

const struct FTCameraFetchedProperties FTCameraFetchedProperties = {
};

@implementation FTCameraID
@end

@implementation _FTCamera

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Camera" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Camera";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Camera" inManagedObjectContext:moc_];
}

- (FTCameraID*)objectID {
	return (FTCameraID*)[super objectID];
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"indexValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"index"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}

	return keyPaths;
}




@dynamic index;



- (int32_t)indexValue {
	NSNumber *result = [self index];
	return [result intValue];
}

- (void)setIndexValue:(int32_t)value_ {
	[self setIndex:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveIndexValue {
	NSNumber *result = [self primitiveIndex];
	return [result intValue];
}

- (void)setPrimitiveIndexValue:(int32_t)value_ {
	[self setPrimitiveIndex:[NSNumber numberWithInt:value_]];
}





@dynamic name;






@dynamic coc;

	






@end
