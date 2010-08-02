//
//  DetailViewController.m
//  RSS Reader
//
//  Created by Basav Nagur on 7/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DetailViewController.h"


@implementation DetailViewController
@synthesize webView, link;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	//NSString *urlString = [NSString stringWithFormat:[[stories objectAtIndex:indexPath.row] objectForKey:@"link"]];
//	NSString *encodedUrl = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]; 
//	[rssWebView loadRequest:[NSURLRequest requestWithURL: [NSURL URLWithString:encodedUrl]]];
//	rssWebView.scalesPageToFit = YES;
//	
//	
//	UIViewController *thisVC = [[UIViewController alloc] init];
//	thisVC.view = rssWebView;
//	thisVC.title = [[stories objectAtIndex:indexPath.row]
//					objectForKey:@"title"];
//	
//	[self.navigationController pushViewController:thisVC animated:YES];
//	
//	[rssWebView release];
//	[thisVC release];
//	
	
	//NSString *urlString = @"http://www.mckinseyquarterly.com/Economic_Studies/Country_Reports/Indias_urbanization_A_closer_look_2640?gp=1";
	NSString *encodedUrl = [link stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
	NSURL *url = [NSURL URLWithString:encodedUrl];
	NSError *theNetworkError;
	NSString *content = [NSString stringWithContentsOfURL:url encoding:NSASCIIStringEncoding error:&theNetworkError];
	//lblText.text = content;
	NSLog(@"server returned data: >|%@|<", content);
	webView.scalesPageToFit = YES ;
	[webView loadRequest:[NSURLRequest requestWithURL: [NSURL URLWithString:encodedUrl]]];
	[webView release];

}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
	return YES ;
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}



- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc {
	[lblText release];
    [super dealloc];
}


@end
