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
@property (weak, nonatomic) IBOutlet UILabel *peopleCountLabel;

@property (weak, nonatomic) IBOutlet UIButton *fifteenPercentButton;
@property (weak, nonatomic) IBOutlet UIButton *eightteenPercentButton;
@property (weak, nonatomic) IBOutlet UIButton *twentyPercentButton;

@property (strong, nonatomic) NSString *prevBillAmountText;
@property (strong, nonatomic) NSArray *tipPercentageArray;
@property (nonatomic) double tipPercentage;

@property (strong, nonatomic) UIColor *purpleColor;
@property (strong, nonatomic) UIColor *grayColor;
@property (nonatomic) int peopleCount;

@end

@implementation TipViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[UITextField appearance] setTintColor:[UIColor whiteColor]];
    [[UITextField appearance] setTextColor:[UIColor whiteColor]];
    
    // create and array for percentages
    self.tipPercentageArray = @[@0.15, @0.18, @0.20];
    
    //change bill amount text label so it is blank
    self.billAmountTextField.text = @"";
    
    [self addRecognizerToHideKeyboard];
    
    [self setDefaultTextInBillField];
    self.prevBillAmountText = @"$0.0";
    self.tipPercentage = 0.18;
    
    [self initializeColors];
    
    self.peopleCount = 1;
}

-(void)initializeColors
{
    self.purpleColor = [UIColor colorWithRed:243.0/255.0 green:115.0/255.0 blue:255.0/255.0 alpha:1];
    self.grayColor = [UIColor colorWithRed:139.0/255.0 green:139.0/255.0 blue:139.0/255.0 alpha:1];
}

-(void)addRecognizerToHideKeyboard
{
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
        action:@selector(hideKeyboard)];
    
    [self.view addGestureRecognizer:tapRecognizer];
}

-(void)viewDidAppear:(BOOL)animated
{
    [self.billAmountTextField becomeFirstResponder];
}

- (IBAction)billAmountChanged:(UITextField *)textField
{
    BOOL shouldHideCursor = ![self wasBackspaceTappedInBillField];
    
    if (shouldHideCursor)
    {
        [self hideBillAmountTextFieldCursor];
    }
    else
    {
        [self showBillAmountTextFieldCursor];
    }
    
    if ([self wasBackspaceTappedInBillField])
    {
        if (textField.text.length < 4)
        {
            [self setDefaultTextInBillField];
        }
    }
    
    NSString *billAmountString = self.billAmountTextField.text;
    self.billAmountTextField.text = [self formatNumberString: billAmountString];
    
    [self calculateTipAndUpdateLabels];
    
    self.prevBillAmountText = textField.text;
}

-(BOOL)wasBackspaceTappedInBillField
{
    NSString *currentText = self.billAmountTextField.text;
    
    if (currentText.length < self.prevBillAmountText.length)
    {
        return true;
    }
    
    return false;
}

-(void)setDefaultTextInBillField
{
    NSString *defaultText = @"$0.0";
    self.billAmountTextField.text = defaultText;
}

-(NSString *)formatNumberString:(NSString *)numberString
{
    NSMutableString *formattedString = [numberString stringByReplacingOccurrencesOfString:@","
                                       withString:@""].mutableCopy;
    if ([self wasBackspaceTappedInBillField])
    {
        if ([formattedString hasPrefix:@"$0.0"])
        {
            return formattedString;
        }
        
        if (numberString.length >= 4)
        {
            formattedString = [numberString stringByReplacingOccurrencesOfString:@"."
                              withString:@""].mutableCopy;
            
            // Add decimal point
            int decimalIndex = (int)(numberString.length - 3);
            [formattedString insertString:@"." atIndex:decimalIndex];
        }
        
        if (numberString.length == 4)
        {
            // Insert initial zero
            formattedString = [formattedString stringByReplacingOccurrencesOfString:@"$."
                              withString:@"$0."].mutableCopy;
        }
        
        return formattedString;
    }
    
    if (numberString.length > 5)
    {
        formattedString = [numberString stringByReplacingOccurrencesOfString:@"."
                          withString:@""].mutableCopy;
        
        // Add decimal point
        int decimalIndex = (int)(numberString.length - 3);
        [formattedString insertString:@"." atIndex:decimalIndex];
    }
    
    if (formattedString.length >= 6)
    {
        // Remove initial zero
        formattedString = [formattedString stringByReplacingOccurrencesOfString:@"$0"
                          withString:@"$"].mutableCopy;
    }
    
    return formattedString;
}

-(void)hideBillAmountTextFieldCursor
{
    self.billAmountTextField.tintColor = [UIColor clearColor];
}

-(void)showBillAmountTextFieldCursor
{
    self.billAmountTextField.tintColor = [UIColor whiteColor];
}

-(void)calculateTipAndUpdateLabels
{
    double billAmount = [self doubleValueFromBillField];
    
    //do the math
    double tipAmount = (billAmount * self.tipPercentage)/self.peopleCount;
    double totalAmount = (tipAmount + billAmount)/self.peopleCount;
    
    //Update the labels in the view
    self.tipAmountTextField.text = [NSString stringWithFormat:@"$%.2f", tipAmount];
    self.totalAmountTextField.text = [NSString stringWithFormat:@"$%.2f", totalAmount];
}

-(double)doubleValueFromBillField
{
    NSMutableString *doubleString = self.billAmountTextField.text.mutableCopy;
    
    doubleString = [doubleString stringByReplacingOccurrencesOfString:@"$"
                   withString:@""].mutableCopy;
    
    return doubleString.doubleValue;
}

-(IBAction)fifteenPercentTapped:(UIButton *)button
{
    self.tipPercentage = 0.15;
    [self configurePercentageButtonColors];
    [self hideKeyboard];
    [self calculateTipAndUpdateLabels];
}

-(IBAction)eighteenPercentTapped:(UIButton *)button
{
    self.tipPercentage = 0.18;
    [self configurePercentageButtonColors];
    [self hideKeyboard];
    [self calculateTipAndUpdateLabels];
}


-(IBAction)twentyPercentTapped:(UIButton *)button
{
    self.tipPercentage = 0.20;
    [self configurePercentageButtonColors];
    [self hideKeyboard];
    [self calculateTipAndUpdateLabels];
}

-(IBAction)upButtonPressed:(UIButton *)button
{
    self.peopleCount = self.peopleCountLabel.text.intValue;
    
    if (self.peopleCount < 100)
    {
        self.peopleCount++;
        [self updatePeopleLabelWithCount];
    }
    
    [self calculateTipAndUpdateLabels];
    [self hideKeyboard];
}

-(IBAction)downButtonPressed:(UIButton *)button
{
    self.peopleCount = self.peopleCountLabel.text.intValue;
    
    if (self.peopleCount > 1)
    {
        self.peopleCount--;
        [self updatePeopleLabelWithCount];
    }
    
    [self calculateTipAndUpdateLabels];
    [self hideKeyboard];
}

-(void)updatePeopleLabelWithCount
{
    self.peopleCountLabel.text = [NSString stringWithFormat:@"%d", self.peopleCount];
    if (self.peopleCount < 9)
    {
        self.peopleCountLabel.text = [NSString stringWithFormat:@"0%d", self.peopleCount];
    }
}

-(void)configurePercentageButtonColors
{
    self.fifteenPercentButton.titleLabel.textColor = self.grayColor;
    self.eightteenPercentButton.titleLabel.textColor = self.grayColor;
    self.twentyPercentButton.titleLabel.textColor = self.grayColor;
    
    if (self.tipPercentage == 0.15)
        [self.fifteenPercentButton setTitleColor:self.purpleColor forState:UIControlStateNormal];
    else if (self.tipPercentage == 0.18)
        [self.eightteenPercentButton setTitleColor:self.purpleColor forState:UIControlStateNormal];
    else if (self.tipPercentage == 0.20)
        [self.twentyPercentButton setTitleColor:self.purpleColor forState:UIControlStateNormal];
}

-(void)hideKeyboard
{
    [self.view endEditing:YES];
    [self showBillAmountTextFieldCursor];
}

@end
