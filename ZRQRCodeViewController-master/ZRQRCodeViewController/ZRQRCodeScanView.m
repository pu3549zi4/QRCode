//
//  ZRCodeScanView.m
//  ZRQRCodeViewController
//
//  Created by Victor John on 7/1/16.
//  Copyright © 2016 XiaoRuiGeGe. All rights reserved.
//
//  https://github.com/VictorZhang2014/ZRQRCodeViewController
//  An open source library for iOS in Objective-C that is being compatible with iOS 7.0 and later.
//  Its main function that QR Code Scanning framework that are easier to call.
//

#import "ZRQRCodeScanView.h"
#import "ZRQRCodeController.h"
#import "ZRAlertController.h"

@interface ZRQRCodeScanView()
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UIView *scanFrame;
@property (nonatomic, strong) UIImageView *imgScanLine;
@property (nonatomic, assign) BOOL isUp;
@property (nonatomic, assign) CGRect imgScanLineFrame;
 
@property (nonatomic, strong) UIViewController *lastViewController;
@property (nonatomic, copy) NSString *domain;
@end

@implementation ZRQRCodeScanView

- (void)openQRCodeScan:(UIViewController *)viewController
{
    self.lastViewController = viewController;
    [self setFrame:self.lastViewController.view.frame];
    viewController.hidesBottomBarWhenPushed = YES;
    self.backgroundColor = [UIColor clearColor];
    
    ZRQRCodeViewController *qrCode = [[ZRQRCodeViewController alloc] initWithScanType:ZRQRCodeScanTypeContinuation customView:self navigationBarTitle:@"QRCode Scan"];
    qrCode.VCTintColor = [UIColor whiteColor];
    __weak typeof(self) wself = self;
    [qrCode QRCodeScanningWithViewController:self.lastViewController completion:^(NSString *strValue) {
        NSLog(@"QRCode Scan Result = %@ ", strValue);
        [[ZRAlertController defaultAlert] alertShow:wself.lastViewController title:@"QRCode Result" message:[NSString stringWithFormat:@"QRCode Result：%@", strValue] okayButton:@"OK" completion:^{
            
        }];
    }];
    [self addSomeView:qrCode.view.frame];
    [self showTabbar];
}

- (void)addSomeView:(CGRect)rect
{
    CGFloat bTxtHeight = 50;
    CGFloat bTxtY = rect.size.height - bTxtHeight - 61 * 2;
    UILabel *bottomText = [[UILabel alloc] initWithFrame:CGRectMake(0, bTxtY, rect.size.width, bTxtHeight)];
    [bottomText setText:@"Align to the frame"];
    [bottomText setTextColor:[UIColor whiteColor]];
    [bottomText setFont:[UIFont systemFontOfSize:19]];
    [bottomText setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:bottomText];
    
    CGFloat sfX = 20;
    CGFloat sfY = sfX * 6;
    CGFloat sfW = rect.size.width - sfX * 2;
    UIView *scanFrame = [[UIView alloc] initWithFrame:CGRectMake(sfX, sfY, sfW, sfW)];
    scanFrame.layer.borderColor = [UIColor clearColor].CGColor;
    scanFrame.layer.borderWidth = 1;
    [self addSubview:scanFrame];
    self.scanFrame = scanFrame;
    
    CGFloat slX = 3;
    CGFloat slY = 2;
    CGFloat slW = scanFrame.frame.size.width - slX - slY;
    CGFloat slH = 8;
    UIImageView *scanLine = [[UIImageView alloc] initWithFrame:CGRectMake(slX, slY, slW, slH)];
    [scanLine setImage:[UIImage imageNamed:@"QRCodeScanLine"]];
    [scanFrame addSubview:scanLine];
    
    self.imgScanLineFrame = scanLine.frame;
    self.isUp = YES;
    self.imgScanLine = scanLine;
    [self upAndDownScanLine];
//    __weak typeof(self) wself = self;
//    self.timer = [NSTimer timerWithTimeInterval:0.4 target:wself selector:@selector(upAndDownScanLine) userInfo:nil repeats:YES];
//    [self.timer fire];
//    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
}

- (void)drawRect:(CGRect)rect
{
    CGFloat length = 27;
    CGRect sfRect = _scanFrame.frame;
    CGFloat blue[4] = { (float)50 / 255, (float)205 / 255, (float)50 / 255, 1 };
    CGFloat white[4] = { (float)255 / 255, (float)255 / 255, (float)255 / 255, 1 };
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetLineCap(ctx, kCGLineCapRound); 
    CGContextSetLineJoin(ctx, kCGLineJoinRound);
    
    CGContextSetStrokeColor(ctx, white);
    CGContextSetLineWidth(ctx, 1.5);
    
    //左边线
    CGContextMoveToPoint(ctx, sfRect.origin.x, sfRect.origin.y + length);
    CGContextAddLineToPoint(ctx, sfRect.origin.x, sfRect.origin.y + sfRect.size.height - length);
    CGContextStrokePath(ctx);
    
    //底部边线
    CGContextMoveToPoint(ctx, sfRect.origin.x + length, sfRect.origin.y + sfRect.size.height);
    CGContextAddLineToPoint(ctx, sfRect.origin.x + sfRect.size.width - length, sfRect.origin.y + sfRect.size.height);
    CGContextStrokePath(ctx);
    
    //右边线
    CGContextMoveToPoint(ctx, sfRect.origin.x + sfRect.size.width, sfRect.origin.y + length);
    CGContextAddLineToPoint(ctx, sfRect.origin.x + sfRect.size.width, sfRect.origin.y + sfRect.size.height - length);
    CGContextStrokePath(ctx);
    
    //上边线
    CGContextMoveToPoint(ctx, sfRect.origin.x + sfRect.size.width - length, sfRect.origin.y);
    CGContextAddLineToPoint(ctx, sfRect.origin.x + length, sfRect.origin.y);
    CGContextStrokePath(ctx);
    
    CGContextSetStrokeColor(ctx, blue);
    CGContextSetLineWidth(ctx, 6);
    
    //左上角
    CGContextMoveToPoint(ctx, sfRect.origin.x + length, sfRect.origin.y);
    CGContextAddLineToPoint(ctx, sfRect.origin.x, sfRect.origin.y);
    CGContextAddLineToPoint(ctx, sfRect.origin.x, sfRect.origin.y + length);
    CGContextStrokePath(ctx);
    
    //左下角
    CGContextMoveToPoint(ctx, sfRect.origin.x, sfRect.origin.y + sfRect.size.height - length);
    CGContextAddLineToPoint(ctx, sfRect.origin.x, sfRect.origin.y + sfRect.size.height);
    CGContextAddLineToPoint(ctx, sfRect.origin.x + length, sfRect.origin.y + sfRect.size.height);
    CGContextStrokePath(ctx);
    
    //右下角
    CGContextMoveToPoint(ctx, sfRect.origin.x + sfRect.size.width - length, sfRect.origin.y + sfRect.size.height);
    CGContextAddLineToPoint(ctx, sfRect.origin.x + sfRect.size.width, sfRect.origin.y + sfRect.size.height);
    CGContextAddLineToPoint(ctx, sfRect.origin.x +  + sfRect.size.width, sfRect.origin.y + sfRect.size.height - length);
    CGContextStrokePath(ctx);
    
    //右上角
    CGContextMoveToPoint(ctx, sfRect.origin.x + sfRect.size.width - length, sfRect.origin.y);
    CGContextAddLineToPoint(ctx, sfRect.origin.x + sfRect.size.width, sfRect.origin.y);
    CGContextAddLineToPoint(ctx, sfRect.origin.x + sfRect.size.width, sfRect.origin.y + length);
    CGContextStrokePath(ctx);
}

//扫描滚动条，上上下下持续滚动
- (void)upAndDownScanLine
{
    [UIView animateWithDuration:0.4 animations:^{
        CGRect rect = self.imgScanLine.frame;
        CGRect rect1 = self.scanFrame.frame;
        if (self.isUp) {
            self.isUp = NO;
            rect.origin.y = rect1.size.height - rect.origin.y * 2;
            self.imgScanLine.frame = rect;
        } else {
            self.isUp = YES;
            self.imgScanLine.frame = self.imgScanLineFrame;
        }
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self upAndDownScanLine];
    });
}

- (void)dealloc
{
    [self abolishTimer];
}

- (void)abolishTimer
{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)showTabbar
{
    self.lastViewController.hidesBottomBarWhenPushed = NO;
}

@end
