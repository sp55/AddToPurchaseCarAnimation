//
//  CustomCell.h
//  Test
//
//  Created by admin on 16/1/19.
//  Copyright © 2016年 AlezJi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AddObjectBlock)();
typedef void(^RemoveObjectBlock)();

@interface CustomCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UIButton *removeBtn;
- (IBAction)addAction:(id)sender;
- (IBAction)removeAction:(id)sender;

@property(nonatomic,copy) AddObjectBlock addBlock;
@property(nonatomic,copy) RemoveObjectBlock removeBlock;



@end
