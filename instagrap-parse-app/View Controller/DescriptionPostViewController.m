//
//  DescriptionPostViewController.m
//  instagrap-parse-app
//
//  Created by Tiffany Ma on 7/10/18.
//  Copyright © 2018 Tiffany Ma. All rights reserved.
//

#import "DescriptionPostViewController.h"
#import "Post.h"
#import "SVProgressHUD.h"

@interface DescriptionPostViewController ()
@property (weak, nonatomic) IBOutlet UITextField *captionTextLabel;
@property (weak, nonatomic) IBOutlet UIImageView *previewImageView;

@end

@implementation DescriptionPostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.previewImageView.image = self.orgImage;
}

- (IBAction)onTapCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onTapPost:(id)sender {
    [SVProgressHUD show];
    [Post postUserImage:self.orgImage withCaption:self.captionTextLabel.text withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if(succeeded){
            [SVProgressHUD dismiss];
        }
        else{
            NSLog(@"😫😫😫 Error posting image: %@", error.localizedDescription);
        }
    }];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
