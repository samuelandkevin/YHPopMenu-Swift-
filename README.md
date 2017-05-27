# YHPopMenu-Swift-
### 仿微信“+”弹出菜单。</br>
### 修改图标和文字参数配置属性</br>

```
    open var iconW:CGFloat             //图标宽(默认宽高相等)
    open var fontSize:CGFloat          //字体大小
    open var fontColor:UIColor         //字体颜色
    open var itemBgColor:UIColor       //item背景颜色
    open var itemNameLeftSpace:CGFloat //itemName左边距
    open var iconLeftSpace:CGFloat     //icon左边距离
    open var itemH:CGFloat             //item高度
    open var iconNameArray:[String]    //图标名字Array
    open var itemNameArray:[String]    //item名字Array
    open var canTouchTabbar:Bool       //可以点击Tabbar;(默认是遮挡Tabbar)
```

### 弹出菜单
```
    private func _showMenu(){
        let itemH = CGFloat(50)
        let w = CGFloat(150)
        let h = CGFloat(6*itemH)
        let r = CGFloat(5)
        let x = ScreenWidth - w - r
        let y = CGFloat(10)
        
        popView =  YHPopMenu(frame: CGRect(x: x, y: y, width: w, height: h))
        popView?.iconNameArray = ["home_img_pubDyn","home_img_offerReward","home_img_pubPosition","chat_img_groupchat","chat_img_add","home_img_scan"]
        popView?.itemNameArray = ["发动态","发悬赏","发职位","发起群聊","添加朋友","扫一扫"]
        popView?.itemH     = itemH
        popView?.fontSize  = 16.0
        popView?.fontColor = UIColor.white
        popView?.canTouchTabbar = true
        popView?.itemBgColor = kGreenColor
        popView?.show()
        
        popView?.dismiss(handler: { [unowned self] (isCanceled, row) in
            if isCanceled == false {
                print("点击第\(row)行")
                if (row != 0) {
                    
                }
                else if(row == 1){
                    
                }
                else if(row == 2){
                    
                }
                else if(row == 3){
                    
                }
                else if(row == 4){
                    
                }
                else if(row == 5){
                    
                }
            }
            self._rBtnSelected = false
        })

    }

```

### 关闭弹出菜单
```
  func _hidePopMenu(animate:Bool){
        popView?.hide(animate: animate)
  }
```

### 效果图
<img src="http://img.blog.csdn.net/20170510160239027?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvc2FtdWVsYW5ka2V2aW4=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/Center" width="40%" alt="还在路上，稍等..."/>

### 呈上OC版
YHPopMenu OC版：[YHPopMenu](https://github.com/samuelandkevin/YHPopMenu)

### 你的支持,我的动力！

