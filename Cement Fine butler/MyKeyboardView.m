//
//  MyKeyboardView.m
//  Cement Fine butler
//
//  Created by 文正光 on 13-10-23.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import "MyKeyboardView.h"

@implementation MyKeyboardView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)insertText:(NSString *)text {
    // Do something with the typed character
}
- (void)deleteBackward {
    // Handle the delete key
}
- (BOOL)hasText {
    // Return whether there's any text present
    return YES;
}
- (BOOL)canBecomeFirstResponder {
    return YES;
}

@end
