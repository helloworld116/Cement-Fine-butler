//
//  CoalPopupView.m
//  Cement Fine butler
//
//  Created by 文正光 on 14-2-22.
//  Copyright (c) 2014年 河南丰博自动化有限公司. All rights reserved.
//

#import "CoalPopupView.h"
@interface CoalPopupView()<UITextFieldDelegate>
@property (nonatomic,retain) IBOutlet UILabel *lblInternational;
@property (nonatomic,retain) IBOutlet UIImageView *imgViewInternational;
@property (nonatomic,retain) IBOutlet UILabel *lblInternal;
@property (nonatomic,retain) IBOutlet UIImageView *imgViewInternal;

@property (nonatomic,retain) IBOutlet UILabel *lblIndustry;
@property (nonatomic,retain) IBOutlet UIImageView *imgViewIndustry;

@property (nonatomic,retain) IBOutlet UILabel *lblCustom;
@property (nonatomic,retain) IBOutlet UIImageView *imgViewCustom;
@property (nonatomic,retain) IBOutlet UITextField *textValue;

-(IBAction)selectedInternational:(id)sender;
-(IBAction)selectedInternal:(id)sender;
-(IBAction)selectedIndustry:(id)sender;
-(IBAction)selectedCustom:(id)sender;
-(IBAction)sureChoice:(id)sender;

@property (nonatomic) NSInteger currentSelectIndex;
@property (nonatomic) NSNumber *internationalCoalUnitAmount;
@property (nonatomic) NSNumber *countryCoalUnitAmount;
@end

@implementation CoalPopupView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id) initWithCoalInfo:(NSDictionary *)coal{
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"CoalPopupView" owner:self options:nil] objectAtIndex:0];
        
        self.internationalCoalUnitAmount = [NSNumber numberWithDouble:[Tool doubleValue:[coal objectForKey:@"internationalCoalUnitAmount"]]];
        self.countryCoalUnitAmount = [NSNumber numberWithDouble:[Tool doubleValue:[coal objectForKey:@"countryCoalUnitAmount"]]];;
        double customCoalUnitAmount = [Tool doubleValue:[coal objectForKey:@"customCoalUnitAmount"]];
        self.lblInternational.text = [NSString stringWithFormat:@"国际煤耗对标（%@公斤/吨）",self.internationalCoalUnitAmount];
        self.lblInternal.text = [NSString stringWithFormat:@"国内煤耗对标（%@公斤/吨）",self.countryCoalUnitAmount];
        self.lblIndustry.text = [NSString stringWithFormat:@"业界平均煤耗对标（功能暂未开放）"];
        self.lblCustom.text = [NSString stringWithFormat:@"自定义（公斤/吨）"];
        self.textValue.text = [NSString stringWithFormat:@"%.2f",customCoalUnitAmount];
        self.textValue.delegate = self;
        self.currentSelectIndex = 3;//默认选中自定义
    }
    return self;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [self updateImageView:3];
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

-(void)textFieldDidEndEditing:(UITextField *)textField{
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
}

-(IBAction)selectedInternational:(id)sender{
    [self updateImageView:0];
}

-(IBAction)selectedInternal:(id)sender{
    [self updateImageView:1];
}


-(IBAction)selectedIndustry:(id)sender{
//    [self updateImageView:2];
}


-(IBAction)selectedCustom:(id)sender{
    [self updateImageView:3];
}


-(IBAction)sureChoice:(id)sender{
    NSNumber *value;
    switch (self.currentSelectIndex) {
        case 0:
            value = self.internationalCoalUnitAmount;
            break;
        case 1:
            value = self.countryCoalUnitAmount;
            break;
        case 2:
            
            break;
        case 3:
            value = [NSNumber numberWithDouble:[Tool doubleValue:self.textValue.text]];
            break;
        default:
            break;
    }
    NSDictionary *data = @{@"selectedIndex":@(self.currentSelectIndex),@"value":value};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"coalCustomUnitCost" object:data];
}

-(void)updateImageView:(NSInteger)selectIndex{
    if (self.currentSelectIndex!=selectIndex) {
        UIImage *unselectImage = [UIImage imageNamed:@"hollowdots_icon"];
        switch (self.currentSelectIndex) {
            case 0:
                self.imgViewInternational.image = unselectImage;
                break;
            case 1:
                self.imgViewInternal.image = unselectImage;
                break;
            case 2:
                
                break;
            case 3:
                self.imgViewCustom.image = unselectImage;
                break;
                
            default:
                break;
        }
        self.currentSelectIndex = selectIndex;
        UIImage *selectImage = [UIImage imageNamed:@"soliddots_icon"];
        switch (selectIndex) {
            case 0:
                [self.textValue resignFirstResponder];
                self.imgViewInternational.image = selectImage;
                break;
            case 1:
                [self.textValue resignFirstResponder];
                self.imgViewInternal.image = selectImage;
                break;
            case 2:
                
                break;
            case 3:
                self.imgViewCustom.image = selectImage;
                break;
                
            default:
                break;
        }
    }
}
@end
