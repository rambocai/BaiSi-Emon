//
//  ZYMeCell.m
//  ZYBS
//
//  Created by 竹雨 on 2017/7/4.
//  Copyright © 2017年 竹雨. All rights reserved.
//

#import "ZYMeCell.h"

@implementation ZYMeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.textLabel.textColor = [UIColor darkGrayColor];
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        //self.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow"]];
        self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mainCellBackground"]];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.imageView.image == nil) return;
    
    // imageView
    self.imageView.zy_y = ZYSmallMargin;
    self.imageView.zy_height = self.contentView.zy_height - 2 * ZYSmallMargin;
    self.imageView.zy_width = self.imageView.zy_height;
    
    // label
    self.textLabel.zy_x = self.imageView.zy_right + ZYMargin;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
