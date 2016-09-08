// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to FTCoC.m instead.

#import "_FTCoC.h"

@implementation FTCoCID
@end

@implementation _FTCoC

+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_ {
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

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"valueValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"value"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
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
	[self setValue:@(value_)];
}

- (float)primitiveValueValue {
	NSNumber *result = [self primitiveValue];
	return [result floatValue];
}

- (void)setPrimitiveValueValue:(float)value_ {
	[self setPrimitiveValue:@(value_)];
}

@dynamic camera;

@end

@implementation FTCoCAttributes 
+ (NSString *)name {
	return @"name";
}
+ (NSString *)value {
	return @"value";
}
@end

@implementation FTCoCRelationships 
+ (NSString *)camera {
	return @"camera";
}
@end

