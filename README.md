# LSRouter
##作者：ArthurShuai

# 写在前面的话
###1.非常感谢MGJRouter、CTMediator的作者，感谢大神们对iOS组件化架构的贡献；
###2.特别感谢CTMediator的作者，对类别的运行时特性的运用以及关于远程调用本地组件与本地组件间调用的思路给了我非常大的启发。尽管LSRouter与CTMediator很是有很大的区别，但也还是站在了巨人的肩膀上出发。
###3.LSRouter最重要解决是两个方面，更细一点说是三个方面，一是远程调用本地组件，这方面参考了CTMediator的实现方式；二是本地组件间调用，这方面在CTMediator的实现方式上更替为自己的实现方式、自己的设计style；三是本地组件间远程相互通讯，这个是独有的，也是与MGJRouter、CTMediator相比重大升级的地方。
#一、LSRouter介绍
###（一）两点说明
###1.“组件”定义：即一个经过严格单元测试的可复用页面、视图等，组件对外的action所在其实就是viewController或view
###2.类似于AFNetworking之类的，我的架构中称之为“工具插件”，在命名上与“组件”有所区别
###（二）补充说明
###1.设计中大量使用runtime运行时特性，尽可能减少内存占用，可能设计有缺陷之处，但已尽力
###2.LSRouter中对UIViewController与UIView添加几个类别，目的其一也是尽可能减少内存占用，其二是将所有的viewController与view都看作是一个组件
###3.了解MGJRouter、CTMediator的不难知道，hardcode问题是一个不好解决的地方，所以LSRouter在设计时尽可能引用id类型，对特别需要注意的地方重点说明，尽量减少hardcode带来的交流耦合。这个地方也是希望有大神能够找到更优化、合适的方案
###（三）API说明
###1.+ (void)performActionWithUrl:(NSURL *)url completion:(LSRouterHandler)completion;
####远程App调用入口
####url格式：scheme://[target]/[actionName]?[params]
###2.+ (void)openModule:(NSString *)objectClass action:(NSString *)actionName params:(id)params perform:(LSRouterHandler)handler;
####本地组件调用入口
####perform:找到组件后下一步调用处理，如push、present、addSubview组件等
###3.+ (void)sendInformation:(id)information tagName:(NSString *)name;
####组件发送通讯信息接口
####组件只管发送，通讯标记不能为空
####information为基本数值类型时，要转为NSNumber
###4.+ (void)receiveInformationWithTagName:(NSString *)name result:(LSInformationHandler)resultHandler;
####组件接收通讯信息接口
####组件只管通过通讯标记接收信息
#二、Demo介绍
###（一）介绍
###1.模拟实现2个组件的调用与通讯，一个是view组件，一个是viewController组件。因为是Demo，故直接在Demo中创建了组件，实际中可使用自己设计的方式集成组件到项目中，如与cocoaPods结合
<img src="./Images/7.png" style="zoom:80%" />
####（1）从上图组件可以看出，每一个组件都包含了一个LSRouter类别，这个就是每一个组件向LSRouter声明的对外要提供的action所在文件，其他组件内只要调用LSRouter这个类型内对应的action方法即可
####（2）LSRouter类别中action方法，当前要求必须包含“action_”前缀，这是为了与远程App调用时相区分，是趋于安全性考虑
###2.实现
####（1）在MainViewController中，添加#import "LSRouter+SecondViewController.h"，调用
[LSRouter action_SC_showText:^(id module) {
        if ([module isKindOfClass:[UIViewController class]]) {
            [weakSelf.navigationController pushViewController:module animated:YES];
        }
    } param:@"successful!"];，实现调用组件，并成功传入值，实现label内容更改；
####（2）在MainViewController中，调用
[LSRouter action_SC_showAlert:^(id module) {
        if ([module isKindOfClass:[UIViewController class]]) {
            [weakSelf.navigationController pushViewController:module animated:YES];
        }
    } param:@"successful again!"];，实现调用组件，并成功传入值，实现弹出框提示；
###（3）在MainViewController中，添加#import "LSRouter+TestView.h"，调用
[LSRouter action_TV_showText:^(id module) {
        if ([module isKindOfClass:[UIView class]]) {
            [weakSelf.navigationController.view addSubview:module];
        }
    } text:@"I am a view!"];，实现添加一个新的视图组件；
###（4）在MainViewController中，通过
 [LSRouter action_SC_receive:^(id information) {
        weakSelf.title = information;
    }];，实现接收组件的远程通讯信息，从而更改标题。