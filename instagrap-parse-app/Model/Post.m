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

const int imageHeight = 500;
const int imageWidth = 500;

+ (nonnull NSString *)parseClassName{
    return @"Post";
}

+ (void)postUserImage:(UIImage *)image withCaption:(NSString *)caption withCompletion:(PFBooleanResultBlock)completion{
    Post *newPost = [Post new];
    UIImage *resizedImage = [newPost resizeImage:image];
    newPost.image = [self getPFFileFromImage:resizedImage];
    NSLog(@"%@", [PFUser currentUser].username);
    newPost.author = [PFUser currentUser];
    NSLog(@"%@", newPost.author.username);
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

- (UIImage *)resizeImage:(UIImage *)image{
    CGSize size = CGSizeMake(imageWidth, imageHeight);
    
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.height, size.width)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end