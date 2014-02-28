//
//  MessageCell.h
//  Cement Fine butler
//
//  Created by 文正光 on 13-9-28.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblTime;
@property (strong, nonatomic) IBOutlet UILabel *lblContent;

//-(void)setlblTitleText:(NSString *)title;
@end
