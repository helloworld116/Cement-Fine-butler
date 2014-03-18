//
//  ElecPopupView.m
//  Cement Fine butler
//
//  Created by 文正光 on 14-2-22.
//  Copyright (c) 2014年 河南丰博自动化有限公司. All rights reserved.
//

#import "ElecPopupView.h"
@interface ElecPopupView()<UITextFieldDelegate>
@property (nonatomic,retain) IBOutlet UITextField *textValue;
@property (nonatomic,retain) IBOutlet UIImageView *topImgView;
@property (nonatomic,retain) IBOutlet UIImageView *bottomImgView;
-(IBAction)setUserValue:(id)sender;
@end

@implementation ElecPopupView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithDefaultValue:(double)defaultValue{
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"ElecPopupView" owner:self options:nil] objectAtIndex:0];
        self.textValue.delegate = self;
        self.textValue.text = [NSString stringWithFormat:@"%.2f",defaultValue];
    }
    return self;
}

-(void)setDefaultValue:(double)defaultVale{
    self.textValue.text = [NSString stringWithFormat:@"%.2f",defaultVale];
}

//- (id)

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */
-(IBAction)setUserValue:(id)sender{
    //     self.value = [Tool doubleValue:self.textValue.text];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"elecCustomUnitCost" object:[NSNumber numberWithDouble:[Tool doubleValue:self.textValue.text]]];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [textField selectAll:self];
    NSTimeInterval animationDuration = 0.30f;
    CGRect frame = self.superview.frame;
    //如果屏幕已经上移过，就不上移。
    if (frame.origin.y < 0){
        return;
    }
    frame.origin.y -=80;
    //    frame.size.height +=216;
    
    [UIView beginAnimations:@"ResizeView" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    self.superview.frame = frame;
    [UIView commitAnimations];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    //当用户按下ruturn，把焦点从textField移开那么键盘就会消失了
    NSTimeInterval animationDuration = 0.30f;
    CGRect frame = self.superview.frame;
    frame.origin.y +=80;
    //    frame.size. height -=216;
    //self.view移回原位置
    [UIView beginAnimations:@"ResizeView" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.superview.frame = frame;
    [UIView commitAnimations];
    [textField resignFirstResponder];
    return YES;
}
@end
