//
//  SettingsViewController.m
//  JustTheTip
//
//  Created by Kevoye Boswell on 8/22/16.
//  Copyright © 2016 Roy Jossfolk Inc. All rights reserved.
//

#import "SettingsViewController.h"
#import "SettingCell.h"
#import <MessageUI/MessageUI.h>

@interface SettingsViewController () <UITableViewDelegate, UITableViewDataSource,
    MFMailComposeViewControllerDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *settingTitles;
@property (nonatomic, strong) NSMutableArray *settingImages;

@property (nonatomic, strong) NSString *royLinkedInURL;
@property (nonatomic, strong) NSString *kevoyeLinkedInURL;

@property (nonatomic, strong) NSString *shareText;
@property (nonatomic, strong) NSString *appStoreReviewURL;

@end

@implementation SettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configure];
}

-(void)configure
{
    [self initializeArrays];
    [self initializeLinkedInURLs];
    [self configureTableView];
    
    self.shareText = @"Give the right tip, quickly!";
    self.appStoreReviewURL = @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/"
                             "wa/viewContentsUserReviews?type=Purple+Software&id=1136691499";
}

-(void)initializeArrays
{
    self.settingTitles = [[NSMutableArray alloc] init];
    [self.settingTitles addObject:@"Love Just The Tip? Give us a Review!"];
    [self.settingTitles addObject:@"Have something to tell us? Give us a shout!"];
    [self.settingTitles addObject:@"Have friends? Share Just The Tip with them!"];
    
    UIImage *rateImage = [UIImage imageNamed:@"reviewIcon"];
    UIImage *messageImage = [UIImage imageNamed:@"sendMail"];
    UIImage *shareImage = [UIImage imageNamed:@"shareIcon"];
    
    self.settingImages = [[NSMutableArray alloc] init];
    [self.settingImages addObject:rateImage];
    [self.settingImages addObject:messageImage];
    [self.settingImages addObject:shareImage];
}

-(void)initializeLinkedInURLs
{
    self.kevoyeLinkedInURL = @"https://www.linkedin.com/in/kevoye-boswell-5376a7101";
    self.royLinkedInURL = @"https://www.linkedin.com/in/royjossfolk";
    
}

-(void)configureTableView
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 2;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *spacingView = [[UIView alloc] init];
    spacingView.backgroundColor = self.view.backgroundColor;
    
    return spacingView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SettingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingCell"];
    
    cell.settingImage.image = self.settingImages[indexPath.section];
    cell.titleLabel.text = self.settingTitles[indexPath.section];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:true];
    
    switch (indexPath.section)
    {
        // Review
        case 0:
            [self showReviewPage];
            break;
        
        // Message
        case 1:
            [self showEmailView];
            break;
        
        // Share
        case 2:
            [self showShareSheet];
            break;
    }
}

-(void)showReviewPage
{
    [self openURLNamed:self.appStoreReviewURL];
}

-(void)mailComposeController:(MFMailComposeViewController *)controller
         didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [controller dismissViewControllerAnimated:true completion:nil];
}

-(void)showEmailView
{
    if ([MFMailComposeViewController canSendMail])
    {
        NSString *iosVersion = [UIDevice currentDevice].systemVersion;
        NSString *recipient = @"JustTheTip@gmail.com";
        NSString *subject = [NSString stringWithFormat:@"JustTheTip Feedback %@", iosVersion];
        
        MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
        mailController.mailComposeDelegate = self;
        mailController.title = @"JustTheTip Feedback";
        [mailController setSubject:subject];
        [mailController setToRecipients:@[recipient]];
        
        [self presentViewController:mailController animated:true completion:nil];
    }
}

-(void)showShareSheet
{
    UIActivityViewController *activityController = [[UIActivityViewController alloc]
        initWithActivityItems:@[self.shareText, self.appStoreReviewURL] applicationActivities:nil];
    
    [self presentViewController:activityController animated:true completion:nil];
}

-(IBAction)royButtonTapped:(UIButton *)royButton
{
    [self openURLNamed: self.royLinkedInURL];
}

-(IBAction)kevoyeButtonTapped:(UIButton *)kevoyeButton
{
    [self openURLNamed: self.kevoyeLinkedInURL];
}

-(void)openURLNamed:(NSString *)urlString
{
    NSURL *url = [NSURL URLWithString:urlString];
    
    [[UIApplication sharedApplication] openURL:url];
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
