//
//  LoginViewController.h
//  instagram1
//
//  Created by rgallardo on 7/9/19.
//  Copyright © 2019 rgallardo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
- (IBAction)didTapSignUp:(id)sender;
- (IBAction)didTapSignIn:(id)sender;
- (IBAction)didTapBackground:(id)sender;

@end

NS_ASSUME_NONNULL_END
