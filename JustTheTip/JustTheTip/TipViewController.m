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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[UITextField appearance] setTintColor:[UIColor whiteColor]];
    [[UITextField appearance] setTextColor:[UIColor whiteColor]];
    
    // create and array for percentages
    self.tipPercentageArray = @[@0.15, @0.18, @0.20];
    
    // select one of the segments of the segment controller
    [self.percentSegments setSelectedSegmentIndex:0];
    
    //change bill amount text label so it is blank
    self.billAmountTextField.text = @"";
    
    [self addRecognizerToHideKeyboard];
}

-(void)addRecognizerToHideKeyboard
{
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
        action:@selector(hideKeyboard)];
    
    [self.view addGestureRecognizer:tapRecognizer];
}

- (IBAction)percentSegmentChanged:(id)sender
{
    [self hideKeyboard];
    
    [self calculateTipAndUpdateLabels];
}

- (IBAction)billAmountChanged:(id)sender
{
    [self calculateTipAndUpdateLabels];
}

-(void)calculateTipAndUpdateLabels
{
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

-(void)hideKeyboard
{
    [self.view endEditing:YES];
}

@end
