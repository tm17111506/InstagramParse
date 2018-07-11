//
//  DescriptionPostViewController.m
//  instagrap-parse-app
//
//  Created by Tiffany Ma on 7/10/18.
//  Copyright © 2018 Tiffany Ma. All rights reserved.
//

#import "DescriptionPostViewController.h"
#import "Post.h"

@interface DescriptionPostViewController ()
@property (weak, nonatomic) IBOutlet UITextField *captionTextLabel;
@property (weak, nonatomic) IBOutlet UIImageView *previewImageView;

@end

@implementation DescriptionPostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.previewImageView.image = self.orgImage;
    // Do any additional setup after loading the view.
}

- (IBAction)onTapCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onTapPost:(id)sender {
    [Post postUserImage:self.orgImage withCaption:self.captionTextLabel.text withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if(succeeded){
            NSLog(@"Successfully uploaded image!");
        }
        else{
            NSLog(@"😫😫😫 Error posting image: %@", error.localizedDescription);
        }
    }];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
