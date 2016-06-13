#iOS note

#关于使用workspace管理项目时遇到的库依赖问题
* symbol duplicate问题：假如有libA和libB都依赖libC，而projectA依赖libA和libB，则在target设置中，可以将libA和libB对libC的链接取消（Build Phases->Link Binary With Libraries），以避免xcode发现多份obj文件出现symbol duplicate问题。

#关于资源完整路径获取问题
	在xcode中，资源如果在添加时选择”Create groups”，同时资源存在目录结构，如“aaa/bbb/ccc.txt”，则在程序中使用NSBundle的pathForResource方法使用以上路径不能获取资源的完整路径，导致资源不能读取数据。故在此情况下，添加资源是应选择”Create folder references”把整个目录结构导入，若资源不在工程目录下，可以选择”Copy items if needed”。
	
#第三方静态库导入问题
	若在工程中需要使用第三方静态库，如果其有工程文件(即xcodeproj文件)，则在导入工程之后，选择“Editor”->”Validate Settings...”升级一下工程，避免由于第三方工程文件太旧而出现编译、链接或者运行时候的问题。
	
#Xcode无法生成IOS APP ARCHIVE而生成Generic Xcode Archive问题
	如果工程引用了外部类库， 默认生成的archive是 Generic Xcode Archive 格式的 无法发布和生成ipa文件。
	这个时候需要更改工程设置在build setting里面把 skip install 的标记位修改为yes。注意 要把所有外部第三方静态库的工程设置都修改完。
	不然无法成功
	总结一下解决办法如下：
	在所有依赖的库的工程作如下三点处理：
	1、将Build Settings->Deployment->Skip Install 设置为 YES，但项目的Skip Install却要保持为NO。
	2、将Build Phases->Copy Headers中的所有头文件拉到Project下，即Public和Private下不能有文件。
	3、清空Build Settings->Deployment->Installation Directory选项的内容。

#iOS8之前触摸事件坐标和屏幕尺寸问题
	在iOS8之前，当设备朝向发生改变时，控件坐标系会自动调整到相对于该朝向的坐标系。
	永远以用户站立时，右手方向为x轴和屏幕宽度的方向，垂直向下为y轴和屏幕高度的方向。
	故在代码中使用UITouch的locationInView:nil风险很大，因为没有自适应，而locationInView:self.view则会跟view一样自动调整坐标系。
	
#关于[UIScreen mainScreen].bounds返回大小不正确的问题
	必须在target > General > App Icons and Launch Images > Launch Images Source 设置一个LaunchImage（不管是否有效），bounds才会返回正确的大小。在Xcode 7.0之后，还得添加Launch Screen才行。