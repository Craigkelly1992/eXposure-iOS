#import "Brand.h"
#import "EXPAPIClient.h"
#import "CoreData+MagicalRecord.h"
#import "User.h"

@interface Brand ()

// Private interface goes here.

@end

@implementation Brand

// Custom logic goes here.

+ (NSURLSessionDataTask *)brandWithID:(NSString *)brandID completion:(void (^)(Brand *brand, NSError *error))block {
    User *user = [User currentUser];
    NSString *string = [NSString stringWithFormat:@"brands/%@",brandID];
    return [[EXPAPIClient sharedClient]GET:string parameters:@{@"user_email":user.email ,@"user_token": user.token} success:^(NSURLSessionDataTask *task, id responseObject){
        NSLog(@"OH HAI THIS IS THE BRAND %@",responseObject);
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext){
            Brand *brand = [Brand MR_createEntityInContext:localContext];
            brand.name = responseObject[@"name"];
            brand.profileImageURL = responseObject[@"picture_url"];
            brand.slogan = responseObject[@"slogan"];
            brand.brand_id = [NSString stringWithFormat:@"%@",responseObject[@"id"]];
            brand.brand_description = responseObject[@"description"];
        }completion:^(BOOL success, NSError *error){
            if(block){
                Brand *brand = [Brand MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"brand_id == %@",brandID]];
                
                block(brand, nil);
            }
        }];
        

        
        NSLog(@"%@",responseObject);
    }failure:^(NSURLSessionDataTask *task, NSError *error){
        NSLog(@"%@",error);
        if(block){
            block(nil, error);
        }
    }];
    
}

+ (NSURLSessionDataTask *)brandClickWithID:(NSString *)brandID completion:(void (^)(Brand *brand, NSError *error))block {
    User *user = [User currentUser];
    NSString *string = [NSString stringWithFormat:@"brands/%@/click",brandID];
    return [[EXPAPIClient sharedClient]GET:string parameters:@{@"user_email":user.email ,@"user_token": user.token} success:^(NSURLSessionDataTask *task, id responseObject){
        NSLog(@"%@",responseObject);
    }failure:^(NSURLSessionDataTask *task, NSError *error){
        NSLog(@"%@",error);
    }];
    
}

@end
