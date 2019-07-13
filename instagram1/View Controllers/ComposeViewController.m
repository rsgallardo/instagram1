//
//  ComposeViewController.m
//  instagram1
//
//  Created by rgallardo on 7/9/19.
//  Copyright © 2019 rgallardo. All rights reserved.
//

#import "ComposeViewController.h"
#import "Post.h"
@import MBProgressHUD;

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)didTapCancel:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)didTapOpenCamera:(id)sender {
    NSLog(@"tapped camera image");
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;

    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        NSLog(@"Camera 🚫 available so we will use photo library instead");
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    [self presentViewController:imagePickerVC animated:YES completion:nil];
    
}

- (IBAction)didTapShare:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [Post postUserImage:self.uploadImage.image withCaption:self.caption.text withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if(error != nil) {
            NSLog(@"Error posting image: %@", error.localizedDescription);
        } else {
            NSLog(@"Posted image successfully");
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self dismissViewControllerAnimated:YES completion:nil];
            [self.delegate didPost];
        }
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // Get the image captured by the UIImagePickerController
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    // Resize image to avoid memory issues in Parse
    UIImage *resizedImage = [self resizeImage:editedImage withSize:CGSizeMake(400, 400)];
    self.uploadImage.image = resizedImage;
    // Dismiss UIImagePickerController to go back to original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
