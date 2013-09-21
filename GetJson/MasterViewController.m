//
//  MasterViewController.m
//  GetJson
//
//  Created by naotaro on H.25/09/21.
//  Copyright (c) 平成25年 All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"

@interface MasterViewController () {
    NSMutableArray *_objects;
    NSMutableArray *items; // 行の内容
}
@end

@implementation MasterViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // json取得メソッド呼び出し
    [self jsonGet];
    
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
}

-(void)jsonGet{
    // ダウンロードするためのURLリクエストを準備
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://simplecode.jp/lolipop/test/jsontest.json"]];
    // URLからJSONデータを取得(NSData)
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    // JSONで解析するために、NSDataをNSStringに変換
    NSString *json_string = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    // JSONデータをパースする
    NSLog(@"json_string:%@",json_string);
    NSLog(@"%@", [json_string substringToIndex:json_string.length - 1]);
    // なぜか末尾の;があるとJSONValueでパースエラーになるので取り除く
    json_string = [json_string substringToIndex:json_string.length - 1];
    // ここではJSONデータが配列としてパースされるので、NSArray型でデータ取得
    NSDictionary *temp_array = [json_string JSONValue];
    // NSDictionaryにセットされた値からまずBodyを取り出してtemp_arrayに再セット
    NSLog(@"data: %@",[temp_array objectForKey:@"data"]);
    // さらにItemを取り出してarrayにセット
    NSDictionary *array = [temp_array objectForKey:@"data"];
    // items初期化
    items = [[NSMutableArray alloc] init];
    NSString *strusername;  // ユーザ名
    NSString *tweet;        // ツイート内容
    
    for (NSDictionary *data in array) {
        NSLog(@"username: %@",[data objectForKey:@"username"]);
        NSLog(@"tweet: %@",[data objectForKey:@"tweet"]);
        NSLog(@"registdate: %@",[data objectForKey:@"registdate"]);

        strusername = [data objectForKey:@"username"];
        tweet = [data objectForKey:@"tweet"];
        // 1行ずつセット
        NSString *strcell = [NSString stringWithFormat:@"%@   %@",tweet,strusername];
        [items addObject:strcell];
    }
}

// セルの高さを指定する
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 全てのセクション・行の高さは全て80ピクセルにします
    return 80;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender
{
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
    [_objects insertObject:[NSDate date] atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
// TableView の行数をつたえる
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [items count];
}
// TableView の各行の中身をつたえる
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.textLabel.text = [items objectAtIndex:indexPath.row];
    // 複数行表示
    cell.textLabel.numberOfLines = 0;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDate *object = _objects[indexPath.row];
        [[segue destinationViewController] setDetailItem:object];
    }
}

@end
