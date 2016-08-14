//
//  TipViewController.m
//  JustTheTip
//
//  Created by HotBox Creative on 2/8/16.
//  Copyright © 2016 Roy Jossfolk Inc. All rights reserved.
//

#import "TipViewController.h"

@interface TipViewController ()

@property (weak, nonatomic) IBOutlet UITextField *billAmountTextField;
@property (weak, nonatomic) IBOutlet UITextField *tipAmountTextField;
@property (weak, nonatomic) IBOutlet UITextField *totalAmountTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *percentSegments;

@property (strong, nonatomic) NSArray *tipPercentageArray;

@end

@implementation TipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[UITextField appearance] setTintColor:[UIColor whiteColor]];
    [[UITextField appearance] setTextColor:[UIColor whiteColor]];
    
    // create and array for percentages
    self.tipPercentageArray = @[@0.15, @0.18, @0.20];
    
    // remove tip percentage segements created in interface builder
    while(self.percentSegments.numberOfSegments > 0) {
        [self.percentSegments removeSegmentAtIndex:0 animated:NO];
    }
    
    // use the array of percentages to populate the segmented controller
    for (int i = 0; i < self.tipPercentageArray.count; i++) {
        
        NSNumber *numberInArray = self.tipPercentageArray[i];
        
        NSString *numberString = [NSString stringWithFormat:@"%.0f%%", numberInArray.doubleValue * 100];
        
        [self.percentSegments insertSegmentWithTitle:numberString atIndex:i animated:NO];
        
    }
    
    // select one of the segments of the segment controller
    [self.percentSegments setSelectedSegmentIndex:0];
    
    //change bill amount text label so it is blank
    self.billAmountTextField.text = @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)calculateTipAndUpdateLabels {
    //get the NSNumber out of the array
    NSNumber *tipPercentageNumber = self.tipPercentageArray [[self.percentSegments selectedSegmentIndex]];
    
    //configure the variables to do the math
    double billAmount = self.billAmountTextField.text.doubleValue;
    double tipPercentage = tipPercentageNumber.doubleValue;
    
    //do the math
    double tipAmount = billAmount * tipPercentage;
    double totalAmount = tipAmount + billAmount;
    
    //Update the labels in the view
    self.tipAmountTextField.text = [NSString stringWithFormat:@"$%.2f", tipAmount];
    self.totalAmountTextField.text = [NSString stringWithFormat:@"$%.2f", totalAmount];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
