// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to User.h instead.

#import <CoreData/CoreData.h>


extern const struct UserAttributes {
	__unsafe_unretained NSString *backdropImage;
	__unsafe_unretained NSString *email;
	__unsafe_unretained NSString *facebook;
	__unsafe_unretained NSString *firstName;
	__unsafe_unretained NSString *followerCount;
	__unsafe_unretained NSString *followingCount;
	__unsafe_unretained NSString *instagram;
	__unsafe_unretained NSString *lastName;
	__unsafe_unretained NSString *postCount;
	__unsafe_unretained NSString *profileImage;
	__unsafe_unretained NSString *ranking;
	__unsafe_unretained NSString *token;
	__unsafe_unretained NSString *twitter;
	__unsafe_unretained NSString *userName;
	__unsafe_unretained NSString *user_description;
	__unsafe_unretained NSString *user_id;
} UserAttributes;

extern const struct UserRelationships {
} UserRelationships;

extern const struct UserFetchedProperties {
} UserFetchedProperties;

@interface UserID : NSManagedObjectID {}
@end

@interface _User : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (UserID*)objectID;





@property (nonatomic, strong) NSString* backdropImage;



//- (BOOL)validateBackdropImage:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* email;



//- (BOOL)validateEmail:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* facebook;



//- (BOOL)validateFacebook:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* firstName;



//- (BOOL)validateFirstName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* followerCount;



@property int32_t followerCountValue;
- (int32_t)followerCountValue;
- (void)setFollowerCountValue:(int32_t)value_;

//- (BOOL)validateFollowerCount:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* followingCount;



@property int32_t followingCountValue;
- (int32_t)followingCountValue;
- (void)setFollowingCountValue:(int32_t)value_;

//- (BOOL)validateFollowingCount:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* instagram;



//- (BOOL)validateInstagram:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* lastName;



//- (BOOL)validateLastName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* postCount;



@property int32_t postCountValue;
- (int32_t)postCountValue;
- (void)setPostCountValue:(int32_t)value_;

//- (BOOL)validatePostCount:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* profileImage;



//- (BOOL)validateProfileImage:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* ranking;



@property int32_t rankingValue;
- (int32_t)rankingValue;
- (void)setRankingValue:(int32_t)value_;

//- (BOOL)validateRanking:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* token;



//- (BOOL)validateToken:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* twitter;



//- (BOOL)validateTwitter:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* userName;



//- (BOOL)validateUserName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* user_description;



//- (BOOL)validateUser_description:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* user_id;



//- (BOOL)validateUser_id:(id*)value_ error:(NSError**)error_;






@end

@interface _User (CoreDataGeneratedAccessors)

@end

@interface _User (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveBackdropImage;
- (void)setPrimitiveBackdropImage:(NSString*)value;




- (NSString*)primitiveEmail;
- (void)setPrimitiveEmail:(NSString*)value;




- (NSString*)primitiveFacebook;
- (void)setPrimitiveFacebook:(NSString*)value;




- (NSString*)primitiveFirstName;
- (void)setPrimitiveFirstName:(NSString*)value;




- (NSNumber*)primitiveFollowerCount;
- (void)setPrimitiveFollowerCount:(NSNumber*)value;

- (int32_t)primitiveFollowerCountValue;
- (void)setPrimitiveFollowerCountValue:(int32_t)value_;




- (NSNumber*)primitiveFollowingCount;
- (void)setPrimitiveFollowingCount:(NSNumber*)value;

- (int32_t)primitiveFollowingCountValue;
- (void)setPrimitiveFollowingCountValue:(int32_t)value_;




- (NSString*)primitiveInstagram;
- (void)setPrimitiveInstagram:(NSString*)value;




- (NSString*)primitiveLastName;
- (void)setPrimitiveLastName:(NSString*)value;




- (NSNumber*)primitivePostCount;
- (void)setPrimitivePostCount:(NSNumber*)value;

- (int32_t)primitivePostCountValue;
- (void)setPrimitivePostCountValue:(int32_t)value_;




- (NSString*)primitiveProfileImage;
- (void)setPrimitiveProfileImage:(NSString*)value;




- (NSNumber*)primitiveRanking;
- (void)setPrimitiveRanking:(NSNumber*)value;

- (int32_t)primitiveRankingValue;
- (void)setPrimitiveRankingValue:(int32_t)value_;




- (NSString*)primitiveToken;
- (void)setPrimitiveToken:(NSString*)value;




- (NSString*)primitiveTwitter;
- (void)setPrimitiveTwitter:(NSString*)value;




- (NSString*)primitiveUserName;
- (void)setPrimitiveUserName:(NSString*)value;




- (NSString*)primitiveUser_description;
- (void)setPrimitiveUser_description:(NSString*)value;




- (NSString*)primitiveUser_id;
- (void)setPrimitiveUser_id:(NSString*)value;




@end
