//
//  CaptureViewController.m
//  instagrap-parse-app
//
//  Created by Tiffany Ma on 7/9/18.
//  Copyright © 2018 Tiffany Ma. All rights reserved.
//

#import "CaptureViewController.h"
#import "Post.h"
#import "DescriptionPostViewController.h"
#import "Parse.h"

@interface CaptureViewController ()
@end

@implementation CaptureViewController

static const int imageHeight = 200;
static const int imageWidth = 200;

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)onTapCamera:(id)sender {
    [self fetchImage:YES];
}

- (IBAction)onTapPhotoLibrary:(id)sender {
    [self fetchImage:NO];
}

- (void) fetchImage: (BOOL)fromCamera{
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] && fromCamera) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    //self.orgImage = info[UIImagePickerControllerOriginalImage];
    self.orgImage = [self resizeImage:info[UIImagePickerControllerOriginalImage]];
    if(self.fromUserProfile){
        PFUser *user = PFUser.currentUser;
        NSData *data = UIImagePNGRepresentation(self.orgImage);
        NSString *imageString = [PFFile fileWithName:@"ProfilePic" data:data];
        
        user[@"profilePicture"] = imageString;
        [user saveInBackground];
        self.fromUserProfile = NO;
        [self dismissViewControllerAnimated:YES completion:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        [self dismissViewControllerAnimated:YES completion:nil];
        [self performSegueWithIdentifier:@"DescriptionSegue" sender:nil];
    }
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqual:@"DescriptionSegue"]){
        UINavigationController *navController = [segue destinationViewController];
        DescriptionPostViewController *descriptionVC = (DescriptionPostViewController*)navController.topViewController;
        descriptionVC.orgImage = self.orgImage;
    }
}

@end
