//
//  Register_vm.swift
//  Carlisle
//
//  Created by Gckit on 2019/04/07.
//  Copyright (c) 2019 SeongBrave. All rights reserved.
//

import RxSwift
import NetWorkCore
import SwiftyJSON
import UtilCore
import Result
import Bella
import ModelProtocol

class Register_vm : BaseList_Vm {
    
    let validatedPhone = Variable<ValidationResult>(.empty)
    let validatedMsgCode = Variable<ValidationResult>(.empty)
    let validatedPassword =  Variable<ValidationResult>(.empty)
    
    let signupEnabled = Variable<Bool>(false)
    let loading = ActivityIndicator()
    
    let loginSuccess = PublishSubject<User_Model>()
    let sendMsgSuccess = PublishSubject<JSON>()
    
    private var isValidated:(isOk:Bool ,error:String) = (true,"")
    
    init(input: (
        phone: Observable<String>,
        msgCode: Observable<String>,
        password: Observable<String>,
        registerTaps: Observable<Void>,
        msgCodeTaps: Observable<Void>
        ),
         validationService: RegisterValidationProtocol
        ) {
        
        super.init()
        
        input.phone
            .map{validationService.validatePhone($0)}
            .bind(to: validatedPhone)
            .disposed(by: disposeBag)
        
        input.msgCode
            .map{validationService.validateMsgCode($0)}
            .bind(to: validatedMsgCode)
            .disposed(by: disposeBag)
        
        input.password
            .map{ validationService.validatePassword($0)}
            .bind(to: validatedPassword)
            .disposed(by: disposeBag)
        
        input.msgCodeTaps
            .withLatestFrom(input.phone)
            .filter { (phone) -> Bool in
                let rel = validationService.validatePhone(phone)
                if rel.isValid == false{
                    self.error.onNext(MikerError("获取短信验证码时需要验证手机号", code: 2202, message: rel.message))
                }
                return rel.isValid
            }
            .map{Carlisle_api.sendmsgcode(phone: $0)}
            .emeRequestApiForRegJson()
            .subscribe(onNext: {[unowned self] (result) in
                switch result {
                case .success(let data):
                    self.sendMsgSuccess.onNext(data)
                case .failure(let error):
                    self.error.onNext(error)
                }
            })
            .disposed(by: disposeBag)
        
        //显示错误原因
        input.registerTaps
            .filter { _ in !self.isValidated.isOk }
            .subscribe(onNext: {[unowned self] (_) in
                self.error.onNext(MikerError("文本录入错误", code: 2201, message: self.isValidated.error))
            })
            .disposed(by: disposeBag)
        
        input.registerTaps
            .filter { _ in self.isValidated.isOk }
            .withLatestFrom(Observable.combineLatest(input.phone, input.password, input.msgCode) { ($0, $1, $2) })
            .map{Carlisle_api.register(phone: $0, password: $1, msgCode: $2)}
            .emeRequestApiForObj(User_Model.self, activityIndicator: loading)
            .subscribe(onNext: {[unowned self] (result) in
                switch result {
                case .success(let user):
                    //登陆成功就更新上下文中的登陆对象
                    Global.updateUserModel(user)
                    self.loginSuccess.onNext(user)
                case .failure(let error):
                    self.error.onNext(error)
                }
            })
            .disposed(by: disposeBag)
        
        //只有文明不为空即可以点击
        Observable
            .combineLatest(
                validatedPhone.asObservable(),
                validatedMsgCode.asObservable(),
                validatedPassword.asObservable(),
                loading.asObservable()
            ){$0.notEmpty && $1.notEmpty && $2.notEmpty && (!$3)}
            .distinctUntilChanged()
            .bind(to: signupEnabled)
            .disposed(by: disposeBag)
        
        //记录错误原因
        Observable.combineLatest(
            validatedPhone.asObservable(),
            validatedMsgCode.asObservable(),
            validatedPassword.asObservable()
        ) { (item1, item2,item3) -> (isOk:Bool ,error:String) in
            if !item1.isValid {
                return (false,item1.message)
            }
            if !item2.isValid {
                return (false,item2.message)
            }
            if !item3.isValid {
                return (false,item3.message)
            }
            return (true,"")
            }
            .subscribe(onNext: { [unowned self] (item) in
                self.isValidated = item
            })
            .disposed(by: disposeBag)
    }
}
