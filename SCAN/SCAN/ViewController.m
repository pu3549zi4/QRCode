//
//  ViewController.m
//  SCAN
//
//  Created by Xmart on 16/8/29.
//  Copyright © 2016年 Paul.Chen. All rights reserved.
//

#import "ViewController.h"
#import "ZRQRCodeController.h"
#import "QRCodeGenerator.h"
#import "QRGenerator.h"

@interface ViewController ()
//返回警告框
- (IBAction)QRCodeScanning1:(UIButton *)sender;
//无返回，继续扫描
- (IBAction)QRCodeScanning2:(UIButton *)sender;
//相册选码
- (IBAction)recognizationByPhotoLibrary:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIImageView *qrcodePicture;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.stringForQC = @"www.baidu.com";
    [self configBasis];
    [self recognizationByLongPressImage];
}

- (void)configBasis {
    self.navigationItem.title = NSLocalizedString(@"二维码", nil);
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"更换图片", nil) style:UIBarButtonItemStylePlain target:self action:@selector(changeQCInImageView)];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:38.0 / 255.0f green:169.0 / 255.0f blue:28.0f / 255.0f alpha:1];
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIColor whiteColor],
                                NSForegroundColorAttributeName, nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    [self preferredStatusBarStyle];
}

- (void)changeQCInImageView {
    //方法1
    UIImage *image1 = [QRCodeGenerator qrImageForString:self.stringForQC imageSize:_qrcodePicture.bounds.size.height];
    //方法2
    UIImage *image2 = [QRGenerator getQRImageWithContent:self.stringForQC red:arc4random()%256 green:arc4random()%256 blue:arc4random()%256];

//    _qrcodePicture.image = image1;
    _qrcodePicture.image = image2;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)recognizationByLongPressImage {
    ZRQRCodeViewController *qrCode = [[ZRQRCodeViewController alloc] initWithScanType:ZRQRCodeScanTypeReturn];
    qrCode.cancelButton = @"Cancel";
    qrCode.actionSheets = @[];
    qrCode.extractQRCodeText = @"Extract QR Code";
    NSString *savedImageText = @"Save Image";
    qrCode.saveImaegText = savedImageText;
    [qrCode extractQRCodeByLongPressViewController:self Object:self.qrcodePicture actionSheetCompletion:^(int index, NSString * _Nonnull value) {
        if ([value isEqualToString:savedImageText]) {
            [[ZRAlertController defaultAlert] alertShow:self title:@"" message:@"Saved Image Successfully!" okayButton:@"Ok" completion:^{ }];
        }
    } completion:^(NSString * _Nonnull strValue) {
        NSLog(@"strValue = %@ ", strValue);
        [[ZRAlertController defaultAlert] alertShow:self title:@"" message:[NSString stringWithFormat:@"Result: %@", strValue] okayButton:@"Ok" completion:^{
            if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:strValue]]){
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:strValue]];
            } else {
                UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"Ooooops!" message:[NSString stringWithFormat:@"The result is %@", strValue] preferredStyle:UIAlertControllerStyleAlert];
                [alertVC addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"确认", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    NSLog(@"确认!");
                }]];
                [self presentViewController:alertVC animated:YES completion:nil];
            }
        }];
    }];
}

- (IBAction)QRCodeScanning1:(UIButton *)sender {
    ZRQRCodeViewController *qrCode = [[ZRQRCodeViewController alloc] initWithScanType:ZRQRCodeScanTypeReturn];
    qrCode.qrCodeNavigationTitle = @"QR Code Scanning";
    [qrCode QRCodeScanningWithViewController:self completion:^(NSString *strValue) {
        NSLog(@"strValue = %@ ", strValue);
        if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:strValue]]){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:strValue]];
        } else {
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"Ooooops!" message:[NSString stringWithFormat:@"The result is %@", strValue] preferredStyle:UIAlertControllerStyleAlert];
            [alertVC addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"确认", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSLog(@"确认!");
            }]];
            [self presentViewController:alertVC animated:YES completion:nil];
        }
    }];
}

- (IBAction)QRCodeScanning2:(UIButton *)sender {
    ZRQRCodeViewController *qrCode = [[ZRQRCodeViewController alloc] initWithScanType:ZRQRCodeScanTypeContinuation];
    [qrCode QRCodeScanningWithViewController:self completion:^(NSString *strValue) {
        NSLog(@"strValue = %@ ", strValue);
        if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:strValue]]){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:strValue]];
        } else {
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"Ooooops!" message:[NSString stringWithFormat:@"The result is %@", strValue] preferredStyle:UIAlertControllerStyleAlert];
            [alertVC addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"确认", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSLog(@"确认!");
            }]];
            [self presentViewController:alertVC animated:YES completion:nil];
        }
    }];
}

- (IBAction)recognizationByPhotoLibrary:(UIButton *)sender {
    ZRQRCodeViewController *qrCode = [[ZRQRCodeViewController alloc] initWithScanType:ZRQRCodeScanTypeReturn];
    [qrCode recognizationByPhotoLibraryViewController:self completion:^(NSString *strValue) {
        NSLog(@"strValue = %@ ", strValue);
        [[ZRAlertController defaultAlert] alertShow:self title:@"" message:[NSString stringWithFormat:@"Result: %@", strValue] okayButton:@"Ok" completion:^{
            if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:strValue]]){
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:strValue]];
            } else {
                UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"Ooooops!" message:[NSString stringWithFormat:@"The result is %@", strValue] preferredStyle:UIAlertControllerStyleAlert];
                [alertVC addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"确认", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    NSLog(@"确认!");
                }]];
                [self presentViewController:alertVC animated:YES completion:nil];
            }
        }];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
