//
//  SettingsViewController.m
//  JustTheTip
//
//  Created by Kevoye Boswell on 8/22/16.
//  Copyright © 2016 Roy Jossfolk Inc. All rights reserved.
//

#import "SettingsViewController.h"
#import "SettingCell.h"

@interface SettingsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *settingTitles;
@property (nonatomic, strong) NSMutableArray *settingImages;

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
    [self configureTableView];
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
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
