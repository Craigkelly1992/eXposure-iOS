// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Notification.m instead.

#import "_Notification.h"

const struct NotificationAttributes NotificationAttributes = {
	.notificationImage = @"notificationImage",
	.notification_id = @"notification_id",
	.text = @"text",
	.type = @"type",
};

const struct NotificationRelationships NotificationRelationships = {
};

const struct NotificationFetchedProperties NotificationFetchedProperties = {
};

@implementation NotificationID
@end

@implementation _Notification

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Notification" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Notification";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Notification" inManagedObjectContext:moc_];
}

- (NotificationID*)objectID {
	return (NotificationID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic notificationImage;






@dynamic notification_id;






@dynamic text;






@dynamic type;











@end
