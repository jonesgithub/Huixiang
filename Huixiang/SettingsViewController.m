//
//  SettingsViewController.m
//  cartoon
//
//  Created by  on 12-5-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SettingsViewController.h"
#import <MessageUI/MFMailComposeViewController.h>
#import <MessageUI/MessageUI.h>
#import "Settings.h"

@interface SettingsViewController ()<MFMailComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UISwitch *sinaWeiboBindingSwitch;
@property (weak, nonatomic) IBOutlet UILabel *weiboNameLabel;
@end

@implementation SettingsViewController
@synthesize sinaWeiboBindingSwitch=_sinaWeiboBindingSwitch;

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self=[super initWithCoder:aDecoder];
    if(self){
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"设置" image:nil tag:0];
        [[self tabBarItem] setFinishedSelectedImage:[UIImage imageNamed:@"settings.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"settings.png"]];
        [[self tabBarItem] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                   [UIColor colorWithRed:150.0f/255.0f green:150.0f/255.0f blue:150.0f/255.0f alpha:1.0f], UITextAttributeTextColor,
                                                   nil] forState:UIControlStateNormal];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

-(void)viewWillAppear:(BOOL)animated
{
    self.weiboNameLabel.text=[Settings getUser][@"name"];
    BOOL notBind=[[NSUserDefaults standardUserDefaults]boolForKey:@"notbind"];
    if(notBind){
        self.sinaWeiboBindingSwitch.on=NO;
    }else{
        self.sinaWeiboBindingSwitch.on=YES;
    }
  }

- (IBAction)cancel:(id)sender {
    [self.presentingViewController dismissModalViewControllerAnimated:YES];
}

- (IBAction)changeAccount:(id)sender {
    [self performSegueWithIdentifier:@"auth" sender:self];

}


- (IBAction)bind:(UISwitch *)sender {
    if(sender.on){
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"notbind"];
    }else{
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"notbind"];
    }
    [[NSUserDefaults standardUserDefaults]synchronize];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==1&&indexPath.row==1){
       
    }else if(indexPath.section==3&&indexPath.row==0){
        [self sendMail];
    }else if(indexPath.section==3&&indexPath.row==1){
        [self goToRating];
    }
}

-(void)goToRating
{
    NSString *REVIEW_URL = @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=602955052&onlyLatestVersion=true&type=Purple+Software";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:REVIEW_URL]];
}


-(void)sendMail
{
    if([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
        picker.navigationBar.tintColor=[UIColor blackColor];
        picker.mailComposeDelegate = self;
        [picker setSubject:@"let's party反馈意见"];
        [picker setToRecipients:[NSArray arrayWithObjects:@"yucong1118@gmail.com", nil]];
        [self presentModalViewController:picker animated:YES];
    }else{
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"您还没有设置邮件帐号" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
        [alert show];
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error 
{   
    // Notifies users about errors associated with the interface
    NSString* message=nil;
    switch (result)
    {
        case MFMailComposeResultCancelled:
            break;
        case MFMailComposeResultSaved:
            message=@"已存储草稿";
            break;
        case MFMailComposeResultSent:
            message=@"邮件已添加至发送队列";
            break;
        case MFMailComposeResultFailed:
            message=@"发送失败";
            break;
        default:
            break;
    }
    [self dismissModalViewControllerAnimated:YES];
    if(message){
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:message message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
        [alert show];
    }
}


- (void)viewDidUnload
{
    [self setSinaWeiboBindingSwitch:nil];
    [self setWeiboNameLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end