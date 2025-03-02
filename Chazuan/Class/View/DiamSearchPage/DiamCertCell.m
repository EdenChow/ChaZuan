//
//  DiamCertCell.m
//  Chazuan
//
//  Created by BecksZ on 2019/7/5.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "DiamCertCell.h"

@interface DiamCertCell ()

/// viewModel
@property (nonatomic, readwrite, strong) CertItemViewModel *viewModel;

@property (nonatomic, readwrite, strong) NSArray *titleArr;
@property (nonatomic, readwrite, strong) NSMutableArray *btns;

@property (nonatomic, readwrite, strong) UILabel *label;

@end

@implementation DiamCertCell

#pragma mark - Public Method
+ (instancetype)cellWithTableView:(UITableView *)tableView style:(UITableViewCellStyle)style {
    static NSString *ID = @"DiamCertCell";
    DiamCertCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) cell = [[self alloc] initWithStyle:style reuseIdentifier:ID];;
    return cell;
}

- (void)bindViewModel:(CertItemViewModel *)viewModel {
    self.viewModel = viewModel;
    @weakify(self);
    [[RACObserve(viewModel, selectArr) takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(NSArray *selectArr) {
        @strongify(self);
        NSMutableArray *titleArr = [NSMutableArray arrayWithArray:[viewModel.selectTitle componentsSeparatedByString:@"，"]];
        [titleArr removeLastObject];
        for (int i = 0; i < selectArr.count; i++) {
            BOOL select = [selectArr[i] boolValue];
            ZGButton *btn = self.btns[i];
            btn.selected = select;
            // 处理title
            NSString *name = self.titleArr[i];
            if (select) {
                if (![titleArr containsObject:name])
                    [titleArr addObject:name];
            } else {
                if ([titleArr containsObject:name])
                    [titleArr removeObject:name];
            }
        }
        if (titleArr.count > 0)
            viewModel.selectTitle = [[titleArr componentsJoinedByString:@"，"] stringByAppendingString:@"，"];
        else
            viewModel.selectTitle = @"";
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

#pragma mark - 辅助方法
- (void)_setup {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.clipsToBounds = YES;
    self.clipsToBounds = YES;
    self.titleArr = @[@"GIA",@"IGI",@"HRD",@"NGTC",@"Other"];
    self.btns = [NSMutableArray array];
}

- (void)_setupSubviews {
    UILabel *label = [[UILabel alloc] init];
    label.font = kFont(15);
    label.textColor = kHexColor(@"#1C2B36");
    label.text = @"证书机构";
    self.label = label;
    [self.contentView addSubview:label];
    
    for (int i = 0; i < self.titleArr.count; i++) {
        ZGButton *btn = [ZGButton buttonWithType:UIButtonTypeCustom];
        btn.layer.borderColor = COLOR_LINE.CGColor;
        btn.layer.borderWidth = 1;
        [btn setBackgroundImage:[UIImage imageWithColor:kHexColor(@"#3882FF")] forState:UIControlStateSelected];
        [btn setBackgroundImage:[UIImage imageWithColor:UIColor.whiteColor] forState:UIControlStateNormal];
        [btn setTitleColor:kHexColor(@"#1C2B36") forState:UIControlStateNormal];
        [btn setTitleColor:UIColor.whiteColor forState:UIControlStateSelected];
        [btn.titleLabel setFont:kFont(14)];
        [btn setTitle:self.titleArr[i] forState:UIControlStateNormal];
        [self.contentView addSubview:btn];
        [self.btns addObject:btn];
        
        @weakify(self);
        [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(ZGButton *sender) {
            @strongify(self);
            sender.selected = !sender.selected;
            [self.viewModel.clickSub sendNext:[RACTuple tupleWithObjects:@(i),@(sender.selected), nil]];
        }];
    }
}

- (void)_setupSubviewsConstraint {
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.contentView).offset(ZGCConvertToPx(10));
        make.width.mas_equalTo(ZGCConvertToPx(73));
        make.bottom.mas_equalTo(self.contentView).multipliedBy(0.5);
    }];
    
    ZGButton *tempBtn, *flourBtn;
    for (int i = 0; i < self.btns.count; i++) {
        ZGButton *btn = self.btns[i];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            if (i%4 == 0) {
                make.left.mas_equalTo(self.contentView).offset(ZGCConvertToPx(83));
            } else {
                make.left.mas_equalTo(tempBtn.mas_right).offset(ZGCConvertToPx(10));
                if (i%4 == 3)
                    make.right.mas_equalTo(self.contentView.mas_right).offset(ZGCConvertToPx(-10));
            }
            if (i/4 == 0) {
                make.top.mas_equalTo(self.contentView).offset(ZGCConvertToPx(6));
            } else {
                if (i%4==0)
                    make.top.mas_equalTo(flourBtn.mas_bottom).offset(ZGCConvertToPx(12));
                else
                    make.top.mas_equalTo(flourBtn);
                if (i == self.btns.count-1)
                    make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(ZGCConvertToPx(-6));
            }
            if (tempBtn) make.size.mas_equalTo(tempBtn);
        }];
        tempBtn = btn;
        if (i%4 == 0) flourBtn = btn;
    }
}

@end
