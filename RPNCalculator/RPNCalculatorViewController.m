//
//  RPNCalculatorViewController.m
//  RPNCalculator
//
//  Created by Rafael Lutz on 27/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RPNCalculatorViewController.h"
#import "RPNCalculatorBrain.h"

@interface RPNCalculatorViewController ()
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic) BOOL userEnteredADecimal;
@property (nonatomic, strong) RPNCalculatorBrain *brain;
@property (weak, nonatomic) IBOutlet UILabel *stackDisplay;
@end

@implementation RPNCalculatorViewController
@synthesize display = _display;
@synthesize stackDisplay = _stackDisplay;
@synthesize userIsInTheMiddleOfEnteringANumber = _userIsInTheMiddleOfEnteringANumber;
@synthesize brain = _brain;
@synthesize userEnteredADecimal = _userEnteredADecimal;

// Lazy instatiation
-(RPNCalculatorBrain *)brain {
    if (!_brain) _brain = [[RPNCalculatorBrain alloc] init];
    return _brain;
}

- (IBAction)digitPressed:(UIButton *)sender {
    [self delIsResultIndicator];
    
    NSString *digit = [sender currentTitle];
    if (self.userIsInTheMiddleOfEnteringANumber){
        self.display.text = [self.display.text stringByAppendingString:digit];        
    } else {
        self.display.text = digit;
        self.userIsInTheMiddleOfEnteringANumber = YES;
    }
}

- (IBAction)operationPressed:(UIButton *)sender {
    if (self.userIsInTheMiddleOfEnteringANumber) [self enterPressed];
    
    [self delIsResultIndicator];
    
    // reset
    self.userEnteredADecimal = NO;
    
    // Test to remove starting '0'
    NSString *stackDisplayString = self.stackDisplay.text;
    if ([stackDisplayString isEqualToString:@"0"]) {
        self.stackDisplay.text = sender.currentTitle;
    } else {
        self.stackDisplay.text = [stackDisplayString stringByAppendingFormat:@" %@", sender.currentTitle];
    }
    
    [self setIsResultIndicator];
    
    double result = [self.brain performOperation:sender.currentTitle];
    NSString *resultString = [NSString stringWithFormat:@"%g", result];
    self.display.text = resultString;
}

- (IBAction)enterPressed {
    NSString *displayString = self.display.text;
    NSString *stackDisplayString = self.stackDisplay.text;
    
    // pega a exceção do usuário digitar . depois Enter ;)
    if ([displayString isEqualToString:@"."]) return;

    if ([stackDisplayString isEqualToString:@"0"]){
        self.stackDisplay.text = displayString;
    } else {
        self.stackDisplay.text = [stackDisplayString stringByAppendingFormat:@" %@", displayString];
    }
    
    // reset
    self.userIsInTheMiddleOfEnteringANumber = NO;
    self.userEnteredADecimal = NO;
    
    [self.brain pushOperand:[self.display.text doubleValue]];
}
- (IBAction)clearPressed {
    // clear booleans
    self.userEnteredADecimal = NO;
    self.userIsInTheMiddleOfEnteringANumber = NO;
    
    // clear the displays
    self.display.text = @"0";
    self.stackDisplay.text = @"0";
    
    // call the clear operation
    [self.brain performOperation:@"CLEAR"];
}
- (IBAction)backspacePressed {
    int tamanho = self.display.text.length;
    
    // se o tamanho for maior que 1
    if (tamanho > 1){
        self.display.text = [self.display.text substringToIndex:tamanho - 1];        
    }
}
- (IBAction)plusMinusPressed {
    NSString *displayString = self.display.text;
    
    // Add or remove leading "-" from string 
    if ([displayString compare:@"-" options:0 range:NSMakeRange(0, 1)] == NSOrderedSame)
    {
        // Return substring after the "-" 
        self.display.text = [displayString substringFromIndex:(1)];
    } else {
        // Prepend "-" to displayString 
        self.display.text = [NSString stringWithFormat:@"-%@", displayString];
    }
}

- (void) setIsResultIndicator; {
    NSString *sumSignLong = @" =";
    NSRange posOfSumSign = [self.stackDisplay.text rangeOfString:sumSignLong];
    if (posOfSumSign.location == NSNotFound) {
        self.stackDisplay.text = [self.stackDisplay.text stringByAppendingString:sumSignLong];
    }
}

- (void) delIsResultIndicator; {
    NSString *sumSignLong = @" =";
    NSRange posOfSumSign = [self.stackDisplay.text rangeOfString:sumSignLong];
    if (posOfSumSign.location != NSNotFound) {
        self.stackDisplay.text = [self.stackDisplay.text substringToIndex:posOfSumSign.location];
    }
    
}

- (IBAction)decimalPressed {
    // deleta o = se e;e estiver no display histórico
    [self delIsResultIndicator];
    
    // se o usuário já pressionou o . ele nao pode mais colocar
    if (self.userEnteredADecimal){
        return;
    } else {
        if (self.userIsInTheMiddleOfEnteringANumber){
            self.display.text = [self.display.text stringByAppendingString:@"."];
        } else {
            self.display.text = @"0.";
            self.userIsInTheMiddleOfEnteringANumber = YES;
        }
        
        // indica que o usuário já pressionou o .
        self.userEnteredADecimal = YES;
    }
    
    
}

- (void)viewDidUnload {
    [self setStackDisplay:nil];
    [super viewDidUnload];
}
@end
