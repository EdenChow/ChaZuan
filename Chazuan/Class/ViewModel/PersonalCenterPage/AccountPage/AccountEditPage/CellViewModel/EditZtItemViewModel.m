//
//  EditZtItemViewModel.m
//  Chazuan
//
//  Created by BecksZ on 2019/7/23.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "EditZtItemViewModel.h"
#import "EditZtCell.h"

@implementation EditZtItemViewModel

- (instancetype)init {
    if (self = [super init]) {
        self.shouldEdited = YES;
        self.tableViewCellClass = EditZtCell.class;
    }
    return self;
}

@end
