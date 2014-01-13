//
//  CSRootViewController.m
//  CSNotificationViewDemo
//
//  Created by Christian Schwarz on 01.09.13.
//  Copyright (c) 2013 Christian Schwarz. Check LICENSE.md.
//

#import "CSRootViewController.h"
#import "CSNotificationView.h"

@interface CSRootViewController ()

@property (nonatomic, strong) CSNotificationView* permanentNotification;

@end

@implementation CSRootViewController

- (IBAction)showError:(id)sender {
    [CSNotificationView showInViewController:self
                                       style:CSNotificationViewStyleError
                                     message:@"A critical error happened."];
}
- (IBAction)showSuccess:(id)sender {
    [CSNotificationView showInViewController:self
                                       style:CSNotificationViewStyleSuccess
                                     message:@"Great, it works."];
}

- (IBAction)showCustom:(id)sender {
    [CSNotificationView showInViewController:self
            tintColor:[UIColor colorWithRed:0.000 green:0.6 blue:1.000 alpha:1]
                image:nil
              message:@"No icon and a message that needs two rows and extra \
                        presentation time to be displayed properly."
             duration:5.8f];
    
}

- (IBAction)showPermanent:(id)sender
{
    if (self.permanentNotification) {
        return;
    }
    
    self.permanentNotification =
        [CSNotificationView notificationViewWithParentViewController:self
            tintColor:[UIColor colorWithRed:0.000 green:0.6 blue:1.000 alpha:1]
                image:nil message:@"I am running for two seconds."];
    
    [self.permanentNotification setShowingActivity:YES];
    
    UITapGestureRecognizer *tapHandler = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    
    __block typeof(self) weakself = self;
    [self.permanentNotification setVisible:YES animated:YES tapHandler:tapHandler completion:^{

        weakself.navigationItem.rightBarButtonItem =
                [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                 style:UIBarButtonItemStyleDone
                                                target:weakself
                                                action:@selector(cancel)];
        
        double delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [weakself success];
        });
        
    }];
}

- (void)cancel
{
    self.navigationItem.rightBarButtonItem = nil;
    [self.permanentNotification dismissWithStyle:CSNotificationViewStyleError
                                         message:@"Cancelled"
                                        duration:kCSNotificationViewDefaultShowDuration animated:YES];
    self.permanentNotification = nil;
    
}

- (void)success
{
    self.navigationItem.rightBarButtonItem = nil;
    [self.permanentNotification dismissWithStyle:CSNotificationViewStyleSuccess
                                             message:@"Sucess!"
                                            duration:kCSNotificationViewDefaultShowDuration animated:YES];
    self.permanentNotification = nil;
}

#pragma mark tap handling
- (void)handleTap:(UITapGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        [self.permanentNotification setVisible:NO animated:YES tapHandler:nil completion:nil];
    }
}

@end
