// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Brand.h instead.

#import <CoreData/CoreData.h>


extern const struct BrandAttributes {
	__unsafe_unretained NSString *brand_description;
	__unsafe_unretained NSString *brand_id;
	__unsafe_unretained NSString *followers;
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *profileImageURL;
	__unsafe_unretained NSString *slogan;
	__unsafe_unretained NSString *website;
} BrandAttributes;

extern const struct BrandRelationships {
	__unsafe_unretained NSString *contests;
} BrandRelationships;

extern const struct BrandFetchedProperties {
} BrandFetchedProperties;

@class Contest;









@interface BrandID : NSManagedObjectID {}
@end

@interface _Brand : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (BrandID*)objectID;





@property (nonatomic, strong) NSString* brand_description;



//- (BOOL)validateBrand_description:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* brand_id;



//- (BOOL)validateBrand_id:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* followers;



@property int32_t followersValue;
- (int32_t)followersValue;
- (void)setFollowersValue:(int32_t)value_;

//- (BOOL)validateFollowers:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* name;



//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* profileImageURL;



//- (BOOL)validateProfileImageURL:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* slogan;



//- (BOOL)validateSlogan:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* website;



//- (BOOL)validateWebsite:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet *contests;

- (NSMutableSet*)contestsSet;





@end

@interface _Brand (CoreDataGeneratedAccessors)

- (void)addContests:(NSSet*)value_;
- (void)removeContests:(NSSet*)value_;
- (void)addContestsObject:(Contest*)value_;
- (void)removeContestsObject:(Contest*)value_;

@end

@interface _Brand (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveBrand_description;
- (void)setPrimitiveBrand_description:(NSString*)value;




- (NSString*)primitiveBrand_id;
- (void)setPrimitiveBrand_id:(NSString*)value;




- (NSNumber*)primitiveFollowers;
- (void)setPrimitiveFollowers:(NSNumber*)value;

- (int32_t)primitiveFollowersValue;
- (void)setPrimitiveFollowersValue:(int32_t)value_;




- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;




- (NSString*)primitiveProfileImageURL;
- (void)setPrimitiveProfileImageURL:(NSString*)value;




- (NSString*)primitiveSlogan;
- (void)setPrimitiveSlogan:(NSString*)value;




- (NSString*)primitiveWebsite;
- (void)setPrimitiveWebsite:(NSString*)value;





- (NSMutableSet*)primitiveContests;
- (void)setPrimitiveContests:(NSMutableSet*)value;


@end
