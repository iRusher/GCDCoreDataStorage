//
//  RSMessageCell.m
//  ConcurrencyCoreData
//
//  Created by yonglang on 13-7-25.
//  Copyright (c) 2013年 iRusher. All rights reserved.
//

#import "RSMessageCell.h"

@implementation RSMessageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setMessage:(Message *)message
{
    _message = message;
    
    self.textLabel.text = message.from;
    self.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %@",message.text,message.timestamp];
    
    [self setNeedsDisplay];
}

-(void)drawRect:(CGRect)rect
{
    
    CGContextRef context  = UIGraphicsGetCurrentContext();
    
    BOOL isRead = self.message.isRead.boolValue;
    
    CGRect indicatorFrame = CGRectMake(CGRectGetWidth(self.bounds)-20, 10, 10, 10);
    if (isRead) {
        [[UIColor greenColor] set];
    }else{
        [[UIColor redColor] set];
    }
    CGContextFillEllipseInRect(context, indicatorFrame);
    
}

@end
