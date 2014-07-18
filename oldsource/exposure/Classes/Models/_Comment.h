// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Comment.h instead.

#import <CoreData/CoreData.h>


extern const struct CommentAttributes {
	__unsafe_unretained NSString *commentPicture;
	__unsafe_unretained NSString *commentText;
	__unsafe_unretained NSString *comment_id;
	__unsafe_unretained NSString *commenter_id;
	__unsafe_unretained NSString *commenter_name;
} CommentAttributes;

extern const struct CommentRelationships {
} CommentRelationships;

extern const struct CommentFetchedProperties {
} CommentFetchedProperties;








@interface CommentID : NSManagedObjectID {}
@end

@interface _Comment : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (CommentID*)objectID;





@property (nonatomic, strong) NSString* commentPicture;



//- (BOOL)validateCommentPicture:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* commentText;



//- (BOOL)validateCommentText:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* comment_id;



//- (BOOL)validateComment_id:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* commenter_id;



//- (BOOL)validateCommenter_id:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* commenter_name;



//- (BOOL)validateCommenter_name:(id*)value_ error:(NSError**)error_;






@end

@interface _Comment (CoreDataGeneratedAccessors)

@end

@interface _Comment (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveCommentPicture;
- (void)setPrimitiveCommentPicture:(NSString*)value;




- (NSString*)primitiveCommentText;
- (void)setPrimitiveCommentText:(NSString*)value;




- (NSString*)primitiveComment_id;
- (void)setPrimitiveComment_id:(NSString*)value;




- (NSString*)primitiveCommenter_id;
- (void)setPrimitiveCommenter_id:(NSString*)value;




- (NSString*)primitiveCommenter_name;
- (void)setPrimitiveCommenter_name:(NSString*)value;




@end
