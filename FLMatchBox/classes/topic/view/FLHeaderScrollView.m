//
//  FLHeaderScrollView.m
//  FLMatchBox
//
//  Created by asddfg on 16/3/24.
//  Copyright © 2016年 fabian. All rights reserved.
//

#import "FLHeaderScrollView.h"

@interface FLHeaderScrollView ()<UIScrollViewDelegate>

@property (nonatomic, weak) UIPageControl *page;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation FLHeaderScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        
        self.alpha = 0.5;
        //scorllview
        UIScrollView *scrollview = [[UIScrollView alloc]initWithFrame:self.bounds];
        _scrollView = scrollview;
        _scrollView.delegate = self;
        [self addSubview:scrollview];
        
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.bounces = NO;
        
        //page
        UIPageControl *page = [[UIPageControl alloc]initWithFrame:CGRectMake(self.bounds.size.width - 100, self.bounds.size.height - 25, 100, 20)];
        _page.numberOfPages = 0;
        _page = page;
        [self addSubview:page];
        
        
    }
    return self;
}

- (void)setItemsArr:(NSArray *)itemsArr
{
    _page.numberOfPages = itemsArr.count;
    
    NSMutableArray *muArr = [itemsArr mutableCopy];
    [muArr insertObject:itemsArr[itemsArr.count - 1] atIndex:0];
    [muArr addObject:itemsArr[0]];
    
    _itemsArr = muArr;
    
    //将上一次的子控件全部移除
    [_scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    CGFloat H = _scrollView.bounds.size.height;
    CGFloat W = _scrollView.bounds.size.width;
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat lastX = 0;
    
    for (int i = 0; i < _itemsArr.count; i++) {
        //imageView
        x = i * W;
        UIImageView *imgView= [[UIImageView alloc]initWithFrame:CGRectMake(x, y, W, H)];
        imgView.backgroundColor = [UIColor clearColor];
        [_scrollView addSubview:imgView];
        
        UIImage *image = [UIImage imageNamed:_itemsArr[i]];
        imgView.image = image;
              
        lastX = CGRectGetMaxX(imgView.frame);
        
    }
    
    _scrollView.contentSize = CGSizeMake(lastX, H);
    
    [_scrollView setContentOffset:CGPointMake(W, 0) animated:NO];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
    
}

- (void)nextPage
{
    CGFloat nextPage = _scrollView.contentOffset.x + _scrollView.bounds.size.width;
    //NSLog(@"%ld",_page.currentPage);
    //    if (_page.currentPage == _itemsArr.count-1) {
    //        nextPage = 0;
    //    }
    [_scrollView setContentOffset:CGPointMake(nextPage, 0) animated:YES];
}



#pragma mark- scrollview delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat page = _scrollView.contentOffset.x / _scrollView.bounds.size.width;
    CGFloat offsetx = _scrollView.contentOffset.x - page * _scrollView.bounds.size.width;
    
    if (page == 0 && offsetx == 0) {
        
        [_scrollView setContentOffset:CGPointMake((_itemsArr.count-2) * _scrollView.bounds.size.width, 0) animated:NO];
        _page.currentPage = _itemsArr.count-3;
        
        
    }else if (page == _itemsArr.count-1 && offsetx == 0){
        [_scrollView setContentOffset:CGPointMake(_scrollView.bounds.size.width, 0) animated:NO];
        _page.currentPage = 0;
    }else{
        _page.currentPage = page - 1;
    }
    
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    _timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
}


@end
