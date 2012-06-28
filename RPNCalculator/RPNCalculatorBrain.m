//
//  RPNCalculatorBrain.m
//  RPNCalculator
//
//  Created by Rafael Lutz on 27/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RPNCalculatorBrain.h"

@interface RPNCalculatorBrain()
@property (nonatomic, strong) NSMutableArray *operandStack; 
@end

@implementation RPNCalculatorBrain

@synthesize operandStack = _operandStack;

// getter
-(NSMutableArray *)operandStack{
    if (_operandStack == nil) _operandStack = [[NSMutableArray alloc] init];
    return _operandStack;
}

-(void)pushOperand:(double)operand{
    [self.operandStack addObject:[NSNumber numberWithDouble:operand]];
}

-(double)popOperand {
    NSNumber *operandObject = [self.operandStack lastObject];
    if (operandObject) [self.operandStack removeLastObject];
    return [operandObject doubleValue];
}

-(double)performOperation:(NSString *)operation{
    double result = 0;
    
    // calcular o resultado
    if ([@"+" isEqualToString:operation]){
        result = [self popOperand] + [self popOperand];
    } else if ([@"-" isEqualToString:operation]){
        double subtrahend = [self popOperand];
        result = [self popOperand] - subtrahend;
    } else if ([@"*" isEqualToString:operation]){
        result = [self popOperand] * [self popOperand];        
    } else if ([@"/" isEqualToString:operation]){
        double divisor = [self popOperand];
        if (divisor) result = [self popOperand] / divisor;
    }
    
    [self pushOperand:result];
    return result;
}

@end
