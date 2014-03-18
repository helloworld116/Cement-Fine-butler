//
//  ElecView.h
//  Cement Fine butler
//
//  Created by 文正光 on 14-3-7.
//  Copyright (c) 2014年 河南丰博自动化有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ElecView : UIView
@property (nonatomic) int selectIndex;
- (id)initWithFrame:(CGRect)frame withData:(NSArray *)data;
-(void)setupValue:(NSArray *)data;
@end


@interface ElecProductView : UIView
- (id)initWithFrame:(CGRect)frame withData:(NSDictionary *)data;
@end