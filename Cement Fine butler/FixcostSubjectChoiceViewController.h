//
//  FixcostSubjectChoiceViewController.h
//  Cement Fine butler
//
//  Created by 文正光 on 13-10-31.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PassValueDelegate.h"

@interface FixcostSubjectChoiceViewController : UITableViewController
@property(nonatomic,assign) NSObject<PassValueDelegate> *delegate;
@property (nonatomic) long subjectId;
@end
