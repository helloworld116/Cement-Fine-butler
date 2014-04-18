//
//  IntroductionVC.m
//  Cement Fine butler
//
//  Created by 文正光 on 14-4-14.
//  Copyright (c) 2014年 河南丰博自动化有限公司. All rights reserved.
//

#import "IntroductionVC.h"
#import "LastIntroductionPanel.h"

@interface IntroductionVC ()

@end

@implementation IntroductionVC

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
    NSHomeDirectory();
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self buildIntro];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Build MYBlurIntroductionView

-(void)buildIntro{
    CGRect fullSrceenRect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
//    [UIImage imageNamed:@"introduction1_"]
    MYIntroductionPanel *panel1 = [[MYIntroductionPanel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) title:nil description:nil image:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"introduction1_" ofType:@".png"]]];
    MYIntroductionPanel *panel2 = [[MYIntroductionPanel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) title:nil description:nil image:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"introduction2_" ofType:@".png"]]];
    MYIntroductionPanel *panel3 = [[MYIntroductionPanel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) title:nil description:nil image:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"introduction3_" ofType:@".png"]]];
    MYIntroductionPanel *panel4 = [[MYIntroductionPanel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) title:nil description:nil image:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"introduction4_" ofType:@".png"]]];
    panel1.PanelImageView.frame = fullSrceenRect;
    panel2.PanelImageView.frame = fullSrceenRect;
    panel3.PanelImageView.frame = fullSrceenRect;
    panel4.PanelImageView.frame = fullSrceenRect;
    panel1.PanelSeparatorLine.hidden = YES;
    panel2.PanelSeparatorLine.hidden = YES;
    panel3.PanelSeparatorLine.hidden = YES;
    panel4.PanelSeparatorLine.hidden = YES;
    //Create Panel From Nib
//    MYIntroductionPanel *panel5 = [[MYIntroductionPanel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) nibNamed:@"TestPanel3"];
    
    //Create custom panel with events
    LastIntroductionPanel *panel5 = [[LastIntroductionPanel alloc] initWithFrame:fullSrceenRect];
    
    //Add panels to an array
    NSArray *panels = @[panel1, panel2, panel3, panel4, panel5];
    
    //Create the introduction view and set its delegate
    MYBlurIntroductionView *introductionView = [[MYBlurIntroductionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    introductionView.delegate = self;
    introductionView.PageControl.hidden =YES;
    introductionView.RightSkipButton.hidden = YES;
    [introductionView setBackgroundColor:[UIColor whiteColor]];
    //introductionView.LanguageDirection = MYLanguageDirectionRightToLeft;
    
    //Build the introduction with desired panels
    [introductionView buildIntroductionWithPanels:panels];
    
    //Add the introduction to your view
    [self.view addSubview:introductionView];
}

@end
