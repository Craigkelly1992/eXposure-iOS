// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Notification.h instead.

#import <CoreData/CoreData.h>

extern const struct NotificationAttributes {
	__unsafe_unretained NSString *notificationImage;
	__unsafe_unretained NSString *notification_id;
	__unsafe_unretained NSString *text;
	__unsafe_unretained NSString *type;
} NotificationAttributes;

extern const struct NotificationRelationships {
} NotificationRelationships;

extern const struct NotificationFetchedProperties {
} NotificationFetchedProperties;

@interface NotificationID : NSManagedObjectID {}
@end

@interface _Notification : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (NotificationID*)objectID;

@property (nonatomic, strong) NSString* notificationImage;

//- (BOOL)validateNotificationImage:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* notification_id;

//- (BOOL)validateNotification_id:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* text;

//- (BOOL)validateText:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* type;

//- (BOOL)validateType:(id*)value_ error:(NSError**)error_;

@end

@interface _Notification (CoreDataGeneratedAccessors)

@end

@interface _Notification (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveNotificationImage;
- (void)setPrimitiveNotificationImage:(NSString*)value;

- (NSString*)primitiveNotification_id;
- (void)setPrimitiveNotification_id:(NSString*)value;

- (NSString*)primitiveText;
- (void)setPrimitiveText:(NSString*)value;

- (NSString*)primitiveType;
- (void)setPrimitiveType:(NSString*)value;

@end
