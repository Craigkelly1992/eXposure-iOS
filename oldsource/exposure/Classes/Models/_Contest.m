// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Contest.m instead.

#import "_Contest.h"

const struct ContestAttributes ContestAttributes = {
	.brand_id = @"brand_id",
	.brand_name = @"brand_name",
	.contest_description = @"contest_description",
	.contest_id = @"contest_id",
	.end_date = @"end_date",
	.picture = @"picture",
	.prizes = @"prizes",
	.rules = @"rules",
	.title = @"title",
};

const struct ContestRelationships ContestRelationships = {
	.posts = @"posts",
};

const struct ContestFetchedProperties ContestFetchedProperties = {
};

@implementation ContestID
@end

@implementation _Contest

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Contest" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Contest";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Contest" inManagedObjectContext:moc_];
}

- (ContestID*)objectID {
	return (ContestID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic brand_id;






@dynamic brand_name;






@dynamic contest_description;






@dynamic contest_id;






@dynamic end_date;






@dynamic picture;






@dynamic prizes;






@dynamic rules;






@dynamic title;






@dynamic posts;

	
- (NSMutableSet*)postsSet {
	[self willAccessValueForKey:@"posts"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"posts"];
  
	[self didAccessValueForKey:@"posts"];
	return result;
}
	






@end
