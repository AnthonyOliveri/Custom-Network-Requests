//
//  ViewController.m
//  CustomNetworkAnalytics
//
//  Created by Anthony Oliveri on 4/17/15.
//  Copyright (c) 2015 IBM. All rights reserved.
//

#import "ViewController.h"
#import "OCLogger.h"
#import "WLResourceRequest.h"
#import "WLResponse.h"

@interface ViewController ()

@end

@implementation ViewController


- (IBAction)pingGoogleMaps:(UIButton *)sender {
    NSURLRequest* myRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.google.com/maps"]];
    [NSURLConnection sendAsynchronousRequest:myRequest queue:[NSOperationQueue currentQueue] completionHandler:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
