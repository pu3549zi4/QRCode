//
//  QRGenerator.h
//  dsf
//
//  Created by Xmart on 16/9/1.
//  Copyright © 2016年 Paul.Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface QRGenerator : NSObject

+ (UIImage *) getQRImageWithContent:(NSString *)content red:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue;

@end
