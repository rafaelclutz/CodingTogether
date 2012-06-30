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
    
    // Soma (+)
    if ([@"+" isEqualToString:operation]){
        result = [self popOperand] + [self popOperand];
    // Subtração (-)
    } else if ([@"-" isEqualToString:operation]){
        double subtrahend = [self popOperand];
        result = [self popOperand] - subtrahend;
    // Multiplicação (*)
    } else if ([@"*" isEqualToString:operation]){
        result = [self popOperand] * [self popOperand];        
    // Divisão (/)
    } else if ([@"/" isEqualToString:operation]){
        double divisor = [self popOperand];
        if (divisor) result = [self popOperand] / divisor;
    // Seno (sin)    
    } else if ([@"sin" isEqualToString:operation]){
        result = sin([self popOperand]);
    // Coseno (cos)
    } else if ([@"cos" isEqualToString:operation]){
        result = cos([self popOperand]);
    // Raiz Quadrada (√)
    } else if ([@"√" isEqualToString:operation]){
        result = sqrt([self popOperand]);
    // PI (π)
    } else if ([@"π" isEqualToString:operation]){
        result = M_PI;
    }
    
    [self pushOperand:result];
    return result;
}

@end
