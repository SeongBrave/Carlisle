//
//  Login_vm.swift
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

class Login_vm : Base_Vm {
    
    let validatedPassword =  Variable<ValidationResult>(.empty)
    let validatedUsername = Variable<ValidationResult>(.empty)
    
    let signupEnabled = Variable<Bool>(false)
    let loading = ActivityIndicator()
    
    let loginSuccess = PublishSubject<User_Model>()
    
    init(input: (
        username: Observable<String>,
        password: Observable<String>,
        loginTaps: Observable<Void>
        ),
         validationService: LoginValidationProtocol
        ) {
        
        super.init()
        
        input.loginTaps
            .withLatestFrom(Observable.combineLatest(input.username, input.password) { ($0, $1) })
            .map{Carlisle_api.login(phone: $0, password: $1)}
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
        
        input.username
            .map{validationService.validateUsername($0)}
            .bind(to: validatedUsername)
            .disposed(by: disposeBag)
        
        input.password
            .map{ validationService.validatePassword($0)}
            .bind(to: validatedPassword)
            .disposed(by: disposeBag)
        
        Observable
            .combineLatest(
                validatedUsername.asObservable(),
                validatedPassword.asObservable(),
                loading.asObservable()
            ){$0.isValid && $1.isValid && (!$2)}
            .distinctUntilChanged()
            .bind(to: signupEnabled)
            .disposed(by: disposeBag)
    }
}
