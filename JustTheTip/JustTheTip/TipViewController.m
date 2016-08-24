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
@property (nonatomic) double billAmount;

@property (nonatomic) BOOL wasKeyboardShowing;

@end

@implementation TipViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configure];
}

-(void)configure
{
    [[UITextField appearance] setTintColor:[UIColor whiteColor]];
    [[UITextField appearance] setTextColor:[UIColor whiteColor]];
    
    // create and array for percentages
    self.tipPercentageArray = @[@0.15, @0.18, @0.20];
    
    //change bill amount text label so it is blank
    self.billAmountTextField.text = @"";
    
    [self addRecognizerToHideKeyboard];
    
    [self setDefaultTextInBillField];
    
    self.prevBillAmountText = @"$0.00";
    self.tipPercentage = 0.18;
    
    [self initializeColors];
    
    self.peopleCount = 1;
    self.billAmount = 0;
    
    self.billAmountTextField.keyboardAppearance = UIKeyboardAppearanceDark;
    [self.billAmountTextField becomeFirstResponder];
}

-(void)initializeColors
{
    self.purpleColor = [UIColor colorWithRed:243.0/255.0 green:115.0/255 blue:255.0/255.0 alpha:1];
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
    [self calculateTipAndUpdateLabels];
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
    self.billAmountTextField.text = [self formatBillAmountString: billAmountString];
    
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
    NSString *defaultText = @"$0.00";
    self.billAmountTextField.text = defaultText;
}

-(NSString *)formatBillAmountString:(NSString *)billString
{
    double billValue = [self doubleValueFromBillField];
    
    if (![self wasBackspaceTappedInBillField])
    {
        billValue *= 10;
    }
    else
    {
        billValue /= 10;
    }
    
    NSNumber *billValueNumber = [NSNumber numberWithDouble:billValue];
    return [[self currencyFormatter] stringFromNumber:billValueNumber];
}

-(double)doubleValueFromBillField
{
    NSString *billAmountString = self.billAmountTextField.text;
    
    NSNumber *billNumber = [[self currencyFormatter] numberFromString:billAmountString];
    
    return billNumber.doubleValue;
}

-(NSNumberFormatter *)currencyFormatter
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterCurrencyStyle;
    
    return formatter;
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
    if (self.peopleCount < 10)
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

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
