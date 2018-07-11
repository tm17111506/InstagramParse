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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    
    // Get the image captured by the UIImagePickerController
    self.orgImage = info[UIImagePickerControllerOriginalImage];
    if(self.fromUserProfile){
        NSData *data = UIImagePNGRepresentation(self.orgImage);
        NSString *imageString = [PFFile fileWithName:@"ProfilePic" data:data];
        
        PFUser *user = PFUser.currentUser;
        user[@"profilePicture"] = imageString;
        [user saveInBackground];
        self.fromUserProfile = NO;
    }
    else{
        [self dismissViewControllerAnimated:YES completion:nil];
        [self performSegueWithIdentifier:@"DescriptionSegue" sender:nil];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
//    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    // Do something with the images (based on your use case)
    // Dismiss UIImagePickerController to go back to your original view controller
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//     Get the new view controller using [segue destinationViewController].
//     Pass the selected object to the new view controller.
    if([segue.identifier isEqual:@"DescriptionSegue"]){
        UINavigationController *navController = [segue destinationViewController];
        DescriptionPostViewController *descriptionVC = (DescriptionPostViewController*)navController.topViewController;
        descriptionVC.orgImage = self.orgImage;
    }
}


@end
