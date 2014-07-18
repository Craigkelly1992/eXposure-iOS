// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Post.h instead.

#import <CoreData/CoreData.h>


extern const struct PostAttributes {
	__unsafe_unretained NSString *comment_count;
	__unsafe_unretained NSString *contest_id;
	__unsafe_unretained NSString *image_url;
	__unsafe_unretained NSString *like_count;
	__unsafe_unretained NSString *post_id;
	__unsafe_unretained NSString *stream;
	__unsafe_unretained NSString *text;
	__unsafe_unretained NSString *user_id;
} PostAttributes;

extern const struct PostRelationships {
} PostRelationships;

extern const struct PostFetchedProperties {
} PostFetchedProperties;











@interface PostID : NSManagedObjectID {}
@end

@interface _Post : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (PostID*)objectID;





@property (nonatomic, strong) NSNumber* comment_count;



@property int32_t comment_countValue;
- (int32_t)comment_countValue;
- (void)setComment_countValue:(int32_t)value_;

//- (BOOL)validateComment_count:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* contest_id;



//- (BOOL)validateContest_id:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* image_url;



//- (BOOL)validateImage_url:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* like_count;



@property int32_t like_countValue;
- (int32_t)like_countValue;
- (void)setLike_countValue:(int32_t)value_;

//- (BOOL)validateLike_count:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* post_id;



//- (BOOL)validatePost_id:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* stream;



@property BOOL streamValue;
- (BOOL)streamValue;
- (void)setStreamValue:(BOOL)value_;

//- (BOOL)validateStream:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* text;



//- (BOOL)validateText:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* user_id;



//- (BOOL)validateUser_id:(id*)value_ error:(NSError**)error_;






@end

@interface _Post (CoreDataGeneratedAccessors)

@end

@interface _Post (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveComment_count;
- (void)setPrimitiveComment_count:(NSNumber*)value;

- (int32_t)primitiveComment_countValue;
- (void)setPrimitiveComment_countValue:(int32_t)value_;




- (NSString*)primitiveContest_id;
- (void)setPrimitiveContest_id:(NSString*)value;




- (NSString*)primitiveImage_url;
- (void)setPrimitiveImage_url:(NSString*)value;




- (NSNumber*)primitiveLike_count;
- (void)setPrimitiveLike_count:(NSNumber*)value;

- (int32_t)primitiveLike_countValue;
- (void)setPrimitiveLike_countValue:(int32_t)value_;




- (NSString*)primitivePost_id;
- (void)setPrimitivePost_id:(NSString*)value;




- (NSNumber*)primitiveStream;
- (void)setPrimitiveStream:(NSNumber*)value;

- (BOOL)primitiveStreamValue;
- (void)setPrimitiveStreamValue:(BOOL)value_;




- (NSString*)primitiveText;
- (void)setPrimitiveText:(NSString*)value;




- (NSString*)primitiveUser_id;
- (void)setPrimitiveUser_id:(NSString*)value;




@end
