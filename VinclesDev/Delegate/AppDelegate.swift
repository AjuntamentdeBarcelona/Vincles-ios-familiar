//
//  AppDelegate.swift
//  Vincles BCN
//
//  Copyright © 2018 i2Cat. All rights reserved.


import UIKit
import CoreData
import RealmSwift
import SlideMenuControllerSwift
import UserNotifications
import PushKit
import IQKeyboardManagerSwift
import Fabric
import Crashlytics
import SwiftyJSON
import Reachability
import StoreKit
import VersionControl
import CoreDataManager
import CryptoSwift
import Alamofire

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var showingCallVC: OutgoingCallViewController?
    
    var navigated = false
    
    var window: UIWindow?
    var versionLanguage = ""
    
    let reachability = Reachability()!
    
    let dbVersion: UInt64 = 33
    
    var registrationToken: String?
    let messageKey = "onMessageReceived"
    let serialQueueNotisAppD = DispatchQueue(label: "com.vincles.serialQueueNotisAD")
    var splashVC: SplashScreenViewController?
    
    var batteryLevel: Float {
        return UIDevice.current.batteryLevel
    }
    
    var batteryState: UIDeviceBatteryState {
        return UIDevice.current.batteryState
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        UserDefaults.standard.setValue(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
        UIDevice.current.isBatteryMonitoringEnabled = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(batteryLevelDidChange), name: .UIDeviceBatteryLevelDidChange, object: nil)
        
        let _ = CallManager.sharedInstance
        
        if UserDefaults.standard.value(forKey: "tamanyLletra") == nil{
            UserDefaults.standard.set("MITJA", forKey: "tamanyLletra")
        }
        
        if UserDefaults.standard.value(forKey: "saveToCameraRoll") == nil{
            UserDefaults.standard.set(true, forKey: "saveToCameraRoll")
        }
        
        
        startReachability()
        
        UIApplication.shared.statusBarStyle = .lightContent
        //  Crashlytics().debugMode = true
        NotificationCenter.default.addObserver(self, selector: #selector(AppDelegate.rotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        Fabric.with([Crashlytics.self])
        
        // PUSH CONFIG
        
        startPush(application: application)
        //  NotificationManager.loadLastProcessNotiEpoch()
        
        IQKeyboardManager.shared.enable = true
        
        configDatabase()
        setInitialLanguage()
        configMenu()
        configEnvironmentVars()
        self.controlVersion()
        configAnalytics()
        
        
        if !navigated{
            let splash = StoryboardScene.Splash.splashScreenViewController.instantiate()
            
            self.window?.rootViewController = SlideMenuController(mainViewController: UINavigationController(rootViewController: splash) , leftMenuViewController: StoryboardScene.Menu.leftMenuTableViewController.instantiate())
            
        }
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserCercle")
        
        do {
            let results = try context.fetch(fetchRequest)
            
            print(results.count)
        }catch let err as NSError {
            print(err.debugDescription)
        }
        
        let fetchRequestMissatge = NSFetchRequest<NSFetchRequestResult>(entityName: "Missatges")
        
        do {
            let results = try context.fetch(fetchRequestMissatge)
            
            print(results.count)
        }catch let err as NSError {
            print(err.debugDescription)
        }
        
        
        
        return true
    }
    
    func configAnalytics(){
        var configureError:NSError? = nil
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google Analytics services: \(configureError)")
        let gai = GAI.sharedInstance()
        _ = GAI.sharedInstance().tracker(withTrackingId: GA_TRACKING)
        gai?.trackUncaughtExceptions = true
        // gai?.logger.logLevel = GAILogLevel.verbose
    }
    
    func controlVersion () {
        print ("CONTROL VERSION")
        
        let instanceOfAlert: T21AlertComponent = T21AlertComponent()
        
        instanceOfAlert.showAlert(withService: VERSION_CONTROL_URL, withLanguage:UserDefaults.standard.string(forKey: "i18n_language"), andCompletionBlock:
            { (error: Error?) in
                // this is where the completion handler code goes
                
                if let error=error {
                    print("ERROR CONTROLVERSION: ",error)
                }
        })
        
    }
    
    func startReachability(){
        reachability.whenReachable = { reachability in
            if reachability.connection == .wifi {
                print("Reachable via WiFi")
            } else {
                print("Reachable via Cellular")
            }
        }
        reachability.whenUnreachable = { _ in
            self.showNetworkPopup()
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
    @objc func batteryLevelDidChange(_ notification: Notification) {
        print(batteryLevel)
        if batteryState == .unplugged && batteryLevel == 0.2{
            showBatteryPopup(level: batteryLevel)
        }
        else if batteryState == .unplugged && batteryLevel == 0.1{
            showBatteryPopup(level: batteryLevel)
        }
        else if batteryState == .unplugged && batteryLevel == 0.05{
            showBatteryPopup(level: batteryLevel)
        }
        
        
    }
    
    func showBatteryPopup(level: Float){
        
        let battery = String(format: "%.0f", level*100)
        
        let popupVC = StoryboardScene.Popup.popupViewController.instantiate()
        popupVC.delegate = self
        popupVC.modalPresentationStyle = .overCurrentContext
        popupVC.popupTitle = L10n.appName
        popupVC.popupDescription = L10n.batteryLow("\(battery)%")
        popupVC.button1Title = L10n.ok
        
        let alertWindow = UIWindow(frame: UIScreen.main.bounds)
        alertWindow.rootViewController = UIViewController()
        alertWindow.windowLevel = UIWindowLevelAlert + 11;
        alertWindow.makeKeyAndVisible()
        
        alertWindow.rootViewController?.present(popupVC, animated: true, completion: nil)
    }
    
    func showNetworkPopup(){
        
        let popupVC = StoryboardScene.Popup.popupViewController.instantiate()
        popupVC.delegate = self
        popupVC.modalPresentationStyle = .overCurrentContext
        popupVC.popupTitle = L10n.appName
        popupVC.popupDescription = L10n.noNetwork
        popupVC.button1Title = L10n.ok
        
        let alertWindow = UIWindow(frame: UIScreen.main.bounds)
        alertWindow.rootViewController = UIViewController()
        alertWindow.windowLevel = UIWindowLevelAlert + 10;
        alertWindow.makeKeyAndVisible()
        
        alertWindow.rootViewController?.present(popupVC, animated: true, completion: nil)
        
    }
    
    @objc func rotated() {
        HUDHelper.sharedInstance.manageRotation()
        if UIDeviceOrientationIsLandscape(UIDevice.current.orientation) {
            print("Landscape")
        }
        
        if UIDeviceOrientationIsPortrait(UIDevice.current.orientation) {
            print("Portrait")
        }
        
    }
    
    func configEnvironmentVars(){
        
        let envName = Bundle.main.infoDictionary!["ENVIRONMENT"] as! String
        var envKeys = "env_keys"
        envKeys.append(envName)
        print(envKeys)
        let envKeysPlist = Bundle.main.path(forResource: envKeys, ofType: "plist")!
        if let envDict = NSDictionary(contentsOfFile: envKeysPlist) as? [String: String]{
            print(envDict)

            IP = envDict["api_base_url"]!
            BASIC_AUTH_STR = envDict["api_key"]!
            SERVER_HOST_URL = envDict["vc_base_url"]!
            TENANT = envDict["TENANT"]!
            URL_PATH = envDict["URL_PATH"]!
            SUFFIX_LOGIN = envDict["SUFFIX_LOGIN"]!
            USERNAME_SUFFIX = envDict["USERNAME_SUFFIX"]!
            STUN_SERVER_URL = envDict["STUN_SERVER_URL"]!
            TURN_SERVER_UDP = envDict["TURN_SERVER_UDP"]!
            TURN_SERVER_UDP_USERNAME = envDict["TURN_SERVER_UDP_USERNAME"]!
            TURN_SERVER_UDP_PASSWORD = envDict["TURN_SERVER_UDP_PASSWORD"]!
            TURN_SERVER_TCP = envDict["TURN_SERVER_TCP"]!
            TURN_SERVER_TCP_USERNAME = envDict["TURN_SERVER_TCP_USERNAME"]!
            TURN_SERVER_TCP_PASSWORD = envDict["TURN_SERVER_TCP_PASSWORD"]!
        }
        var configKeys = "config_keys"
        configKeys.append(envName)
        let configKeysPlist = Bundle.main.path(forResource: configKeys, ofType: "plist")!
        if let configDict = NSDictionary(contentsOfFile: configKeysPlist) as? [String: String]{
            print(configDict)
            VERSION_CONTROL_URL = configDict["control_version_url"]!
            GA_TRACKING = configDict["analytic_key"]!
        }
    }
    
    func configDatabase(){
        let config = Realm.Configuration(
            schemaVersion: dbVersion,
            migrationBlock: { migration, oldSchemaVersion in
                if (oldSchemaVersion < self.dbVersion) {
                }
        })
        Realm.Configuration.defaultConfiguration = config
        _ = try! Realm()
    }
    
    func setInitialLanguage(){
        print(UserDefaults.standard.string(forKey: "i18n_language"))
        
        if let _ = UserDefaults.standard.string(forKey: "i18n_language") {} else {
            if(Locale.current.languageCode == "es"){
                UserDefaults.standard.set("es", forKey: "i18n_language")
            }
            else{
                UserDefaults.standard.set("ca", forKey: "i18n_language")
            }
            UserDefaults.standard.synchronize()
        }
    }
    
    func configMenu(){
        SlideMenuOptions.contentViewScale = 1
        
        let screenWidth  = UIScreen.main.fixedCoordinateSpace.bounds.width
        (UIDevice.current.userInterfaceIdiom == .pad) ? (SlideMenuOptions.leftViewWidth = screenWidth * 0.4) : (SlideMenuOptions.leftViewWidth = screenWidth * 0.8)
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        window?.endEditing(true)
        
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        self.controlVersion()

        
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "SingleViewCoreData")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    
}

extension AppDelegate{
    
    
    func pushLaunchOptions(notification: [String: AnyObject]){
        // 2
        let aps = notification["aps"] as! [String: AnyObject]
        
    }
    
    func startPush(application: UIApplication){
        self.registerVoIPPush()
        
        UNUserNotificationCenter.current().delegate = self
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: {_, _ in })
        
        application.registerForRemoteNotifications()
    }
    
    
    
    func application(
        _ application: UIApplication,
        didReceiveRemoteNotification userInfo: [AnyHashable : Any],
        fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        let aps = userInfo["aps"] as! [String: AnyObject]
        
        
        /*
         NotificationCenter.default.post(
         name: Notification(name: "onMessageReceived"),
         object: self,
         userInfo: userInfo
         )
         
         handler(UIBackgroundFetchResult.NewData);
         */
    }
    
    func getNotificationSettings() {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().getNotificationSettings { (settings) in
                UIApplication.shared.registerForRemoteNotifications()
            }
        } else {
            // Fallback on earlier versions
        }
    }
    
    func registerForPushNotifications() {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
                (granted, error) in
                self.getNotificationSettings()
                
            }
        } else {
            // Fallback on earlier versions
        }
    }
    
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data -> String in
            print(String(format: "%02.2hhx", data))
            return String(format: "%02.2hhx", data)
        }
        
        let token = tokenParts.joined()
        
        ()
        
    }
    
    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
    }
    
    
    
    func registerVoIPPush() {
        let voipPushResgistry = PKPushRegistry(queue: DispatchQueue.main)
        voipPushResgistry.delegate = self
        voipPushResgistry.desiredPushTypes = [PKPushType.voIP]
    }
    
    
}

extension AppDelegate: UNUserNotificationCenterDelegate{
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Swift.Void){
        
        print(response.notification.request.identifier)
        print(response.notification.request.content.categoryIdentifier)
        
        
        let idString = response.notification.request.identifier
        let comps = idString.components(separatedBy: "_")
        
        
        var chatFrom: Int? = nil
        var idChat: Int? = nil
        var idUser: Int? = nil
        var idGroup: Int? = nil
        var idMeeting: Int? = nil
        var idHost: Int? = nil
        var code: String?
        
        switch response.notification.request.content.categoryIdentifier{
        case NOTI_NEW_MESSAGE:
            if let idInt = Int(comps[0]){
                chatFrom = idInt
            }
        case NOTI_NEW_CHAT_MESSAGE:
            if let idInt = Int(comps[0]){
                idChat = idInt
            }
        case NOTI_USER_LEFT_CIRCLE, NOTI_USER_UNLINKED, NOTI_USER_LINKED, NOTI_USER_UPDATED:
            if let idInt = Int(comps[0]){
                idUser = idInt
            }
        case NOTI_ADDED_TO_GROUP, NOTI_REMOVED_FROM_GROUP:
            if let idInt = Int(comps[0]){
                idGroup = idInt
            }
        case NOTI_NEW_USER_GROUP, NOTI_REMOVED_USER_GROUP:
            if let idInt = Int(comps[0]){
                idGroup = idInt
            }
        case NOTI_MEETING_INVITATION_EVENT,NOTI_MEETING_REJECTED_EVENT, NOTI_MEETING_ACCEPTED_EVENT, NOTI_MEETING_CHANGED_EVENT, NOTI_MEETING_INVITATION_REVOKE_EVENT, NOTI_MEETING_INVITATION_DELETED_EVENT, NOTI_MEETING_DELETED_EVENT:
            if let idInt = Int(comps[0]){
                idMeeting = idInt
            }
        case NOTI_INCOMING_CALL:
            if let idInt = Int(comps[0]){
                idUser = idInt
            }
        case NOTI_GROUP_USER_INVITATION_CIRCLE:
            let idInt = comps[0]
            code = idInt
            
        default:
            break
        }
        
        
        if let slideMenuController = self.window?.rootViewController as? SlideMenuController{
            
            
            
            let baseVC = StoryboardScene.Base.baseViewController.instantiate()
            
            if let chatFrom = chatFrom{
                let circlesModelManager = CirclesGroupsModelManager()
                
                if (circlesModelManager.contactWithId(id: chatFrom) != nil){
                    let chatVC = StoryboardScene.Chat.chatContainerViewController.instantiate()
                    let circlesModelManager = CirclesGroupsModelManager()
                    chatVC.toUserId = chatFrom
                    chatVC.toUser = circlesModelManager.contactWithId(id: chatFrom)
                    chatVC.showBackButton = true
                    if !navigated{
                        chatVC.openHomeOnBack = true
                    }
                    baseVC.containedViewController = chatVC
                    if let nav = slideMenuController.mainViewController as? UINavigationController{
                        nav.pushViewController(baseVC, animated: true)
                    }
                }
                else{
                    let notsVC = StoryboardScene.Notifications.notificationsViewController.instantiate()
                    notsVC.showBackButton = true
                    if !navigated{
                        notsVC.openHomeOnBack = true
                    }
                    baseVC.containedViewController = notsVC
                    if let nav = slideMenuController.mainViewController as? UINavigationController{
                        nav.pushViewController(baseVC, animated: true)
                    }
                }
                
                
            }
            else if let idChat = idChat{
                let circlesModelManager = CirclesGroupsModelManager()
                if circlesModelManager.userGroupWithIdChat(idChat: idChat) != nil || circlesModelManager.dinamitzadorWithChatId(idChat: idChat) != nil{
                    let chatVC = StoryboardScene.Chat.chatContainerViewController.instantiate()
                    if !navigated{
                        chatVC.openHomeOnBack = true
                    }
                    
                    if let group = circlesModelManager.groupWithChatId(idChat: idChat){
                        chatVC.group = group
                    }
                    else if let dinamitzadorGroup = circlesModelManager.dinamitzadorWithChatId(idChat: idChat){
                        chatVC.group = dinamitzadorGroup
                        chatVC.isDinam = true
                    }
                    
                    chatVC.showBackButton = true
                    if !navigated{
                        chatVC.openHomeOnBack = true
                    }
                    baseVC.containedViewController = chatVC
                    if let nav = slideMenuController.mainViewController as? UINavigationController{
                        nav.pushViewController(baseVC, animated: true)
                    }
                    
                }
                else{
                    let notsVC = StoryboardScene.Notifications.notificationsViewController.instantiate()
                    notsVC.showBackButton = true
                    if !navigated{
                        notsVC.openHomeOnBack = true
                    }
                    baseVC.containedViewController = notsVC
                    if let nav = slideMenuController.mainViewController as? UINavigationController{
                        nav.pushViewController(baseVC, animated: true)
                    }
                }
                
            }
            else if idUser != nil{
                switch response.notification.request.content.categoryIdentifier{
                case  NOTI_USER_LINKED:
                    let circlesModelManager = CirclesGroupsModelManager()
                    
                    if (circlesModelManager.contactWithId(id: idUser!) != nil){
                        let chatVC = StoryboardScene.Chat.chatContainerViewController.instantiate()
                        chatVC.toUserId = idUser!
                        chatVC.toUser = circlesModelManager.contactWithId(id: idUser!)
                        chatVC.showBackButton = true
                        if !navigated{
                            chatVC.openHomeOnBack = true
                        }
                        baseVC.containedViewController = chatVC
                        if let nav = slideMenuController.mainViewController as? UINavigationController{
                            nav.pushViewController(baseVC, animated: true)
                        }
                    }
                    else{
                        let notsVC = StoryboardScene.Notifications.notificationsViewController.instantiate()
                        notsVC.showBackButton = true
                        if !navigated{
                            notsVC.openHomeOnBack = true
                        }
                        baseVC.containedViewController = notsVC
                        if let nav = slideMenuController.mainViewController as? UINavigationController{
                            nav.pushViewController(baseVC, animated: true)
                        }
                    }
                    
                case NOTI_INCOMING_CALL:
                    let circlesModelManager = CirclesGroupsModelManager()
                    
                    if (circlesModelManager.contactWithId(id: idUser!) != nil){
                        let chatVC = StoryboardScene.Chat.chatContainerViewController.instantiate()
                        
                        let circlesManager = CirclesGroupsModelManager()
                        if circlesManager.contactWithId(id: idUser!) != nil{
                            chatVC.toUserId = idUser!
                            chatVC.toUser = circlesModelManager.contactWithId(id: idUser!)
                        }
                        else if let userObj = circlesManager.dinamitzadorWithId(id: idUser!){
                            var groupFound: Group?
                            if let groups = circlesManager.groups{
                                for group in groups{
                                    if let dinam = group.dynamizer{
                                        if dinam.id == userObj.id{
                                            groupFound = group
                                            break
                                        }
                                    }
                                }
                            }
                            if let groupFound = groupFound{
                                chatVC.isDinam = true
                                chatVC.group = groupFound
                            }
                            
                        }
                        
                        if !navigated{
                            chatVC.openHomeOnBack = true
                        }
                        chatVC.showBackButton = true
                        baseVC.containedViewController = chatVC
                        if let nav = slideMenuController.mainViewController as? UINavigationController{
                            nav.pushViewController(baseVC, animated: true)
                        }
                    }
                    else{
                        let notsVC = StoryboardScene.Notifications.notificationsViewController.instantiate()
                        notsVC.showBackButton = true
                        if !navigated{
                            notsVC.openHomeOnBack = true
                        }
                        baseVC.containedViewController = notsVC
                        if let nav = slideMenuController.mainViewController as? UINavigationController{
                            nav.pushViewController(baseVC, animated: true)
                        }
                    }
                    
                default:
                    let contactsVC = StoryboardScene.Contacts.contactsViewController.instantiate()
                    contactsVC.showBackButton = true
                    baseVC.containedViewController = contactsVC
                    if let nav = slideMenuController.mainViewController as? UINavigationController{
                        nav.pushViewController(baseVC, animated: true)
                    }
                }
                
            }
            else if idGroup != nil{
                switch response.notification.request.content.categoryIdentifier{
                case NOTI_REMOVED_FROM_GROUP:
                    let contactsVC = StoryboardScene.Contacts.contactsViewController.instantiate()
                    contactsVC.showBackButton = true
                    contactsVC.filterContactsType = .groups
                    baseVC.containedViewController = contactsVC
                    if !navigated{
                        contactsVC.openHomeOnBack = true
                    }
                    if let nav = slideMenuController.mainViewController as? UINavigationController{
                        nav.pushViewController(baseVC, animated: true)
                    }
                case NOTI_ADDED_TO_GROUP:
                    let chatVC = StoryboardScene.Chat.chatContainerViewController.instantiate()
                    let circlesModelManager = CirclesGroupsModelManager()
                    if (circlesModelManager.userGroupWithId(id: idGroup!) != nil){
                        chatVC.group = circlesModelManager.groupWithId(id: idGroup!)
                        chatVC.showBackButton = true
                        baseVC.containedViewController = chatVC
                        if !navigated{
                            chatVC.openHomeOnBack = true
                        }
                        if let nav = slideMenuController.mainViewController as? UINavigationController{
                            nav.pushViewController(baseVC, animated: true)
                        }
                    }
                    else{
                        let notsVC = StoryboardScene.Notifications.notificationsViewController.instantiate()
                        notsVC.showBackButton = true
                        if !navigated{
                            notsVC.openHomeOnBack = true
                        }
                        baseVC.containedViewController = notsVC
                        if let nav = slideMenuController.mainViewController as? UINavigationController{
                            nav.pushViewController(baseVC, animated: true)
                        }
                    }
                    
                case NOTI_NEW_USER_GROUP, NOTI_REMOVED_USER_GROUP, NOTI_ADDED_TO_GROUP:
                    let circlesModelManager = CirclesGroupsModelManager()
                    if (circlesModelManager.userGroupWithId(id: idGroup!) != nil){
                        let groupVC = StoryboardScene.Chat.groupInfoViewController.instantiate()
                        groupVC.showBackButton = true
                        baseVC.containedViewController = groupVC
                        let circlesModelManager = CirclesGroupsModelManager()
                        groupVC.group = circlesModelManager.groupWithId(id: idGroup!)
                        if !navigated{
                            groupVC.openHomeOnBack = true
                        }
                        if let nav = slideMenuController.mainViewController as? UINavigationController{
                            nav.pushViewController(baseVC, animated: true)
                        }
                    }
                    else{
                        let notsVC = StoryboardScene.Notifications.notificationsViewController.instantiate()
                        notsVC.showBackButton = true
                        if !navigated{
                            notsVC.openHomeOnBack = true
                        }
                        baseVC.containedViewController = notsVC
                        if let nav = slideMenuController.mainViewController as? UINavigationController{
                            nav.pushViewController(baseVC, animated: true)
                        }
                    }
                    
                default:
                    break
                }
                
            }
            else if idMeeting != nil{
                
                switch response.notification.request.content.categoryIdentifier{
                case NOTI_MEETING_INVITATION_EVENT,NOTI_MEETING_REJECTED_EVENT, NOTI_MEETING_ACCEPTED_EVENT, NOTI_MEETING_CHANGED_EVENT :
                    let meetingsModelManager = AgendaModelManager()
                    if meetingsModelManager.userMeetingWithId(id: idMeeting!) != nil{
                        let meetingVC = StoryboardScene.Agenda.agendaEventDetailViewController.instantiate()
                        meetingVC.showBackButton = true
                        if !navigated{
                            meetingVC.openHomeOnBack = true
                        }
                        baseVC.containedViewController = meetingVC
                        let agendaModelManager = AgendaModelManager()
                        meetingVC.meeting = agendaModelManager.meetingWithId(id: idMeeting!)
                        if let nav = slideMenuController.mainViewController as? UINavigationController{
                            nav.pushViewController(baseVC, animated: true)
                        }
                    }
                    else{
                        let notsVC = StoryboardScene.Notifications.notificationsViewController.instantiate()
                        notsVC.showBackButton = true
                        if !navigated{
                            notsVC.openHomeOnBack = true
                        }
                        baseVC.containedViewController = notsVC
                        if let nav = slideMenuController.mainViewController as? UINavigationController{
                            nav.pushViewController(baseVC, animated: true)
                        }
                    }
                    
                case NOTI_MEETING_INVITATION_REVOKE_EVENT, NOTI_MEETING_DELETED_EVENT:
                    let agendaModelManager = AgendaModelManager()
                    if let meeting = agendaModelManager.userMeetingWithId(id: idMeeting!){
                        
                        let agendaVC = StoryboardScene.Agenda.agendaContainerViewController.instantiate()
                        agendaVC.showBackButton = true
                        baseVC.containedViewController = agendaVC
                        agendaVC.preloadOtherDate = Date(timeIntervalSince1970: TimeInterval(meeting.date / 1000))
                        
                        if !navigated{
                            agendaVC.openHomeOnBack = true
                        }
                        /*
                         let agendaVC = StoryboardScene.Agenda.ndaDayViewController.instantiate()
                         agendaVC.selectedDate = Date(timeIntervalSince1970: TimeInterval(meeting.date / 1000))
                         let baseVC = StoryboardScene.Base.baseViewController.instantiate()
                         agendaVC.showBackButton = true
                         */
                        baseVC.containedViewController = agendaVC
                        if let nav = slideMenuController.mainViewController as? UINavigationController{
                            nav.pushViewController(baseVC, animated: true)
                        }
                    }
                    else{
                        let notsVC = StoryboardScene.Notifications.notificationsViewController.instantiate()
                        notsVC.showBackButton = true
                        if !navigated{
                            notsVC.openHomeOnBack = true
                        }
                        baseVC.containedViewController = notsVC
                        if let nav = slideMenuController.mainViewController as? UINavigationController{
                            nav.pushViewController(baseVC, animated: true)
                        }
                    }
                    
                    
                default:
                    break
                    
                }
            }
            else if code != nil{
                
                let baseVC = StoryboardScene.Base.baseViewController.instantiate()
                
                let addContactVC = StoryboardScene.Contacts.addContactViewController.instantiate()
                addContactVC.code = code!
                addContactVC.showBackButton = true
                if !navigated{
                    addContactVC.openHomeOnBack = true
                }
                baseVC.containedViewController = addContactVC
                if let nav = slideMenuController.mainViewController as? UINavigationController{
                    nav.pushViewController(baseVC, animated: true)
                }
            }
            
            
            
            navigated = true
            
            
        }
        else{
            
            
            
            
            
            if CallManager.sharedInstance.client?.state != .connected || CallManager.sharedInstance.client == nil{
                
                let splashVC = StoryboardScene.Splash.splashScreenViewController.instantiate()
                splashVC.notificationType = response.notification.request.content.categoryIdentifier
                if let chatFrom = chatFrom{
                    splashVC.chatFrom = chatFrom
                }
                else if let idChat = idChat{
                    splashVC.idChat = idChat
                }
                else if let idUser = idUser{
                    splashVC.idUser = idUser
                }
                else if let idGroup = idGroup{
                    
                    switch response.notification.request.content.categoryIdentifier{
                    case NOTI_REMOVED_FROM_GROUP:
                        splashVC.idGroup = idGroup
                    case NOTI_NEW_USER_GROUP, NOTI_REMOVED_USER_GROUP, NOTI_ADDED_TO_GROUP:
                        splashVC.idOpenGroup = idGroup
                        
                    default:
                        break
                    }
                }
                else if let idMeeting = idMeeting{
                    splashVC.idMeeting = idMeeting
                }
                else if let code = code{
                    splashVC.code = code
                }
                self.window?.rootViewController = SlideMenuController(mainViewController: UINavigationController(rootViewController: splashVC) , leftMenuViewController: StoryboardScene.Menu.leftMenuTableViewController.instantiate())
            }
            
            
            
        }
        
        
        
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Swift.Void){
        completionHandler([.alert, .badge, .sound])
        
    }
}


extension AppDelegate : PKPushRegistryDelegate {
    
    
    func pushRegistry(_ registry: PKPushRegistry, didUpdate pushCredentials: PKPushCredentials, for type: PKPushType) {
        if type == PKPushType.voIP {
            print(pushCredentials.token.hexEncodedString())
            self.registrationToken = pushCredentials.token.hexEncodedString()
            let profileModelManager = ProfileModelManager()
            profileModelManager.setPushkitToken(token: pushCredentials.token.hexEncodedString())
        }
    }
    
    func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type: PKPushType) {
        let payloadDict = payload.dictionaryPayload["aps"] as? Dictionary<String, String>
        let message = payloadDict?["alert"]
        print(message)
        
        if UserDefaults.standard.bool(forKey: "loginDone"){
            
            if let message = message{
                if let notificationDict = JSON(parseJSON: message).dictionaryObject{
                    let notificationManager = NotificationManager()
                    
                    if let idUser = notificationDict["idUser"] as? Int ,  var idRoom = notificationDict["idRoom"] as? String,  let push_notification_time = notificationDict["push_notification_time"] as? Int64 , let idPush = notificationDict["id_push"] as? Int, let push_notification_type = notificationDict["push_notification_type"] as? String{
                        
                        if push_notification_type == NOTI_INCOMING_CALL{
                            let notificationsModelManager = NotificationsModelManager()
                            
                            _ = notificationsModelManager.getNextFakeNotificationId
                            
                            let notification = VincleNotification()
                            notification.type = NOTI_INCOMING_CALL
                            notification.id = idPush
                            
                            
                            
                            print(idRoom)
                            
                            notification.idRoom = idRoom
                            notification.idUser = idUser
                            

                            let realm = try! Realm()
                            
                            let callee = realm.objects(AuthResponse.self).first?.userId
                            let profileModelManager = ProfileModelManager()
                            if let user = profileModelManager.getUserMe(){
                                if let calleeInt = callee{
                                    if calleeInt == user.id{
                                        notification.creationTimeInt = push_notification_time
                                        notification.processed = true
                                        
                                        let realm = try! Realm()
                                        try! realm.write {
                                            realm.add(notification, update: true)
                                        }
                                        
                                        let notificationManager = NotificationManager()
                                        
                                        print("PUSH CALL")
                                        notificationManager.getServerTime(onSuccess: {
                                            
                                            if let timeInt = UserDefaults.standard.object(forKey: "loginTime") as? Int64{
                                                print(timeInt - push_notification_time)
                                                if timeInt - push_notification_time < 30000{
                                                    
                                                    if CallManager.sharedInstance.roomName == nil{
                                                        notificationManager.showLocalNotificationForNewCall(user: idUser, room: idRoom)
                                                        CallManager.sharedInstance.roomName = idRoom
                                                        CallManager.sharedInstance.vincleNotification = notification
                                                        
                                                        let baseVC = StoryboardScene.Base.baseViewController.instantiate()
                                                        let outgoingCallVC = StoryboardScene.Call.outgoingCallViewController.instantiate()
                                                        outgoingCallVC.incoming = true
                                                        let circlesModelManager = CirclesGroupsModelManager()
                                                        if let fromUser = circlesModelManager.userWithId(id: idUser){
                                                            outgoingCallVC.user = fromUser
                                                        }
                                                        baseVC.containedViewController = outgoingCallVC
                                                        
                                                        let alertWindow = UIWindow(frame: UIScreen.main.bounds)
                                                        alertWindow.rootViewController = UIViewController()
                                                        alertWindow.windowLevel = UIWindowLevelAlert + 5;
                                                        alertWindow.makeKeyAndVisible()
                                                        
                                                        if (self.showingCallVC != nil){
                                                            self.showingCallVC?.dismiss(animated: false, completion: {
                                                                alertWindow.rootViewController?.present(outgoingCallVC, animated: false, completion: nil)
                                                                
                                                            })
                                                        }
                                                        else{
                                                            alertWindow.rootViewController?.present(outgoingCallVC, animated: true, completion: nil)
                                                        }
                                                        
                                                        self.showingCallVC = outgoingCallVC
                                                        
                                                        
                                                    }
                                                    else{
                                                        notificationManager.showLocalNotificationForMissedCall(user: idUser, room: idRoom)
                                                    }
                                                    
                                                }
                                                else{
                                                    notificationManager.showLocalNotificationForMissedCall(user: idUser, room: idRoom)
                                                }
                                            }
                                            
                                        }) {
                                            
                                        }
                                        
                                    }
                                }
                            }
                        }
                        else if push_notification_type == NOTI_ERROR_IN_CALL{
                            if CallManager.sharedInstance != nil && CallManager.sharedInstance.roomName != nil{
                                CallManager.sharedInstance.receivedErrorInCall()
                            }
                            
                        }
                        
                        
                        
                        
                        
                    }
                    else if (notificationDict["id_push"] as? Int) != nil {
                        /*
                         let diceRoll = Int(arc4random_uniform(99999999) + 1)
                         
                         let content = UNMutableNotificationContent()
                         content.title = "titol"
                         content.body = "body"
                         
                         content.sound = UNNotificationSound.default()
                         content.categoryIdentifier = NOTI_NEW_MESSAGE
                         
                         
                         let request = UNNotificationRequest(identifier: "test\(Date().timeIntervalSince1970)\(diceRoll)", content: "testttt", trigger: nil)
                         UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
                         */
                        
                        print(message)
                        notificationManager.processNotification(noti: message)
                    }
                    
                }
            }
            
        }
        // processNotification(message!)
    }
    
    func pushRegistry(_ registry: PKPushRegistry, didInvalidatePushTokenFor type: PKPushType) {
        NSLog("token invalidated")
        
        let profileModelManager = ProfileModelManager()
        profileModelManager.removePushkitToken()
        
    }
    
    func processNotification(_ json:String) {
        
    }
    
    
}

extension AppDelegate : PopUpDelegate {
    func firstButtonClicked(popup: PopupViewController) {
        popup.dismissPopup {
            
        }
    }
    
    func secondButtonClicked(popup: PopupViewController) {
        popup.dismissPopup {
            
        }
    }
    
    
}


extension String {
    subscript (bounds: CountableClosedRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start...end])
    }
    
    subscript (bounds: CountableRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start..<end])
    }
}