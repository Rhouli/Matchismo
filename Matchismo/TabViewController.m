//
//  TabViewController.m
//  Matchismo
//
//  Created by Ryan on 5/6/14.
//  Copyright (c) 2014 Ryan Houlihan. All rights reserved.
//

#import "TabViewController.h"
#import "CardGameAppDelegate.h"

@interface TabViewController ()

@end

@implementation TabViewController

- (BOOL)shouldAutorotate {
    CardGameAppDelegate *delegate= (CardGameAppDelegate*)[[UIApplication sharedApplication] delegate];
    return [delegate.tabBarController.selectedViewController shouldAutorotate];
}


- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

@end
@end
