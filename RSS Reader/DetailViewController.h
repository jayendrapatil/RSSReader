//
//  DetailViewController.h
//  RSS Reader
//
//  Created by Basav Nagur on 7/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DetailViewController : UIViewController {
	
	IBOutlet UIWebView *webView ;
	NSMutableDictionary *item;
	NSString *link;

}

+ (DetailViewController*) detailViewControllerWithItem:(NSString*) newlink;

@property (nonatomic, retain) IBOutlet UIWebView *webView ;
@property (nonatomic, retain) NSMutableDictionary *item;
@property (nonatomic, retain) NSString *link ;

@end
