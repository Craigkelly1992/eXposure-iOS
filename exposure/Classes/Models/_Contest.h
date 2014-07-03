// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Contest.h instead.

#import <CoreData/CoreData.h>


extern const struct ContestAttributes {
	__unsafe_unretained NSString *brand_id;
	__unsafe_unretained NSString *brand_name;
	__unsafe_unretained NSString *contest_description;
	__unsafe_unretained NSString *contest_id;
	__unsafe_unretained NSString *end_date;
	__unsafe_unretained NSString *picture;
	__unsafe_unretained NSString *prizes;
	__unsafe_unretained NSString *rules;
	__unsafe_unretained NSString *title;
} ContestAttributes;

extern const struct ContestRelationships {
	__unsafe_unretained NSString *posts;
} ContestRelationships;

extern const struct ContestFetchedProperties {
} ContestFetchedProperties;

@class Post;











@interface ContestID : NSManagedObjectID {}
@end

@interface _Contest : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (ContestID*)objectID;





@property (nonatomic, strong) NSString* brand_id;



//- (BOOL)validateBrand_id:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* brand_name;



//- (BOOL)validateBrand_name:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* contest_description;



//- (BOOL)validateContest_description:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* contest_id;



//- (BOOL)validateContest_id:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* end_date;



//- (BOOL)validateEnd_date:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* picture;



//- (BOOL)validatePicture:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* prizes;



//- (BOOL)validatePrizes:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* rules;



//- (BOOL)validateRules:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* title;



//- (BOOL)validateTitle:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet *posts;

- (NSMutableSet*)postsSet;





@end

@interface _Contest (CoreDataGeneratedAccessors)

- (void)addPosts:(NSSet*)value_;
- (void)removePosts:(NSSet*)value_;
- (void)addPostsObject:(Post*)value_;
- (void)removePostsObject:(Post*)value_;

@end

@interface _Contest (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveBrand_id;
- (void)setPrimitiveBrand_id:(NSString*)value;




- (NSString*)primitiveBrand_name;
- (void)setPrimitiveBrand_name:(NSString*)value;




- (NSString*)primitiveContest_description;
- (void)setPrimitiveContest_description:(NSString*)value;




- (NSString*)primitiveContest_id;
- (void)setPrimitiveContest_id:(NSString*)value;




- (NSString*)primitiveEnd_date;
- (void)setPrimitiveEnd_date:(NSString*)value;




- (NSString*)primitivePicture;
- (void)setPrimitivePicture:(NSString*)value;




- (NSString*)primitivePrizes;
- (void)setPrimitivePrizes:(NSString*)value;




- (NSString*)primitiveRules;
- (void)setPrimitiveRules:(NSString*)value;




- (NSString*)primitiveTitle;
- (void)setPrimitiveTitle:(NSString*)value;





- (NSMutableSet*)primitivePosts;
- (void)setPrimitivePosts:(NSMutableSet*)value;


@end
