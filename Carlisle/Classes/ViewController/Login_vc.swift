//
//  Login_vc.swift
//  Carlisle
//
//  Created by Gckit on 2019/04/07.
//  Copyright (c) 2019 SeongBrave. All rights reserved.
//

import RxSwift
import UtilCore
import EmptyDataView
import MJRefresh
import Alice
import Bella
import SwiftyUserDefaults

class Login_vc: Base_Vc {
    
    /****************************Storyboard UI设置区域****************************/
    @IBOutlet weak var username_tf: UITextField!
    @IBOutlet weak var password_tf: UITextField!
    @IBOutlet weak var login_btn: UIButton!
    @IBOutlet weak var forget_btn: UIButton!
    
    @IBOutlet weak var rember_btn: UIButton!
    @IBOutlet weak var register_btn: UIButton!
    @IBOutlet weak var indicator_v: UIActivityIndicatorView!
    /*----------------------------   自定义属性区域    ----------------------------*/
    var manageVm: Login_vm?
    var present:Bool = false
    
    /****************************Storyboard 绑定方法区域****************************/
    
    /// 表示是否是present出来的 如果是的话导航栏需要显示关闭按钮 否则不显示
    
    /**************************** 以下是方法区域 ****************************/
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    let validatedUsername = PublishSubject<ValidationResult>()
    /**
     界面基础设置
     */
    override func setupUI() {
        login_btn.loginTheme()
        /**
         *  自定义 导航栏左侧 返回按钮
         */
        self.customLeftBarButtonItem()
        title = "登录"
        if Global.isRember() {
            self.password_tf.text = Global.password()
        }
        self.username_tf.text = Global.userName()
        self.rember_btn.isSelected = Global.isRember()
    }
    /**
     app 主题 设置
     */
    override func setViewTheme() {
        
    }
    /**
     绑定到viewmodel 设置
     */
    override func bindToViewModel() {
        
        self.register_btn.rx.tap
            .map{("register",nil)}
            .bind(to: self.view.rx_openUrl)
            .disposed(by: disposeBag)
        
        self.forget_btn.rx.tap
            .map{("forget",nil)}
            .bind(to: self.view.rx_openUrl)
            .disposed(by: disposeBag)
        
        self.rember_btn
            .rx.tap
            .subscribe(onNext: { [unowned self] ( _ ) in
                self.rember_btn.isSelected = !self.rember_btn.isSelected
            })
            .disposed(by: disposeBag)
        
        /**
         *  初始化viewmodel
         */
        
        self.manageVm = Login_vm(
            input: (
            username: Observable.of(
                Observable.just( username_tf.text ?? ""),
                username_tf.rx.text.orEmpty.asObservable()
                )
                .merge(),
            password: Observable.of(
                Observable.just( password_tf.text ?? ""),
                password_tf.rx.text.orEmpty.asObservable()
                )
                .merge(),
            loginTaps: login_btn.rx.tap.asObservable()
            ),
            validationService: LoginValidationService())
        
        self.manageVm?.signupEnabled.asObservable()
            .subscribe(onNext: { [weak self] valid  in
                self?.login_btn.isEnabled = valid
            })
            .disposed(by: disposeBag)
        
        self.manageVm?.loading.asObservable()
            .bind(to: indicator_v.rx.isAnimating)
            .disposed(by: disposeBag)
        
        self.manageVm?.loginSuccess
            .subscribe(onNext: { [unowned self] (result) in
                Global.updateIsRember(self.rember_btn.isSelected)
                Global.updateUserName(self.username_tf.text ?? "")
                if self.rember_btn.isSelected {
                    Global.updatePassword(self.password_tf.text ?? "")
                }
                self.view.toastCompletion("🥳 登陆成功啦~~~", completion: { _ in
                    self.closeVc()
                })
            })
            .disposed(by: disposeBag)
        
        self.manageVm?
            .error
            .asObserver()
            .bind(to: self.view.rx_error)
            .disposed(by: disposeBag)
        
    }
    
    /**
     自定义leftBarButtonItem
     */
    override func customLeftBarButtonItem() {
        
        if self.present {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "iconclose", in: CarlisleCore.bundle, compatibleWith: nil), style: .plain, target: self, action: #selector(closeVc))
        }
    }
    
    @objc func closeVc() -> Void {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - 自定义方法
extension  Login_vc {
    
    
}
