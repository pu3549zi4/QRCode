//
//  ViewController.m
//  dsf
//
//  Created by Xmart on 16/9/1.
//  Copyright © 2016年 Paul.Chen. All rights reserved.
//

#import "ViewController.h"
#import "QRGenerator.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(changeImage) userInfo:nil repeats:YES];
}

- (void)changeImage {
    self.imageView.image = [QRGenerator getQRImageWithContent:@"www.baidu.com" red:arc4random()%256 green:arc4random()%256 blue:arc4random()%256];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
