//
//  DPNavigationController.m
//  DPTomate
//
//  Created by 土老帽 on 16/4/11.
//  Copyright © 2016年 DPRuin. All rights reserved.
//

#import "DPNavigationController.h"

@interface DPNavigationController ()

@end

@implementation DPNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 导航栏背景颜色
    self.navigationBar.barTintColor = DPBackgroundColor;
    
    // 导航栏标题颜色
    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : DPOrangeColor};
    
    // 导航栏字体颜色
    self.navigationBar.tintColor = DPOrangeColor;
    
    
}

/**
 *  设置电量条样式
 */
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
