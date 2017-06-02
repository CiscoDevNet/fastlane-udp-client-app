#import "ViewController.h"
#import "GCDAsyncUdpSocket.h"
#import "DDLog.h"

#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <unistd.h>
#include <ifaddrs.h>
#include <arpa/inet.h>


// Log levels: off, error, warn, info, verbose
static const int ddLogLevel = LOG_LEVEL_VERBOSE;

#define FORMAT(format, ...) [NSString stringWithFormat:(format), ##__VA_ARGS__]

@interface ViewController ()
{
	long tag;
	GCDAsyncUdpSocket *udpSocket;
	NSMutableString *log;
}

@end


@implementation ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]))
	{
		log = [[NSMutableString alloc] init];
	}
	return self;
}


- (void)setupSocket
{
    udpSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
	
    NSLog(@"SOCKET FD: %d", udpSocket.socketFD);
    
	NSError *error = nil;
	
	if (![udpSocket bindToPort:0 error:&error])
	{
		[self logError:FORMAT(@"Error binding: %@", error)];
		return;
	}
	if (![udpSocket beginReceiving:&error])
	{
		[self logError:FORMAT(@"Error receiving: %@", error)];
		return;
	}
    
    [udpSocket performBlock:^{
        int socketFD = [udpSocket socketFD];
        int optval = 0;
        socklen_t optlen = sizeof(optval);
        if (getsockopt(socketFD, SOL_SOCKET, SO_NET_SERVICE_TYPE, &optval, &optlen) < 0) {
            NSLog(@"getsockopt failed: %s", strerror(errno));
        }
        else {
            NSLog(@"Fastlane get: %d", optval);
        }
        
        // Set the option active
        //================================================
        // YOUR CODE IS GOING HERE:
        // - uncomment code block
        // - change 'optval' parameter (OPTIONAL)
        //================================================
        
        /*
        optval = NET_SERVICE_TYPE_VO;
        optlen = sizeof(optval);
        if(setsockopt(socketFD, SOL_SOCKET, SO_NET_SERVICE_TYPE, &optval, optlen) < 0) {
            perror("setsockopt()");
        }
        else {
            // Check the status again
            if(getsockopt(socketFD, SOL_SOCKET, SO_NET_SERVICE_TYPE, &optval, &optlen) < 0) {
                perror("getsockopt()");
                close(socketFD);
                exit(EXIT_FAILURE);
            }
            NSLog(@"Fastlane get after set: %d",optval);
        }
        */


    NSLog(@"2. SOCKET FD: %d", socketFD);
    }];

	[self logInfo:@"Ready"];
}


- (void)viewDidLoad
{
	[super viewDidLoad];
	if (udpSocket == nil)
	{
		[self setupSocket];
	}
}


- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
	DDLogError(@"webView:didFailLoadWithError: %@", error);
}


- (void)webViewDidFinishLoad:(UIWebView *)sender
{
	NSString *scrollToBottom = @"window.scrollTo(document.body.scrollWidth, document.body.scrollHeight);";
    [sender stringByEvaluatingJavaScriptFromString:scrollToBottom];
}


- (void)logError:(NSString *)msg
{
	NSString *prefix = @"<font color=\"#B40404\">";
	NSString *suffix = @"</font><br/>";
	
	[log appendFormat:@"%@%@%@\n", prefix, msg, suffix];
	
	NSString *html = [NSString stringWithFormat:@"<html><body>\n%@\n</body></html>", log];
	[webView loadHTMLString:html baseURL:nil];
}


- (void)logInfo:(NSString *)msg
{
	NSString *prefix = @"<font color=\"#6A0888\">";
	NSString *suffix = @"</font><br/>";
	
	[log appendFormat:@"%@%@%@\n", prefix, msg, suffix];
	
	NSString *html = [NSString stringWithFormat:@"<html><body>\n%@\n</body></html>", log];
	[webView loadHTMLString:html baseURL:nil];
}


- (void)logMessage:(NSString *)msg
{
	NSString *prefix = @"<font color=\"#000000\">";
	NSString *suffix = @"</font><br/>";
	
	[log appendFormat:@"%@%@%@\n", prefix, msg, suffix];
	
	NSString *html = [NSString stringWithFormat:@"<html><body>%@</body></html>", log];
	[webView loadHTMLString:html baseURL:nil];
}


- (IBAction)send:(id)sender
{
	NSString *host = addrField.text;
	if ([host length] == 0)
	{
		[self logError:@"Address required"];
		return;
	}
	
	int port = [portField.text intValue];
	if (port <= 0 || port > 65535)
	{
		[self logError:@"Valid port required"];
		return;
	}
	
	NSString *msg = messageField.text;
	if ([msg length] == 0)
	{
		[self logError:@"Message required"];
		return;
	}
	
	NSData *data = [msg dataUsingEncoding:NSUTF8StringEncoding];

    NSLog(@"3. SOCKET FD: %d", udpSocket.socketFD);

	[udpSocket sendData:data toHost:host port:port withTimeout:-1 tag:tag];
	
	[self logMessage:FORMAT(@"SENT (%i): %@", (int)tag, msg)];
	
	tag++;
}


- (void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag
{
	// You could add checks here
}


- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error
{
	// You could add checks here
}


- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data
                                               fromAddress:(NSData *)address
                                         withFilterContext:(id)filterContext
{
	NSString *msg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	if (msg)
	{
		[self logMessage:FORMAT(@"RECV: %@", msg)];
	}
	else
	{
		NSString *host = nil;
		uint16_t port = 0;
		[GCDAsyncUdpSocket getHost:&host port:&port fromAddress:address];
		
		[self logInfo:FORMAT(@"RECV: Unknown message from: %@:%hu", host, port)];
	}
}

@end
