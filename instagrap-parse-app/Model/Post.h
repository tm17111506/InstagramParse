//
//  Post.h
//  instagrap-parse-app
//
//  Created by Tiffany Ma on 7/9/18.
//  Copyright © 2018 Tiffany Ma. All rights reserved.
//

#import "PFObject.h"
#import <UIKit/UIKit.h>
#import "Parse.h"

@interface Post : PFObject <PFSubclassing>
@property (strong, nonatomic) NSString * _Nullable postID;
@property (strong, nonatomic) NSString *userID;
@property (strong, nonatomic) PFUser *author;

@property (strong, nonatomic) NSString *caption;
@property (strong, nonatomic) PFFile *image;
@property (strong, nonatomic) NSNumber *likeCount;
@property (strong, nonatomic) NSNumber *commentCount;
@property (strong, nonatomic) NSArray *comments;
@property BOOL liked;
+ (void) postUserImage: (UIImage * _Nullable )image withCaption: (NSString * _Nullable)caption withCompletion: (PFBooleanResultBlock  _Nullable)completion;

@end
