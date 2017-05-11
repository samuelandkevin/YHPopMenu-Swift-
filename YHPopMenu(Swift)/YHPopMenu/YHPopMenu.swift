//
//  YHPopMenu.swift
//  PikeWay
//
//  Created by YHIOS002 on 2017/5/11.
//  Copyright © 2017年 YHSoft. All rights reserved.
//

import Foundation
import UIKit
typealias DismissBlock = ((_ isCanceled:Bool,_ row:Int)->Void )?

//颜色
let kGreenColor = UIColor(red: 0.0, green: 191.0/255, blue: 144.0/255, alpha: 1.0)
let kGrayColor_Swift = UIColor.init(red: 222/255.0, green: 222/255.0, blue: 222/255.0, alpha: 1.0)
let KeyWindow = UIApplication.shared.keyWindow

class CellForMenuItem: UITableViewCell {
    let  imgvIcon    = UIImageView()
    let  lbName      = UILabel()
    let  viewBotLine = UIView()
    //cell的配置参数
    var  dictConfig: Dictionary<String,Any>?  = nil {
        willSet (newValue){
            if let newV = newValue {
                var fontSize = kFontSize
                if let afontSize = newV["fontSize"] as? Float,afontSize > 0 {
                    fontSize = CGFloat(afontSize)
                }
                lbName.font = UIFont.systemFont(ofSize: fontSize)
                
                var itemBgColor = kGreenColor
                if let aColor = newV["itemBgColor"] as? UIColor{
                    itemBgColor = aColor
                }
                self.backgroundColor = itemBgColor
                
                if let fontColor = newV["fontColor"] as? UIColor{
                    lbName.textColor = fontColor
                }
            }
            _updateUI()
           
        }
    }
    
    
    private let kIconW:CGFloat    = 16       //图标宽(默认宽高相等)
    private let kFontSize:CGFloat = 14.0     //字体大小
    
    private let kItemNameLeftSpace:CGFloat = 15//itemName左边距
    private let kIconLeftSpace:CGFloat = 15    //icon左边距离
    
    // MARK: - Setter
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        _setup()
        selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Method
    func _setup(){
  
        contentView.addSubview(imgvIcon)
    
        lbName.font = UIFont.systemFont(ofSize: 14.0)
        lbName.textAlignment = .left;
        contentView.addSubview(lbName)
    
        viewBotLine.backgroundColor = kGrayColor_Swift;
        contentView.addSubview(viewBotLine)
    
        _layoutUI()
    }
    
    func _layoutUI(){
        
        imgvIcon.snp.makeConstraints {[unowned self] (make) in
            make.left.equalTo(self.contentView).offset(10)
            make.centerY.equalTo(self.contentView.snp.centerY)
            make.width.height.equalTo(21)
        }
        
        lbName.snp.makeConstraints {[unowned self] (make) in
            make.left.equalTo(self.imgvIcon.snp.right).offset(20)
            make.centerY.equalTo(self.contentView.snp.centerY)
            make.right.equalTo(self.contentView).offset(-5)
        }
        
        viewBotLine.snp.makeConstraints {[unowned self] (make) in
            make.left.right.bottom.equalTo(self.contentView)
            make.height.equalTo(0.5)
        }
        
    }
    
    
    func _updateUI(){
    
        var iconW             = kIconW
        var iconLeftSpace     = kIconLeftSpace
        var itemNameLeftSpace = kItemNameLeftSpace
        if let dict = dictConfig {
            if let aWidth = dict["iconW"] as? Float ,aWidth > 0 {
                iconW = CGFloat(aWidth)
            }
            
            if let aiconLSpace = dict["iconLeftSpace"] as? Float ,aiconLSpace > 0 {
                iconLeftSpace = CGFloat(aiconLSpace)
            }
            
            if let aitemNLSpace = dict["itemNameLeftSpace"] as? Float, aitemNLSpace > 0 {
                itemNameLeftSpace = CGFloat(aitemNLSpace)
            }
        }

        imgvIcon.snp.updateConstraints {[unowned self] (make) in
            make.left.equalTo(self.contentView).offset(iconLeftSpace)
            make.width.height.equalTo(iconW)
        }
    
        lbName.snp.updateConstraints { [unowned self](make) in
            make.left.equalTo(self.imgvIcon.snp.right).offset(itemNameLeftSpace)
        }
    
    }
}

class YHArrow : UIView {
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = CGRect(x: 0, y: 0, width: 10, height: 5)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        //箭头
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 0, y: 5))
        bezierPath.addLine(to: CGPoint(x: 5, y: 0))
        bezierPath.addLine(to: CGPoint(x: 10, y: 5))
        bezierPath.close()
        
        let fillColor = kGreenColor
        fillColor.set()
        bezierPath.fill()
        bezierPath.stroke()
    }
}


class YHPopMenu : UIView,UITableViewDelegate,UITableViewDataSource{

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
    
    private let kItemH = CGFloat(44)   //item高度
    private let _viewArrow = YHArrow()
    private let _tableView = UITableView(frame: .zero, style: .plain)
    private let _viewBG    = UIView()
    private var _config:Dictionary<String,Any>? {
        get {
           let dict = [
                "iconW":iconW,
                "fontSize":fontSize,
                "fontColor":fontColor,
                "itemBgColor":itemBgColor,
                "itemNameLeftSpace":itemNameLeftSpace,
                "iconLeftSpace":iconLeftSpace,
                "itemH":itemH
            ] as Dictionary<String,Any>
            return dict
            
                       
        }
    }
    private var _menuRect  = CGRect.zero
    private var _block:DismissBlock
    
    // MARK: - init
    override init(frame: CGRect) {
        iconW  = 0
        fontSize = 0
        fontColor   = UIColor.black
        itemBgColor = kGreenColor
        itemNameLeftSpace = 0
        iconLeftSpace = 0
        itemH  = kItemH
        iconNameArray = []
        itemNameArray = []
        canTouchTabbar = false
    
        super.init(frame: frame)
        _menuRect = frame
        _setup()
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Private Method
    func _setup(){
    
        let tapViewBG  = UITapGestureRecognizer(target: self, action: #selector(onViewBG(aGes:)))
        let swipViewBG = UISwipeGestureRecognizer(target: self, action:#selector(onViewBG(aGes:)))
        let panViewBG  = UIPanGestureRecognizer(target: self, action: #selector(onViewBG(aGes:)))
          
        _viewBG.addGestureRecognizer(tapViewBG)
        _viewBG.addGestureRecognizer(swipViewBG)
        _viewBG.addGestureRecognizer(panViewBG)
        self.addSubview(_viewBG)
        
        //箭头
        _viewArrow.backgroundColor = UIColor.clear
        self.addSubview(_viewArrow)
        
        _tableView.backgroundColor     = UIColor.clear
        _tableView.layer.cornerRadius  = 2
        _tableView.layer.masksToBounds = true
        _tableView.delegate   = self
        _tableView.dataSource = self
        _tableView.separatorStyle = .none
        _tableView.showsVerticalScrollIndicator = false
        _tableView.bounces = false
        _tableView.register(CellForMenuItem.classForCoder(), forCellReuseIdentifier: NSStringFromClass(CellForMenuItem.classForCoder()))
        self.addSubview(_tableView)
   
        _layoutUI()
    }
    
    
    private func _layoutUI(){
    
        _tableView.layer.anchorPoint = CGPoint(x: 1, y: 0)
        _tableView.snp.makeConstraints { [unowned self](make) in
            make.left.equalTo(self).offset(self._menuRect.origin.x+(self._tableView.layer.anchorPoint.x - 0.5)*self._menuRect.size.width)
            make.top.equalTo(self).offset(self._menuRect.origin.y+(self._tableView.layer.anchorPoint.y-0.5)*self._menuRect.size.height)
            make.width.equalTo(0)
            make.height.equalTo(0)
            
        }
        _viewArrow.snp.makeConstraints { [unowned self](make) in
            make.left.equalTo(self).offset(self._menuRect.origin.x+(self._menuRect.size.width-26))
            make.top.equalTo(self).offset(self._menuRect.origin.y-5)
            make.width.equalTo(10)
            make.height.equalTo(5)
        }
        
        _viewBG.snp.makeConstraints { [unowned self](make) in
            make.left.top.bottom.right.equalTo(self)
        }
    
    }
    
    
    // MARK: - Gesture
    func onViewBG(aGes:Any){
        if (_block != nil){
            _block!(true,-1)
        }
        hide(animate: true)
    }
    
    
    // MARK: - Public Method
    open func dismiss(handler:DismissBlock) {
        _block = handler
    }
    
    open func show(){
        var viewBGH = ScreenHeight - 64.0 - 44.0
        if canTouchTabbar == false {
            viewBGH = ScreenHeight - 64.0
        }
        
        self.frame = CGRect(x: 0, y: 64, width: ScreenWidth, height: viewBGH)
        KeyWindow?.addSubview(self)
        
        //显示PopView动画
        _tableView.alpha = 0
        _tableView.contentOffset = .zero
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.01) {[unowned self] in
            self._tableView.snp.updateConstraints({[unowned self] (make) in
                make.width.equalTo(self._menuRect.size.width)
                make.height.equalTo(self._menuRect.size.height)
                self._tableView.alpha = 1
            })
        }

        UIView.animate(withDuration: 0.2) { 
            [unowned self] in
            self._tableView.layoutIfNeeded()
            
        }
        
    }
    
    open func hide(animate:Bool){
        
        _tableView.contentOffset = .zero
        
        UIView.animate(withDuration: 0.2,animations: { [unowned self] in
            self._tableView.alpha = 0
            self._viewArrow.alpha = 0
            if animate == true {
                self._tableView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            }
        },completion: { [unowned self] _ in
              self.removeFromSuperview()
        })
        

    }
    
    // MARK: - @protocol UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemNameArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier:NSStringFromClass(CellForMenuItem.classForCoder())  ) as? CellForMenuItem else{
            return UITableViewCell()
        }

        
        if indexPath.row < iconNameArray.count {
            let iconName = iconNameArray[indexPath.row]
            cell.imgvIcon.image = UIImage(named:iconName)
        }
        
        if indexPath.row < self.itemNameArray.count {
            cell.lbName.text = itemNameArray[indexPath.row]
        }
        
        if indexPath.row == self.itemNameArray.count - 1 {
            cell.viewBotLine.isHidden = true
        }else{
            cell.viewBotLine.isHidden = false
        }
        
        cell.dictConfig = _config
        return cell
    }
    
    
    // MARK: - @protocol UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (_block != nil) {
            _block!(false,indexPath.row);
        }
        hide(animate: false)
    }
}
