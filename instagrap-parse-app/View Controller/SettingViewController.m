//
//  SettingViewController.m
//  instagrap-parse-app
//
//  Created by Tiffany Ma on 7/10/18.
//  Copyright © 2018 Tiffany Ma. All rights reserved.
//

#import "SettingViewController.h"
#import "Parse.h"
#import "CaptureViewController.h"

@interface SettingViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UITextField *userSummaryLabel;
@property (weak, nonatomic) IBOutlet UITextField *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) PFUser *user;
@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getImageFromData];
    self.locationLabel.delegate = self;
    self.locationLabel.tag = 1;
    self.userSummaryLabel.delegate = self;
    self.userSummaryLabel.tag = 0;
    self.usernameLabel.text = self.user.username;
    self.userSummaryLabel.text = self.user[@"summary"];
    self.locationLabel.text = self.user[@"location"];
    [self.usernameLabel sizeToFit];
}

- (void)viewWillAppear:(BOOL)animated{
    [self getImageFromData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(textField.tag == 0){
        self.user[@"summary"] = textField.text;
        [self.user saveInBackground];
    }
    else if (textField.tag == 1){
        self.user[@"location"] = textField.text;
        [self.user saveInBackground];
    }
    [textField resignFirstResponder];
    return NO;
}

- (void)getImageFromData{
    [[PFUser currentUser] fetchInBackground];
    self.user = [PFUser currentUser];

    PFFile *file = (PFFile *)self.user[@"profilePicture"];
    [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        self.profileImageView.image = [UIImage imageWithData:data];
        self.profileImageView.layer.cornerRadius = self.profileImageView.layer.bounds.size.width/2;
        self.profileImageView.layer.masksToBounds = YES;
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    CaptureViewController *captureVC = [segue destinationViewController];
    captureVC.fromUserProfile = YES;
}


@end
