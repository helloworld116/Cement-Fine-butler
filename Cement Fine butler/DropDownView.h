//
//  DropDownView.h
//  Cement Fine butler
//
//  Created by 文正光 on 14-2-11.
//  Copyright (c) 2014年 河南丰博自动化有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DropDownView;
@protocol DropDownViewDeletegate <NSObject>

-(void)dropDownDelegateMethod:(DropDownView *)sender;

@end

@interface DropDownView : UIView<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic) int timeType;
@property (nonatomic,strong) UIButton *hiddenBtn;
@property (nonatomic,assign) id<DropDownViewDeletegate> delegate;
-(void)hideDropDown:(UIButton *)btn;
-(id)initWithDropDown:(UIButton *)btn height:(CGFloat)height list:(NSArray *)list;
@end

@interface DropDownTableViewCell : UITableViewCell
@property (nonatomic,strong) UILabel *lblText;
@end
