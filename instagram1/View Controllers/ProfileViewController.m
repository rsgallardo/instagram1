//
//  ProfileViewController.m
//  instagram1
//
//  Created by rgallardo on 7/10/19.
//  Copyright © 2019 rgallardo. All rights reserved.
//

#import "ProfileViewController.h"
#import "Parse/Parse.h"
#import "PostCollectionViewCell.h"
#import "UIImageView+AFNetworking.h"


@interface ProfileViewController ()

//@property (weak, nonatomic) PFUser *currentUser;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    //make profile image round
    self.profilePicture.layer.cornerRadius = 0.5 * self.profilePicture.bounds.size.height;
    self.profilePicture.layer.masksToBounds = YES;
    //set layout for collection view cells
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    CGFloat postsPerRow = 2;
    CGFloat itemWidth = (self.collectionView.frame.size.width - 50) / postsPerRow;
    CGFloat itemHeight = itemWidth * 1.2;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    if(self.user == nil) {
        self.user = [PFUser currentUser];
    }
    [self getProfileFeed];
    [self setProfilePicture];
}

- (void)getProfileFeed {
    // construct query
    self.usernameLabel.text = self.user.username;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"author = %@", self.user];
    PFQuery *query = [PFQuery queryWithClassName:@"Post" predicate:predicate];
    query.limit = 20;
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"author"];
    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            // (6) View controller stores data passed into completion handler do something with the array of object returned by the call
            self.posts = [[NSMutableArray alloc] initWithArray:posts];
            // (7) Reload the table view
            [self.collectionView reloadData];
        } else {
            NSLog(@"Couldn't load home timeline: %@", error.localizedDescription);
        }
    }];
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    // Use identifier to set cell
    PostCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PostCollectionViewCell" forIndexPath:indexPath];
    // assign the values for the post cell
    Post *post = self.posts[indexPath.item]; // set individual post based on index
    cell.post = post;
    NSURL *postURL = [NSURL URLWithString:post.image.url];
    [cell.imageView setImageWithURL:postURL];
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.posts.count;
}

- (IBAction)didTapProfileImage:(id)sender {
    // Opens the camera and lets the user set a new profile image if the user is the current user
    if(self.user == [PFUser currentUser]) {
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
    } else {
        NSLog(@"You can only change your own profile picture");
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // Get the image captured by the UIImagePickerController
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    // Resize image to avoid memory issues in Parse
    UIImage *resizedImage = [self resizeImage:editedImage withSize:CGSizeMake(400, 400)];
    self.user[@"profilePhoto"] = [self getPFFileFromImage:resizedImage];
    [self.user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if(succeeded){
            NSLog(@"successfully saved profile picture");
            [self setProfilePicture];
        } else {
            NSLog(@"Error saving profile image: %@", error.localizedDescription);
        }
    }];
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

- (PFFileObject *)getPFFileFromImage: (UIImage * _Nullable)image {
    // check if image is not nil
    if (!image) {
        return nil;
    }
    NSData *imageData = UIImagePNGRepresentation(image);
    // get image data and check if that is not nil
    if (!imageData) {
        return nil;
    }
    return [PFFileObject fileObjectWithName:@"image.png" data:imageData];
}

- (void)setProfilePicture {
    self.profilePicture.file = self.user[@"profilePhoto"];
    [self.profilePicture loadInBackground];
    
}


@end
