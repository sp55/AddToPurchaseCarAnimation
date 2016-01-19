//
//  CustomViewController.m
//  Test
//
//  Created by admin on 16/1/19.
//  Copyright © 2016年 AlezJi. All rights reserved.
//

#import "CustomViewController.h"
#import "CustomCell.h"
static NSString *cellStr = @"custom";
@interface CustomViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) UIBezierPath *path;
@property (nonatomic,strong) CALayer *dotLayer;
@property (nonatomic,assign) CGFloat endPointX;
@property (nonatomic,assign) CGFloat endPointY;
@end

@implementation CustomViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    
    _endPointX = _bottomView.frame.origin.x + _bottomView.frame.size.width/2;
    _endPointY = _bottomView.frame.origin.y + 35;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 30;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"CustomCell" owner:self options:nil]lastObject];
    }
    cell.selectionStyle  = UITableViewCellSelectionStyleNone;
    
    __weak __typeof(&*cell) weakCell =cell;
    cell.addBlock = ^{
        NSLog(@"add");
        CGRect parentRect = [weakCell convertRect:weakCell.addBtn.frame toView:self.view];

        [self JoinCartAnimationWithRect:parentRect];

    };
    
    cell.removeBlock = ^{
        NSLog(@"remove");
    };
    
    return cell;
}
#pragma mark -加入购物车动画
-(void) JoinCartAnimationWithRect:(CGRect)rect
{
    
    CGFloat startX = rect.origin.x;
    CGFloat startY = rect.origin.y;
    
    _path= [UIBezierPath bezierPath];
    [_path moveToPoint:CGPointMake(startX, startY)];
    //三点曲线
    [_path addCurveToPoint:CGPointMake(_endPointX, _endPointY)
             controlPoint1:CGPointMake(startX, startY)
             controlPoint2:CGPointMake(startX - 180, startY - 200)];
    
    _dotLayer = [CALayer layer];
    _dotLayer.backgroundColor = [UIColor redColor].CGColor;
    _dotLayer.frame = CGRectMake(0, 0, 15, 15);
    _dotLayer.cornerRadius = (15 + 15) /4;
    [self.view.layer addSublayer:_dotLayer];
    [self groupAnimation];
    
}
#pragma mark - 组合动画
-(void)groupAnimation
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.path = _path.CGPath;
    animation.rotationMode = kCAAnimationRotateAuto;
    
    CABasicAnimation *alphaAnimation = [CABasicAnimation animationWithKeyPath:@"alpha"];
    alphaAnimation.duration = 0.5f;
    alphaAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    alphaAnimation.toValue = [NSNumber numberWithFloat:0.1];
    alphaAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CAAnimationGroup *groups = [CAAnimationGroup animation];
    groups.animations = @[animation,alphaAnimation];
    groups.duration = 0.8f;
    groups.removedOnCompletion = NO;
    groups.fillMode = kCAFillModeForwards;
    groups.delegate = self;
    [groups setValue:@"groupsAnimation" forKey:@"animationName"];
    [_dotLayer addAnimation:groups forKey:nil];

    
    [self performSelector:@selector(removeFromLayer:) withObject:_dotLayer afterDelay:0.8f];
    
}
- (void)removeFromLayer:(CALayer *)layerAnimation{
    
    [layerAnimation removeFromSuperlayer];
}

#pragma mark - CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    
//    if ([[anim valueForKey:@"animationName"]isEqualToString:@"groupsAnimation"]) {
//        
//        CABasicAnimation *shakeAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
//        shakeAnimation.duration = 0.25f;
//        shakeAnimation.fromValue = [NSNumber numberWithFloat:0.9];
//        shakeAnimation.toValue = [NSNumber numberWithFloat:1];
//        shakeAnimation.autoreverses = YES;
//        [_ShopCartView.shoppingCartBtn.layer addAnimation:shakeAnimation forKey:nil];
//    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
