// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to FTCamera.m instead.

#import "_FTCamera.h"

const struct FTCameraAttributes FTCameraAttributes = {
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
	

	return keyPaths;
}




@dynamic name;






@dynamic coc;

	






@end
