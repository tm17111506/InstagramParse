//
//  ProfileViewController.h
//  instagrap-parse-app
//
//  Created by Tiffany Ma on 7/10/18.
//  Copyright © 2018 Tiffany Ma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Parse.h"
#import "Post.h"

@interface ProfileViewController : UIViewController
@property (strong, nonatomic) PFUser *user;
@property BOOL currentUser;
@end
