//
//  ViewController.swift
//  YHPopMenu(Swift)
//
//  Created by YHIOS002 on 2017/5/11.
//  Copyright © 2017年 samuelandkevin. All rights reserved.
//

import UIKit


let ScreenWidth  = UIScreen.main.bounds.size.width
let ScreenHeight = UIScreen.main.bounds.size.height



class ViewController: UIViewController {

    private var _rBtnSelected = false
    private var popView:YHPopMenu?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        _setUpNavigationBar()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Private Method
    private func _setUpNavigationBar(){
        self.title = "首页"
        
        //设置导航栏背景颜色
        let color = UIColor(red: CGFloat(0) / 255.0, green: CGFloat(191) / 255.0, blue: CGFloat(143) / 255.0, alpha: CGFloat(1))
        navigationController?.navigationBar.barTintColor = color
    
        let shadow = NSShadow()
        shadow.shadowColor = UIColor.init(white: 0.871, alpha: 1.000)
        shadow.shadowOffset = CGSize(width: 0.5, height: 0.5)
        shadow.shadowBlurRadius = 20
    
        //设置导航栏标题颜色
        let attributes = [NSForegroundColorAttributeName:UIColor.white,NSFontAttributeName:UIFont.systemFont(ofSize: 18),NSShadowAttributeName:shadow]

        navigationController?.navigationBar.titleTextAttributes = attributes

        //设置返回按钮的颜色
        UINavigationBar.appearance().tintColor = UIColor.white
    
        //添加按钮
        let addBtn = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(onRightBtn(sender:)))
        navigationItem.rightBarButtonItem = addBtn;
    }
    
    // MARK: - Action
    func onRightBtn(sender:Any){
        _rBtnSelected = !_rBtnSelected
        if _rBtnSelected == true {
            _showMenu()
        }else{
            _hidePopMenu(animate: true)
        }
    }
    
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
    
    func _hidePopMenu(animate:Bool){
        popView?.hide(animate: animate)
    }
    
   



}

