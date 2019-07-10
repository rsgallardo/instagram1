//
//  ComposeViewController.h
//  instagram1
//
//  Created by rgallardo on 7/9/19.
//  Copyright © 2019 rgallardo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@protocol ComposeViewControllerDelegate

- (void)didPost;

@end

@interface ComposeViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *uploadImage;
@property (weak, nonatomic) IBOutlet UITextView *caption;
@property (nonatomic, weak) id<ComposeViewControllerDelegate> delegate;
- (IBAction)didTapCancel:(id)sender;
- (IBAction)didTapOpenCamera:(id)sender;
- (IBAction)didTapShare:(id)sender;

@end

NS_ASSUME_NONNULL_END
