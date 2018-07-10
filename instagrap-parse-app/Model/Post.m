//
//  Post.m
//  instagrap-parse-app
//
//  Created by Tiffany Ma on 7/9/18.
//  Copyright © 2018 Tiffany Ma. All rights reserved.
//

#import "Post.h"

@implementation Post
@dynamic postID, userID, author, caption, image, likeCount, commentCount;

+ (nonnull NSString *)parseClassName{
    return @"Post";
}

+ (void)postUserImage:(UIImage *)image withCaption:(NSString *)caption withCompletion:(PFBooleanResultBlock)completion{
    Post *newPost = [Post new];
    newPost.image = [self getPFFileFromImage:image];
    newPost.author = [PFUser currentUser];
    newPost.caption = caption;
    newPost.likeCount = @(0);
    newPost.commentCount = @(0);
    
    [newPost saveInBackgroundWithBlock:completion];
}

+ (PFFile *)getPFFileFromImage: (UIImage * _Nullable)image{
    if(!image) return nil;
    
    NSData *imageData = UIImagePNGRepresentation(image);
    if(!imageData) return nil;
    
    return [PFFile fileWithName:@"image.png" data:imageData];
}
@end
