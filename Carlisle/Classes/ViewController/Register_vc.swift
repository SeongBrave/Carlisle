//
//  Register_vc.swift
//  Carlisle
//
//  Created by Gckit on 2019/04/07.
//  Copyright (c) 2019 SeongBrave. All rights reserved.
//

import RxSwift
import UtilCore
import MJRefresh

class Register_vc: Base_Vc {
    
    /****************************Storyboard UI设置区域****************************/
    
    @IBOutlet weak var msgCode_btn: UIButton!
    
    @IBOutlet weak var register_btn: UIButton!
    
    @IBOutlet weak var msgCode_tf: UITextField!
    
    @IBOutlet weak var phone_tf: UITextField!
    
    @IBOutlet weak var password_tf: UITextField!
    
    @IBOutlet weak var indicator_v: UIActivityIndicatorView!
    /*----------------------------   自定义属性区域    ----------------------------*/
    /// 计时器
    var countdownTimer: Timer?
    
    var remainingSeconds: Int = 0 {
        willSet {
            msgCode_btn.setTitle("\(newValue)秒后重新获取", for: .normal)
            if newValue <= 0 {
                msgCode_btn.setTitle("获取验证码", for: .normal)
                isCounting = false
            }
        }
    }
    
    var isCounting = false {
        willSet {
            if newValue {
                countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(Register_vc.updateTime(_:)), userInfo: nil, repeats: true)
                remainingSeconds = 60
            } else {
                countdownTimer?.invalidate()
                countdownTimer = nil
            }
            msgCode_btn.isEnabled = !newValue
        }
    }
    
    var manageVm: Register_vm?
    /****************************Storyboard 绑定方法区域****************************/
    
    
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
    /**
     界面基础设置
     */
    override func setupUI() {
        /**
         *  自定义 导航栏左侧 返回按钮
         */
        self.customLeftBarButtonItem()
        title = "注册"
        self.register_btn.loginTheme()
        self.msgCode_btn.sendMsgTheme()
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
        
        /**
         *  初始化viewmodel
         */
        
        self.manageVm = Register_vm(
            input: (
                phone: Observable.of(
                    Observable.just( phone_tf.text ?? ""),
                    phone_tf.rx.text.orEmpty.asObservable()
                    )
                    .merge(),
                msgCode: Observable.of(
                    Observable.just( msgCode_tf.text ?? ""),
                    msgCode_tf.rx.text.orEmpty.asObservable()
                    )
                    .merge(),
                password: Observable.of(
                    Observable.just( password_tf.text ?? ""),
                    password_tf.rx.text.orEmpty.asObservable()
                    )
                    .merge(),
                registerTaps: register_btn.rx.tap.asObservable(),
                msgCodeTaps: msgCode_btn.rx.tap.asObservable()
            ),
            validationService: RegisterImplementations())
        
        self.manageVm?.signupEnabled.asObservable()
            .subscribe(onNext: { [weak self] valid  in
                self?.register_btn.isEnabled = valid
            })
            .disposed(by: disposeBag)
        
        self.manageVm?.loading.asObservable()
            .bind(to: indicator_v.rx.isAnimating)
            .disposed(by: disposeBag)
        
        self.manageVm?.validatedPhone
            .asObservable()
            .subscribe(onNext: {[unowned self] (result) in
                if result.isValid && self.remainingSeconds == 0{
                    self.msgCode_btn.isEnabled = true
                }else{
                    self.msgCode_btn.isEnabled = false
                }
            })
            .disposed(by: disposeBag)
        
        self.msgCode_btn
            .rx.tap
            .subscribe(onNext: { [unowned self] ( _ ) in
                self.msgCode_btn.isEnabled = false
            })
            .disposed(by: disposeBag)
        
        self.manageVm?.sendMsgSuccess
            .subscribe(onNext: {[unowned self] (json) in
                if UtilCore.sharedInstance.isDebug{
                    self.view.toast(json["msgCode"].stringValue)
                }
                self.isCounting = true
            })
            .disposed(by: disposeBag)
        
        self.manageVm?.loginSuccess
            .subscribe(onNext: { [unowned self] (result) in
                self.view.toastCompletion("🎉🎉🎉注册成功啦", completion: { _ in
                    self.backToView()
                })
            })
            .disposed(by: disposeBag)
        
        self.manageVm?
            .error
            .asObserver()
            .subscribe(onNext: { [unowned self] (_) in
                self.remainingSeconds = 0
                self.isCounting = false
            })
            .disposed(by: disposeBag)
        
        self.manageVm?
            .error
            .asObserver()
            .bind(to: self.view.rx_error)
            .disposed(by: disposeBag)
        
    }
}

// MARK: - 自定义方法
extension  Register_vc {
    @objc func updateTime( _ timer: Timer) {
        remainingSeconds -= 1
    }
}
