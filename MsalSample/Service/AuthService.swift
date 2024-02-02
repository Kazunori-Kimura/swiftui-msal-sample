//
//  AuthService.swift
//  MsalSample
//
//  Created by Kazunori Kimura on 2024/02/01.
//

import Foundation
import Factory
import MSAL
import OSLog

protocol AuthServiceProtocol {
    func setupView()
    func login(withInteraction: Bool)
    func logout()
    func openUrl(url: URL)
}

class AuthService: AuthServiceProtocol {
    @Injected(\.appContext)
    private var appContext
    // B2C キー
    @Injected(\.authCredentials)
    private var authCredentials
    
    // MSAL で使用するなにか
    
    private var context: MSALPublicClientApplication?
    private var webViewParamaters: MSALWebviewParameters?
    private var msAccount: MSALAccount?
    
    init() {
        do {
            try self.initContext()
        } catch let error {
            Logger.auth.error("\(#function): Failed to create MSALPublicClientApplication. \(String(describing: error))")
        }
    }
    
    // --- public ---
    
    /**
     * 認証 View の設定
     */
    func setupView() {
        Logger.auth.info(#function)
        if let viewController = UIApplication.topViewController {
            Logger.auth.debug("\(#function): create webViewParameters.")
            webViewParamaters = MSALWebviewParameters(authPresentationViewController: viewController)
        }
    }
    
    /**
     * ログインしてトークンを取得する
     */
    func login(withInteraction: Bool) {
        Logger.auth.info("\(#function): \(withInteraction)")
        
        loadAccount { account in
            // トークンを取得する
            if account != nil {
                // 認証画面を表示せずにトークンを更新
                self.acquireTokenSilently()
            } else if withInteraction {
                // 認証画面を表示する
                self.acquireTokenInteractively()
            } else {
                // ユーザー情報が確認できない
                // -> 認証データをクリアする
                self.logout()
            }
        }
    }
    
    /**
     * ログアウト
     */
    func logout() {
        Logger.auth.info(#function)
        guard let context = self.context,
              let account = self.msAccount
        else { return }
        
        guard let webViewParamaters = self.webViewParamaters else { return }
        
        let params = MSALSignoutParameters(webviewParameters: webViewParamaters)
        context.signout(with: account, signoutParameters: params) { (_, error) in
            if let error = error {
                Logger.auth.error("\(#function): \(String(describing: error))")
                return
            }
            
            self.msAccount = nil
            self.setAccount(nil)
            Logger.auth.info("\(#function): signout completed successfully.")
        }
    }
    
    /**
     * 認証完了後に呼ばれる
     */
    func openUrl(url: URL) {
        Logger.auth.info("\(#function): \(String(describing: url))")
        MSALPublicClientApplication.handleMSALResponse(url, sourceApplication: nil)
    }
    
    // --- private ---
    
    /**
     * MSALPublicClientApplication の初期化
     */
    private func initContext() throws {
        Logger.auth.debug("\(#function): \(String(describing: self.authCredentials.appId))")
        let authority = try MSALB2CAuthority(url: URL(string: authCredentials.authorityUrl)!)
//        let domain = try MSALB2CAuthority(url: URL(string: authCredentials.domain)!)
        let redirectUri = "msauth.\(Bundle.main.bundleIdentifier!)://auth"
        Logger.auth.debug("\(#function): redirectUri = \(redirectUri)")
        
        let config = MSALPublicClientApplicationConfig(
            clientId: authCredentials.appId,
            redirectUri: redirectUri,
            authority: authority
        )
        config.knownAuthorities = [authority]
        context = try MSALPublicClientApplication(configuration: config)
    }
    
    /**
     * アカウントの読み込み
     */
    private func loadAccount(completion: ((MSALAccount?) -> Void)?) {
        guard let cntx = context else { return }
        
        let params = MSALParameters()
        params.completionBlockQueue = DispatchQueue.main
        
        cntx.getCurrentAccount(with: params) { (account, _, error) in
            if let error = error {
                Logger.auth.error("\(#function): \(String(describing: error))")
                return
            }
            
            if let account = account {
                Logger.auth.debug("\(#function): account = \(String(describing: account))")
                
                // アカウントデータを保持
                self.msAccount = account
                completion?(account)
                return
            }
            
            // アカウント情報が存在しない -> ログアウトした
            Logger.auth.debug("\(#function): signed out.")
            self.msAccount = nil
            self.setAccount(nil)
            completion?(nil)
        }
    }
    
    /**
     * アカウント情報を更新する
     */
    private func setAccount(_ account: MSALAccount?) {
        DispatchQueue.main.async {
            self.appContext.userIsLogedIn = account != nil
            if account == nil {
                self.appContext.accessToken = nil
            }
        }
    }
    /**
     * トークンの更新
     */
    private func setAccount(token: String?) {
        DispatchQueue.main.async {
            self.appContext.userIsLogedIn = token != nil
            self.appContext.accessToken = token
        }
    }
    
    /**
     * ログイン画面を表示してトークンを取得する
     */
    private func acquireTokenInteractively() {
        guard let context = self.context,
              let webViewParamaters = self.webViewParamaters else {
            return
        }
        
        let params = MSALInteractiveTokenParameters(
            scopes: self.authCredentials.scopes,
            webviewParameters: webViewParamaters)
        params.promptType = .selectAccount
        params.authority = try? MSALB2CAuthority(url: URL(string: self.authCredentials.authorityUrl)!)
        
        context.acquireToken(with: params) { (result, error) in
            if let error = error {
                Logger.auth.error("\(#function): \(String(describing: error))")
                return
            }
            
            guard let account = result?.account,
                  let token = result?.accessToken
            else {
                Logger.auth.error("\(#function): No result returned.")
                return
            }
            
            self.msAccount = account
            self.setAccount(token: token)
            
            Logger.auth.info("\(#function): AccessToken is acquired. (account = \(String(describing: account)), accessToken = \(token.prefix(5))...")
            dump(account)
        }
    }
    
    /**
     * トークンの更新を行う
     */
    private func acquireTokenSilently() {
        guard let context = self.context,
              let account = self.msAccount else {
            return
        }
        
        let params = MSALSilentTokenParameters(
            scopes: self.authCredentials.scopes,
            account: account)
        params.authority = try? MSALB2CAuthority(url: URL(string: self.authCredentials.authorityUrl)!)
        
        context.acquireTokenSilent(with: params) { (result, error) in
            if let error = error {
                if let nsError = error as NSError? {
                    if nsError.domain == MSALErrorDomain &&
                        nsError.code == MSALError.interactionRequired.rawValue {
                        Logger.auth.warning("\(#function): interaction required.")
                        // 対話的ログインが必要
                        DispatchQueue.main.async {
                            self.acquireTokenInteractively()
                        }
                        return
                    }
                }
                
                Logger.auth.error("\(#function): \(String(describing: error))")
                return
            }
            
            guard let account = result?.account,
                  let token = result?.accessToken else {
                Logger.auth.error("\(#function): No result returned.")
                return
            }
            
            self.msAccount = account
            self.setAccount(token: token)
            
            Logger.auth.info("\(#function): AccessToken is acquired.")
        }
    }
}
