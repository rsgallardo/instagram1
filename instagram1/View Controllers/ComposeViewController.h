//
//  ComposeViewController.h
//  instagram1
//
//  Created by rgallardo on 7/9/19.
//  Copyright © 2019 rgallardo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ComposeViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *uploadImage;
@property (weak, nonatomic) IBOutlet UITextView *caption;

- (IBAction)didTapCancel:(id)sender;
- (IBAction)didTapOpenCamera:(id)sender;
- (IBAction)didTapShare:(id)sender;

@end

NS_ASSUME_NONNULL_END
