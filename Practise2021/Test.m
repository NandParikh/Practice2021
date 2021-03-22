//
//  Test.m
//  Practise2021
//
//  Created by Nand Parikh on 22/03/21.
//

#import "Test.h"
//https://www.youtube.com/watch?v=YeyiDDkfk2Y
@implementation Test
@synthesize strTest;

-(void)printdata {
    strTest = @"This is from Objective C File";
    NSLog(@"%@", strTest);
    
    
}
@end
