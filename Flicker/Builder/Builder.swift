//
//  Builder.swift
//  Flicker
//
//  Created by Илья Востров on 25.06.2024.
//

import UIKit

protocol BuilderProtocol{
    
    static func getPasscodeController(passcodeState: PasscodeState, sceneDelegate: SceneDelegateProtocol?, isSetting: Bool) -> UIViewController
    static func createTabBarController() -> UIViewController

    //vc

    static func createMainScreenController() -> UIViewController
    static func createCameraScreenController() -> UIViewController
    static func createFavoriteScreenController() -> UIViewController

}

class Builder: BuilderProtocol{

    static func getPasscodeController(passcodeState: PasscodeState, sceneDelegate: SceneDelegateProtocol?, isSetting: Bool) -> UIViewController{
        let passcodeView = PasscodeView()
        let keychainManager = KeychainManager()
        
        let presenter = PasscodePresenter(view: passcodeView, passcodeState: passcodeState, keychainManager: keychainManager, sceneDelagate: sceneDelegate, isSetting: isSetting)

        passcodeView.passcodePresenter = presenter
        return passcodeView
    }

    //Созднание TabBar для навигации
    static func createTabBarController() -> UIViewController {
        let tabBarView = TabBarView()
        let presenter = TabBarViewPresenter(view: tabBarView)
        tabBarView.presenter = presenter

        return tabBarView

    }
    
    // Создание главного экрана
    static func createMainScreenController() -> UIViewController {
        let mainView = MainScreenView()
        let presenter = MainScreenPresenter(view: mainView)
        
        mainView.presenter = presenter
        return mainView
    }

    // Созднание экрана для добавления фотографий
    static func createCameraScreenController() -> UIViewController {
        let cameraView = CameraView()
        let cameraService = CameraService()
        let presenter = CameraViewPresenter(view: cameraView, cameraService: cameraService)
        
        cameraView.presenter = presenter
        return UINavigationController(rootViewController: cameraView)
    }

    //Создание экрана избраных
    static func createFavoriteScreenController() -> UIViewController {
        let favoriteView = FavotiteView()
        let presenter = FavoriteViewPresenter(view: favoriteView)
        
        favoriteView.presenter = presenter
        return UINavigationController(rootViewController: favoriteView) //Назначение контроллера навигации
    }
    
    //Создание экрана подробностей о посте
    static func createDetailsController(item: PostItem) -> UIViewController {
        let detailsView = DetailsView()
        let presenter = DetailsViewPresenter(view: detailsView, item: item)
        
        detailsView.presenter = presenter
        return detailsView
    }
    
    // Создание экрана зума фотографии
    static func createPhotoViewController(image: UIImage?) -> UIViewController {
        let photoView = PhotoView()
        let presenter = PhotoViewPresenter(view: photoView, image: image)
        
        photoView.presenter = presenter
        return photoView
    }
    
    // Создание экрана создания поста
    static func createAddPostViewController(photos: [UIImage]) -> UIViewController {
        let addPostView = AddPostView()
        let presenter = AddPostPresenter(view: addPostView, photos: photos)
        
        addPostView.presenter = presenter
        return addPostView
    }
    
    // Создание экрана настроек приложения
    static func createSettingsViewController() -> UIViewController {
        let settingsView = SettingsView()
        let presenter = SettingsViewPresenter(view: settingsView)
        
        settingsView.presenter = presenter
        return UINavigationController(rootViewController: settingsView)
    }
}
