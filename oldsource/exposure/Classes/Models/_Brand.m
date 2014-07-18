// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Brand.m instead.

#import "_Brand.h"

const struct BrandAttributes BrandAttributes = {
	.brand_description = @"brand_description",
	.brand_id = @"brand_id",
	.followers = @"followers",
	.name = @"name",
	.profileImageURL = @"profileImageURL",
	.slogan = @"slogan",
	.website = @"website",
};

const struct BrandRelationships BrandRelationships = {
	.contests = @"contests",
};

const struct BrandFetchedProperties BrandFetchedProperties = {
};

@implementation BrandID
@end

@implementation _Brand

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Brand" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Brand";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Brand" inManagedObjectContext:moc_];
}

- (BrandID*)objectID {
	return (BrandID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"followersValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"followers"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic brand_description;






@dynamic brand_id;






@dynamic followers;



- (int32_t)followersValue {
	NSNumber *result = [self followers];
	return [result intValue];
}

- (void)setFollowersValue:(int32_t)value_ {
	[self setFollowers:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveFollowersValue {
	NSNumber *result = [self primitiveFollowers];
	return [result intValue];
}

- (void)setPrimitiveFollowersValue:(int32_t)value_ {
	[self setPrimitiveFollowers:[NSNumber numberWithInt:value_]];
}





@dynamic name;






@dynamic profileImageURL;






@dynamic slogan;






@dynamic website;






@dynamic contests;

	
- (NSMutableSet*)contestsSet {
	[self willAccessValueForKey:@"contests"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"contests"];
  
	[self didAccessValueForKey:@"contests"];
	return result;
}
	






@end
