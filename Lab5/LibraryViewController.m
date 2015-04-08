//
//  TableViewController.m
//  Lab4
//
//  Created by Adrian on 2/25/15.
//  Copyright (c) 2015 Adrian. All rights reserved.
//

#import "LibraryViewController.h"
#import "QuotesModel.h"
#import "InputViewController.h"

@interface LibraryViewController ()
@property (strong, nonatomic) QuotesModel *model;
@end

@implementation LibraryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.model = [QuotesModel sharedModel];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
     self.navigationItem.leftBarButtonItem = self.editButtonItem;
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [super setEditing:NO animated:NO];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.model numberOfQuotes];
    // Return the number of rows in the section.
    //return [self.model numberOfQuotes];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
        static NSString * cellIdentifier = @"QuotesCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc ] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:17.0];
    NSDictionary * quotesDict = [self.model quoteAtIndex:indexPath.row];
    
    NSString *quote = quotesDict[@"quote"];
    NSString *author = quotesDict[@"author"];
    cell.detailTextLabel.text = author;
    cell.textLabel.text = quote;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *quoteStrTemp = [self.model quoteAtIndex:indexPath.row][@"quote"];
    NSString *authorStrTemp = [self.model quoteAtIndex:indexPath.row][@"author"];
    UIFont *cellFont = [UIFont fontWithName:@"Helvetica" size:17.0];
    
    NSAttributedString *quoteAttributedText = [[NSAttributedString alloc] initWithString: quoteStrTemp attributes:@{ NSFontAttributeName:cellFont}];
    CGRect quoteRect = [quoteAttributedText boundingRectWithSize:CGSizeMake(tableView.bounds.size.width,CGFLOAT_MAX)  options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    NSAttributedString *authorAttributedText = [[NSAttributedString alloc] initWithString: authorStrTemp attributes:@{ NSFontAttributeName:cellFont}];
    CGRect authorRect = [authorAttributedText boundingRectWithSize:CGSizeMake(tableView.bounds.size.width,CGFLOAT_MAX)  options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    return quoteRect.size.height + authorRect.size.height + 20;
    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.model removeQuoteAtIndex:indexPath.row];
        
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    InputViewController *inputVC = segue.destinationViewController;
    inputVC.completionHandler = ^(NSString *quoteText, NSString *authorText){
        if(quoteText != nil){
            NSDictionary *quoteDict =@{
            @"quote":quoteText,
            @"author": authorText
            };
            
            [self.model insertQuote:quoteDict atIndex:0];
            
            NSIndexPath  *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
        }
        [self dismissViewControllerAnimated:YES completion:nil];
   };
}

@end
