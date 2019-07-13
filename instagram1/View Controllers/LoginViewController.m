//
//  LoginViewController.m
//  instagram1
//
//  Created by rgallardo on 7/9/19.
//  Copyright © 2019 rgallardo. All rights reserved.
//

#import "LoginViewController.h"
#import "Parse/Parse.h"

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)didTapSignUp:(id)sender {
    [self registerUser];
}

- (IBAction)didTapSignIn:(id)sender {
    [self loginUser];
}

- (IBAction)didTapBackground:(id)sender {
    [self.view endEditing: YES];
}

- (void)registerUser {
    // initialize a user object
    PFUser *newUser = [PFUser user];
    // set user properties
    newUser.username = self.usernameField.text;
    newUser.email = self.emailField.text;
    newUser.password = self.passwordField.text;
    // call sign up function on the object
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
        } else {
            NSLog(@"User registered successfully");
            // manually segue to logged in view
            [self performSegueWithIdentifier:@"logInSegue" sender:nil];
        }
    }];
}

- (void)loginUser {
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
        if (error != nil) {
            NSLog(@"User log in failed: %@", error.localizedDescription);
        } else {
            NSLog(@"User logged in successfully");
            // display view controller that needs to shown after successful login
            [self performSegueWithIdentifier:@"logInSegue" sender:nil];
        }
    }];
}

@end
