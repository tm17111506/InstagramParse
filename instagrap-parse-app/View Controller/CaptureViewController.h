//
//  CaptureViewController.h
//  instagrap-parse-app
//
//  Created by Tiffany Ma on 7/9/18.
//  Copyright © 2018 Tiffany Ma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CaptureViewController : UIViewController  <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (strong, nonatomic) UIImage *orgImage;
@property BOOL fromUserProfile;
@end
