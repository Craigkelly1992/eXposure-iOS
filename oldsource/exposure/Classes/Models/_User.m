// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to User.m instead.

#import "_User.h"

const struct UserAttributes UserAttributes = {
	.backdropImage = @"backdropImage",
	.email = @"email",
	.facebook = @"facebook",
	.firstName = @"firstName",
	.followerCount = @"followerCount",
	.followingCount = @"followingCount",
	.instagram = @"instagram",
	.lastName = @"lastName",
	.postCount = @"postCount",
	.profileImage = @"profileImage",
	.ranking = @"ranking",
	.token = @"token",
	.twitter = @"twitter",
	.userName = @"userName",
	.user_description = @"user_description",
	.user_id = @"user_id",
};

const struct UserRelationships UserRelationships = {
};

const struct UserFetchedProperties UserFetchedProperties = {
};

@implementation UserID
@end

@implementation _User

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"User";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"User" inManagedObjectContext:moc_];
}

- (UserID*)objectID {
	return (UserID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"followerCountValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"followerCount"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"followingCountValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"followingCount"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"postCountValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"postCount"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"rankingValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"ranking"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic backdropImage;






@dynamic email;






@dynamic facebook;






@dynamic firstName;






@dynamic followerCount;



- (int32_t)followerCountValue {
	NSNumber *result = [self followerCount];
	return [result intValue];
}

- (void)setFollowerCountValue:(int32_t)value_ {
	[self setFollowerCount:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveFollowerCountValue {
	NSNumber *result = [self primitiveFollowerCount];
	return [result intValue];
}

- (void)setPrimitiveFollowerCountValue:(int32_t)value_ {
	[self setPrimitiveFollowerCount:[NSNumber numberWithInt:value_]];
}





@dynamic followingCount;



- (int32_t)followingCountValue {
	NSNumber *result = [self followingCount];
	return [result intValue];
}

- (void)setFollowingCountValue:(int32_t)value_ {
	[self setFollowingCount:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveFollowingCountValue {
	NSNumber *result = [self primitiveFollowingCount];
	return [result intValue];
}

- (void)setPrimitiveFollowingCountValue:(int32_t)value_ {
	[self setPrimitiveFollowingCount:[NSNumber numberWithInt:value_]];
}





@dynamic instagram;






@dynamic lastName;






@dynamic postCount;



- (int32_t)postCountValue {
	NSNumber *result = [self postCount];
	return [result intValue];
}

- (void)setPostCountValue:(int32_t)value_ {
	[self setPostCount:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitivePostCountValue {
	NSNumber *result = [self primitivePostCount];
	return [result intValue];
}

- (void)setPrimitivePostCountValue:(int32_t)value_ {
	[self setPrimitivePostCount:[NSNumber numberWithInt:value_]];
}





@dynamic profileImage;






@dynamic ranking;



- (int32_t)rankingValue {
	NSNumber *result = [self ranking];
	return [result intValue];
}

- (void)setRankingValue:(int32_t)value_ {
	[self setRanking:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveRankingValue {
	NSNumber *result = [self primitiveRanking];
	return [result intValue];
}

- (void)setPrimitiveRankingValue:(int32_t)value_ {
	[self setPrimitiveRanking:[NSNumber numberWithInt:value_]];
}





@dynamic token;






@dynamic twitter;






@dynamic userName;






@dynamic user_description;






@dynamic user_id;











@end
