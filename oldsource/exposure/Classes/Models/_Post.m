// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Post.m instead.

#import "_Post.h"

const struct PostAttributes PostAttributes = {
	.comment_count = @"comment_count",
	.contest_id = @"contest_id",
	.image_url = @"image_url",
	.like_count = @"like_count",
	.post_id = @"post_id",
	.stream = @"stream",
	.text = @"text",
	.user_id = @"user_id",
};

const struct PostRelationships PostRelationships = {
};

const struct PostFetchedProperties PostFetchedProperties = {
};

@implementation PostID
@end

@implementation _Post

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Post" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Post";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Post" inManagedObjectContext:moc_];
}

- (PostID*)objectID {
	return (PostID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"comment_countValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"comment_count"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"like_countValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"like_count"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"streamValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"stream"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic comment_count;



- (int32_t)comment_countValue {
	NSNumber *result = [self comment_count];
	return [result intValue];
}

- (void)setComment_countValue:(int32_t)value_ {
	[self setComment_count:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveComment_countValue {
	NSNumber *result = [self primitiveComment_count];
	return [result intValue];
}

- (void)setPrimitiveComment_countValue:(int32_t)value_ {
	[self setPrimitiveComment_count:[NSNumber numberWithInt:value_]];
}





@dynamic contest_id;






@dynamic image_url;






@dynamic like_count;



- (int32_t)like_countValue {
	NSNumber *result = [self like_count];
	return [result intValue];
}

- (void)setLike_countValue:(int32_t)value_ {
	[self setLike_count:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveLike_countValue {
	NSNumber *result = [self primitiveLike_count];
	return [result intValue];
}

- (void)setPrimitiveLike_countValue:(int32_t)value_ {
	[self setPrimitiveLike_count:[NSNumber numberWithInt:value_]];
}





@dynamic post_id;






@dynamic stream;



- (BOOL)streamValue {
	NSNumber *result = [self stream];
	return [result boolValue];
}

- (void)setStreamValue:(BOOL)value_ {
	[self setStream:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveStreamValue {
	NSNumber *result = [self primitiveStream];
	return [result boolValue];
}

- (void)setPrimitiveStreamValue:(BOOL)value_ {
	[self setPrimitiveStream:[NSNumber numberWithBool:value_]];
}





@dynamic text;






@dynamic user_id;











@end
