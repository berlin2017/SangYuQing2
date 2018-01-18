//
//  UserScoreLogTableViewCell.m
//  SangYuQing
//
//  Created by mac on 2018/1/8.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "UserScoreLogTableViewCell.h"
#import "JiFenDetailModel.h"

@interface UserScoreLogTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *order_label;
@property (weak, nonatomic) IBOutlet UILabel *time_label;
@property (weak, nonatomic) IBOutlet UILabel *value_label;

@end

@implementation UserScoreLogTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)configWithModel:(JiFenDetailModel*)model{
    _name.text = model.remark;
    _order_label.text = model.order_numer;
    NSString *type;
    if ([model.type isEqualToString:@"0"]) {
        type = @"-";
    }else{
        type = @"";
    }
    _value_label.text = [NSString stringWithFormat:@"%@%@积分",type,model.point_value];
    
    _time_label.text = [self formateTime:model.add_time];
}

-(NSString*)formateTime:(NSString* )time{
    NSDateFormatter *stampFormatter = [[NSDateFormatter alloc] init];
    [stampFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    //以 1970/01/01 GMT为基准，然后过了secs秒的时间
    NSDate *stampDate2 = [NSDate dateWithTimeIntervalSince1970:[time intValue]];
    return [stampFormatter stringFromDate:stampDate2];
}

@end
