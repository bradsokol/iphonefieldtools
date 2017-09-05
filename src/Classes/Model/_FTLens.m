// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to FTLens.m instead.

#import "_FTLens.h"

@implementation FTLensID
@end

@implementation _FTLens

+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Lens" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Lens";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Lens" inManagedObjectContext:moc_];
}

- (FTLensID*)objectID {
	return (FTLensID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"indexValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"index"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"maximumApertureValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"maximumAperture"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"maximumFocalLengthValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"maximumFocalLength"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"minimumApertureValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"minimumAperture"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"minimumFocalLengthValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"minimumFocalLength"];
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

@dynamic maximumAperture;

- (float)maximumApertureValue {
	NSNumber *result = [self maximumAperture];
	return [result floatValue];
}

- (void)setMaximumApertureValue:(float)value_ {
	[self setMaximumAperture:@(value_)];
}

- (float)primitiveMaximumApertureValue {
	NSNumber *result = [self primitiveMaximumAperture];
	return [result floatValue];
}

- (void)setPrimitiveMaximumApertureValue:(float)value_ {
	[self setPrimitiveMaximumAperture:@(value_)];
}

@dynamic maximumFocalLength;

- (int32_t)maximumFocalLengthValue {
	NSNumber *result = [self maximumFocalLength];
	return [result intValue];
}

- (void)setMaximumFocalLengthValue:(int32_t)value_ {
	[self setMaximumFocalLength:@(value_)];
}

- (int32_t)primitiveMaximumFocalLengthValue {
	NSNumber *result = [self primitiveMaximumFocalLength];
	return [result intValue];
}

- (void)setPrimitiveMaximumFocalLengthValue:(int32_t)value_ {
	[self setPrimitiveMaximumFocalLength:@(value_)];
}

@dynamic minimumAperture;

- (float)minimumApertureValue {
	NSNumber *result = [self minimumAperture];
	return [result floatValue];
}

- (void)setMinimumApertureValue:(float)value_ {
	[self setMinimumAperture:@(value_)];
}

- (float)primitiveMinimumApertureValue {
	NSNumber *result = [self primitiveMinimumAperture];
	return [result floatValue];
}

- (void)setPrimitiveMinimumApertureValue:(float)value_ {
	[self setPrimitiveMinimumAperture:@(value_)];
}

@dynamic minimumFocalLength;

- (int32_t)minimumFocalLengthValue {
	NSNumber *result = [self minimumFocalLength];
	return [result intValue];
}

- (void)setMinimumFocalLengthValue:(int32_t)value_ {
	[self setMinimumFocalLength:@(value_)];
}

- (int32_t)primitiveMinimumFocalLengthValue {
	NSNumber *result = [self primitiveMinimumFocalLength];
	return [result intValue];
}

- (void)setPrimitiveMinimumFocalLengthValue:(int32_t)value_ {
	[self setPrimitiveMinimumFocalLength:@(value_)];
}

@dynamic name;

@end

@implementation FTLensAttributes 
+ (NSString *)index {
	return @"index";
}
+ (NSString *)maximumAperture {
	return @"maximumAperture";
}
+ (NSString *)maximumFocalLength {
	return @"maximumFocalLength";
}
+ (NSString *)minimumAperture {
	return @"minimumAperture";
}
+ (NSString *)minimumFocalLength {
	return @"minimumFocalLength";
}
+ (NSString *)name {
	return @"name";
}
@end

