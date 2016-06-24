//
//  ViewController.m
//  UISearchControllerDemo
//
//  Created by mac on 16/6/24.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    UITableView *_tableView;
    UISearchController *_searchVc;
}
@property(nonatomic,strong)NSMutableArray *dataList;
@property(nonatomic,strong)NSMutableArray *searchList;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化数据
    self.dataList=[NSMutableArray arrayWithCapacity:100];
    
    for (NSInteger i=0; i<100; i++) {
        [self.dataList addObject:[NSString stringWithFormat:@"%ld-row",(long)i]];
    }
    
    // 创建UITableView
    _tableView=[[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    [self.view addSubview:_tableView];
    
    
    // 创建UISearchController
    _searchVc=[[UISearchController alloc] initWithSearchResultsController:nil];
    _searchVc.searchResultsUpdater = self;//设置显示搜索结果的控制器
    _searchVc.dimsBackgroundDuringPresentation = NO;//设置开始搜索时背景显示与否
    _searchVc.hidesNavigationBarDuringPresentation = NO;
    
    //  自己给searchBar的frame
    //    _searchVc.searchBar.frame = CGRectMake(_searchVc.searchBar.frame.origin.x, _searchVc.searchBar.frame.origin.y, _searchVc.searchBar.frame.size.width, 44.0);
    //    _tableView.tableHeaderView = _searchVc.searchBar;
    
    
    
    // 设置searchBar位置自适应
    [_searchVc.searchBar sizeToFit];
    
    _tableView.tableHeaderView = _searchVc.searchBar;
}

#pragma mark--代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    // 单元格的个数根据搜索前后数据判断，如果搜索控制器激活了，就返回搜索数据数组的个数，不然就返回正常数据个数
    
    if (_searchVc.active) {
        return [self.searchList count];
    }else{
        return [self.dataList count];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *string=@"UITableViewCell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:string];
    
    if (!cell) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:string];
    }
    if (_searchVc.active) {
        
        [cell.textLabel setText:self.searchList[indexPath.row]];
    }
    else{
        
        [cell.textLabel setText:self.dataList[indexPath.row]];
    }
    
    return cell;
    
}

#pragma mark--UISearchResultsUpdating
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *searchString = [_searchVc.searchBar text];
    
    // 定义谓词和谓词的查找方式
    NSPredicate *preicate = [NSPredicate predicateWithFormat:@"self contains[c] %@", searchString];
    
    if (self.searchList!= nil) {
        [self.searchList removeAllObjects];
    }
    
    //过滤数据
    self.searchList= [NSMutableArray arrayWithArray:[_dataList filteredArrayUsingPredicate:preicate]];
    //刷新表格
    [_tableView reloadData];
}

//点击监听方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_searchVc.active) {
        
        NSLog(@"点击了searchlist----%ld",indexPath.row);
        
    }
    else{
        
        NSLog(@"点击了datalist---%ld",indexPath.row);
        
    }
    
    
}
@end

