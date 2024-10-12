//
//  Builder.swift
//  Flicker
//
//  Created by Илья Востров on 25.06.2024.
//

import UIKit

protocol BuilderProtocol{
    
    static func getPasscodeController(passcodeState: PasscodeState, sceneDelegate: SceneDelegateProtocol) -> UIViewController
    static func createTabBarController() -> UIViewController

    //vc

    static func createMainScreenController() -> UIViewController
    static func createCameraScreenController() -> UIViewController
    static func createFavoriteScreenController() -> UIViewController

}

class Builder: BuilderProtocol{

    static func getPasscodeController(passcodeState: PasscodeState, sceneDelegate: SceneDelegateProtocol) -> UIViewController{
        let passcodeView = PasscodeView()
        let keychainManager = KeychainManager()

        let presenter = PasscodePresenter(view: passcodeView, passcodeState: passcodeState, keychainManager: keychainManager, sceneDelagate: sceneDelegate)

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

        return cameraView
    }

    //Создание экрана избраных
    static func createFavoriteScreenController() -> UIViewController {
        let favoriteView = FavotiteView()
        let presenter = FavoriteViewPresenter(view: favoriteView)
        favoriteView.presenter = presenter
        return UINavigationController(rootViewController: favoriteView) //favoriteView
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
}
