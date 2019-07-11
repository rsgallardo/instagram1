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

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self getProfileFeed];
    //set layout for collection view cells
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    CGFloat postsPerRow = 2;
    CGFloat itemWidth = (self.collectionView.frame.size.width - 5) / postsPerRow;
    CGFloat itemHeight = itemWidth * 1.2;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
}

- (void)getProfileFeed {
    // construct query
    PFUser *user = [PFUser currentUser];
    self.usernameLabel.text = user.username;
    NSLog(@"User username: %@", user.username);
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"author = %@", user];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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

@end
