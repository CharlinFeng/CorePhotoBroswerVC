

    Charlin出框架的目标：简单、易用、实用、高度封装、绝对解耦！

#### CorePhotoBroswerVC
快速集成高性能照片浏览器，支持本地及网络相册！<br />

    注：本框架是Charlin最后一个OC框架，未来的框架会以swift为新的语言。



<br /><br />

#### 写在之前<br />
官人要是觉得本框架还不错，请支持我，支持码农的无偿付出！不用给钱，右上角star或者fork一下就可以，谢谢你的支持！<br />
本框架主要目标是快速集成，目前，照片浏览器太多了，好用的还没多少，<br />MJ有一个不错，可惜年代久远，bug太多，而且长久没有维护更新，其他框架大多使用复杂，难以自定义。<br /><br />


#### 特别说明：<br />
本框架制作细节太多了，考虑的问题极多，绝对不是简单的scrollView设置一下paginEnable就可以这么简单，目前是直接push版本（高仿网易新闻），后续会增加frame放大版本（仿新浪微博及微信朋友圈照片浏览器）。<br /><br />


#### 精彩截图（动态图片较大，请耐心等待）<br />

###### 展示网络图片相册<br />
![image](./CorePhotoBroswerVC/show/1.gif)<br /><br />

###### 展示本地图片相册<br />
![image](./CorePhotoBroswerVC/show/2.gif)<br /><br />

###### 网络或者本地图片保存到手机系统相册<br />
![image](./CorePhotoBroswerVC/show/3.gif)<br /><br />
<br /><br />


#### 框架特性：<br />
>.ios版本兼容ios 7.0及以上.<br />
>.高仿网易新闻，后期将加入仿微信及新浪微博。
>.
>.
>.
>.



<br /><br />
#### Charlin想说：<br />
此版本是全部的QuartzCore绘制，整个框架使用了几乎所有的QuartzCore技术，如果你有兴趣，可以看下源代码，
算是一个比较不错的QuartzCore实战教程。

对于本框架，有以下技术点和大家分享：<br />
1.主界面使用Xib定制，如果你需要添加控件，非常方便，比如支付宝顶部有用户头像，我这里没有，所以就没加，如果你需要加，直接在xib添加即可。<br />
2.本地数据存储使用沙盒存储。<br />
3.无任何代理设计，全程使用block解决，引用老刘的一句话，目前代理设计模式正在被块代码所逐步取代。<br />
4.解锁线条绘制使用的是比较复杂的奇偶裁剪技术。有兴趣可以看看苹果官方示例。<br />
5.关于QuartzCore，使用到的技术除了基本的绘制以外，还使用了图形上下文栈，矩阵变换，刷新图层等。<br />
6.本框架考虑了添加密码，修改密码，验证密码，忘记密码等支付宝几乎全部的功能，并且使用简单。<br />





<br /><br />

#### 使用示例
    
    /*
     *  设置密码
     */
    - (IBAction)setPwd:(id)sender {
        
        
        BOOL hasPwd = [CLLockVC hasPwd];
        hasPwd = NO;
        if(hasPwd){
            
            NSLog(@"已经设置过密码了，你可以验证或者修改密码");
        }else{
            
            [CLLockVC showSettingLockVCInVC:self successBlock:^(CLLockVC *lockVC, NSString *pwd) {
                
                NSLog(@"密码设置成功");
                [lockVC dismiss:1.0f];
            }];
        }
    }

    /*
     *  验证密码
     */
    - (IBAction)verifyPwd:(id)sender {
        
        BOOL hasPwd = [CLLockVC hasPwd];
        
        if(!hasPwd){
            
            NSLog(@"你还没有设置密码，请先设置密码");
        }else {
            
            [CLLockVC showVerifyLockVCInVC:self forgetPwdBlock:^{
                NSLog(@"忘记密码");
            } successBlock:^(CLLockVC *lockVC, NSString *pwd) {
                NSLog(@"密码正确");
                [lockVC dismiss:1.0f];
            }];
        }
    }


    /*
     *  修改密码
     */
    - (IBAction)modifyPwd:(id)sender {
        
        BOOL hasPwd = [CLLockVC hasPwd];
        
        if(!hasPwd){
            
            NSLog(@"你还没有设置密码，请先设置密码");
            
        }else {
            
            [CLLockVC showModifyLockVCInVC:self successBlock:^(CLLockVC *lockVC, NSString *pwd) {
                
                [lockVC dismiss:.5f];
            }];
        }

    }


  
  <br /><br />

  

<br /><br />

-----
    CorePhotoBroswerVC 快速集成高性能照片浏览器，支持本地及网络相册！！
-----

<br /><br />




#### 版权说明 RIGHTS <br />
作品说明：本框架由iOS开发攻城狮Charlin制作。<br />
作品时间： 2015.04.26 18:07<br />
#### 关于Chariln INTRODUCE <br />
作者简介：Charlin-四川成都华西都市报旗下华西都市网络有限公司技术部iOS工程师！<br /><br />


#### 联系方式 CONTACT <br />ta
Q    Q：1761904945（请注明缘由）<br />
Mail：1761904945@qq.com<br />

<br /><br />
#### 友情提示 MENTION<br />
Charlin（成都）更多原创项目（涵盖了方方面面，看看还有没有你需要的）：<br />
首页：https://github.com/nsdictionary<br />
列表：https://github.com/nsdictionary?tab=repositories<br />
成都iOS开发群：163865401（Charlin创建与维护）<br />
