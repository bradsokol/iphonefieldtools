// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to FTCamera.m instead.

#import "_FTCamera.h"

@implementation FTCameraID
@end

@implementation _FTCamera

+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_ {
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

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"indexValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"index"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic index;

- (uint32_t)indexValue {
	NSNumber *result = [self index];
	return [result unsignedIntValue];
}

- (void)setIndexValue:(uint32_t)value_ {
	[self setIndex:@(value_)];
}

- (uint32_t)primitiveIndexValue {
	NSNumber *result = [self primitiveIndex];
	return [result unsignedIntValue];
}

- (void)setPrimitiveIndexValue:(uint32_t)value_ {
	[self setPrimitiveIndex:@(value_)];
}

@dynamic name;

@dynamic coc;

@end

@implementation FTCameraAttributes 
+ (NSString *)index {
	return @"index";
}
+ (NSString *)name {
	return @"name";
}
@end

@implementation FTCameraRelationships 
+ (NSString *)coc {
	return @"coc";
}
@end

