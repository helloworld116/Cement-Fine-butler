//
//  CostDetailVC.m
//  Cement Fine butler
//
//  Created by 文正光 on 14-2-17.
//  Copyright (c) 2014年 河南丰博自动化有限公司. All rights reserved.
//

#import "CostDetailVC.h"
#import "CostDetailView.h"

@interface CostDetailVC ()<UIScrollViewDelegate>
//顶部控件
@property (nonatomic,strong) IBOutlet UIView *topOfView;//头部容器
@property (nonatomic,strong) IBOutlet UILabel *lblValue;//节约或损失的数值


//中间部分控件
@property (nonatomic,strong) IBOutlet UIView *middleView;
@property (nonatomic,strong) PPiFlatSegmentedControl *segmented;

//底部控件
@property (nonatomic,strong) IBOutlet UIScrollView *bottomScrollView;
@end

@implementation CostDetailVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.title = @"成本详情";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"return_icon"] highlightedImage:[UIImage imageNamed:@"return_click_icon"] target:self action:@selector(pop:)];
    self.bottomScrollView.pagingEnabled = YES;
    self.bottomScrollView.showsHorizontalScrollIndicator = NO;
    self.bottomScrollView.bounces = NO;
    self.bottomScrollView.delegate = self;
    [self addMiddleView:@[]];
    [self addBottomView:@[@"",@"",@""]];
}

- (void)addMiddleView:(NSArray *)products{
    self.segmented =[[PPiFlatSegmentedControl alloc] initWithFrame:CGRectMake(7, 0, kScreenWidth-14, 38) items:@[@{@"text":@"Face"},                                                                          @{@"text":@"Linkedin"},
         @{@"text":@"Twitter"}] iconPosition:IconPositionRight andSelectionBlock:^(NSUInteger segmentIndex) {
             self.bottomScrollView.contentOffset=CGPointMake(segmentIndex*kScreenWidth, 0);
         }];
    self.segmented.color=[UIColor whiteColor];
    self.segmented.borderWidth=1;
    self.segmented.borderColor=[Tool hexStringToColor:@"#e0d7c6"];
    self.segmented.selectedColor=[Tool hexStringToColor:@"#e8e5df"];
    self.segmented.textAttributes=@{NSFontAttributeName:[UIFont systemFontOfSize:18],
                                    NSForegroundColorAttributeName:[Tool hexStringToColor:@"#c3c6c9"]};
    self.segmented.selectedTextAttributes=@{NSFontAttributeName:[UIFont systemFontOfSize:18],
                                            NSForegroundColorAttributeName:[Tool hexStringToColor:@"#3f4a58"]};
    [self.middleView addSubview:self.segmented];
}
    
-(void)addBottomView:(NSArray *)products{
    CGSize scrollViewSize = self.bottomScrollView.frame.size;
    CGFloat contentHeight = kScreenHeight-self.topOfView.frame.size.height-self.middleView.frame.size.height-kNavBarHeight-kTabBarHeight-kStatusBarHeight;
    self.bottomScrollView.contentSize = CGSizeMake(scrollViewSize.width*products.count, contentHeight);
    CostDetailView *costDetailView;
    for (int i=0; i<products.count; i++) {
        costDetailView = [[[NSBundle mainBundle] loadNibNamed:@"CostDetailView" owner:self options:nil] objectAtIndex:0];
        costDetailView.frame = CGRectMake(scrollViewSize.width*i, 0, scrollViewSize.width, scrollViewSize.height);
        [self.bottomScrollView addSubview:costDetailView];
    }
}
    
#pragma mark - UIScrollViewDelegate
    
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger page = scrollView.contentOffset.x / pageWidth;
    [self.segmented setEnabled:YES forSegmentAtIndex:page];
}
    
-(void)pop:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
    
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
