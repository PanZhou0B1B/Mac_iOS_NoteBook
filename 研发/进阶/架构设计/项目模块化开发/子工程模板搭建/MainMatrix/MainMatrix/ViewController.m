//
//  ViewController.m
//  MainMatrix
//
//  Created by zhoupanpan on 2017/7/19.
//  Copyright © 2017年 panzhow. All rights reserved.
//

#import "ViewController.h"
#import <AccountDemo/MainFile.h>
#import <FillSub/FillFile.h>
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setu${DEVICE_DIR}/${FMK_NAME}p after loading the view, typically from a nib.
    [MainFile log];
    [FillFile log];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
