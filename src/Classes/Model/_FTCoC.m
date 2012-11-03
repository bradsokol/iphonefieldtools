// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to FTCoC.m instead.

#import "_FTCoC.h"

const struct FTCoCAttributes FTCoCAttributes = {
	.name = @"name",
	.value = @"value",
};

const struct FTCoCRelationships FTCoCRelationships = {
	.camera = @"camera",
};

const struct FTCoCFetchedProperties FTCoCFetchedProperties = {
};

@implementation FTCoCID
@end

@implementation _FTCoC

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"CoC" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"CoC";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"CoC" inManagedObjectContext:moc_];
}

- (FTCoCID*)objectID {
	return (FTCoCID*)[super objectID];
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"valueValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"value"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}

	return keyPaths;
}




@dynamic name;






@dynamic value;



- (float)valueValue {
	NSNumber *result = [self value];
	return [result floatValue];
}

- (void)setValueValue:(float)value_ {
	[self setValue:[NSNumber numberWithFloat:value_]];
}

- (float)primitiveValueValue {
	NSNumber *result = [self primitiveValue];
	return [result floatValue];
}

- (void)setPrimitiveValueValue:(float)value_ {
	[self setPrimitiveValue:[NSNumber numberWithFloat:value_]];
}





@dynamic camera;

	






@end
