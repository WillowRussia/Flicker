//
//  DetailsView.swift
//  Flicker
//
//  Created by Илья Востров on 02.08.2024.
//

import UIKit
protocol DetailsViewProtocol: AnyObject {
    
}
class DetailsView: UIViewController {
    
    var presenter: DetailsViewPresenterProtocol!
    var photoView: PhotoView!
    
    private var menuViewHeight = UIApplication.topSafeArea + 50// Высота включающая безопасную зону
    
    lazy var topMenuView: UIView = { // Верхнее меню
        $0.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: menuViewHeight)
        $0.backgroundColor = .appMain
        return $0
    }(UIView())
    
    lazy var backAction = UIAction { [weak self] _ in //Чтобы избежать утечки памяти
        self?.navigationController?.popViewController(animated: true)
    }
    
    lazy var menuAction = UIAction { [weak self] _ in //Чтобы избежать утечки памяти
    }
    //AppBAr с навигацией
    lazy var navigationHeader: NavigationHeader = {
        NavigationHeader(backAction: backAction,menuAction: menuAction, date: presenter.item.date)
    }()
    
    lazy var collectionView: UICollectionView = { // Коллекция, где содержатся все компоненты окна
        $0.backgroundColor = .none
        $0.contentInset = UIEdgeInsets(top: 80, left: 0, bottom: 100, right: 0) // Определяет отступы вокруг содержимого UIScrollView
        $0.dataSource = self
        $0.delegate = self
        $0.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        $0.register(TagCollectionCell.self, forCellWithReuseIdentifier: TagCollectionCell.reuseId)
        $0.register(DetailsPhotoCell.self, forCellWithReuseIdentifier: DetailsPhotoCell.reuseId)
        $0.register(DetailsDescriptionCell.self, forCellWithReuseIdentifier: DetailsDescriptionCell.reuseId)
        $0.register(DetailsAddCommentCell.self, forCellWithReuseIdentifier: DetailsAddCommentCell.reuseId)
        $0.register(DetailsMapCell.self, forCellWithReuseIdentifier: DetailsMapCell.reuseId)
        return $0
    }(UICollectionView(frame: view.bounds, collectionViewLayout: getCompositionLayout()))
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = false // Уменшили заголовок
        navigationItem.setHidesBackButton(true, animated: true) //Скрываем кнопку навигации
        navigationController?.navigationBar.isHidden  = true //Убераем навигацию(что-то типо пленки это)
        
        NotificationCenter.default.post(name: .hideTabBar, object: nil, userInfo: ["isHide" : true]) // Делаем модификацию для скрытия tabBar
    }
    private func setupPageHeader() {
        let headerView = navigationHeader.getNavigationHeader(type: .back)
        headerView.frame.origin.y = UIApplication.topSafeArea + 5
        view.addSubview(headerView)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .appMain
        view.addSubview(collectionView)
        view.addSubview(topMenuView)
        setupPageHeader()

        
    }

}

extension DetailsView {
    /*
     https://habr.com/ru/articles/495076/
     NSCollectionLayoutSize — определяет размер элемента;
     NSCollectionLayoutItem — определяет элемент лайаута;
     NSCollectionLayoutGroup — определяет группу элементов лайаута, сам по себе тоже является элементом лайута;
     NSCollectionLayoutSection — определяет секцию для конкретной группы элементов;
     UICollectionViewCompositionalLayout — определяет сам лайаут.
     */
    private func getCompositionLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout{ [weak self] section, _ in
            switch section {
            case 0:
                return self?.createPhotoSection()
            case 1:
                return self?.createTagSection()
            case 2,3:
                return self?.createDescriptionSection()
            case 4:
                return self?.createCommentFieldSection()
            case 5:
                return self?.createMapSection()
            default:
                return self?.createPhotoSection()
            }
        }
    }
    // Функция для карусели фотографий
    private func createPhotoSection() ->  NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))// Задаем соотношение высоты и ширины
        /*
         .absolute - абсолютная величина, указывает точный размер
         .estimated - приблизительная величина, точный размер будет известен на этапе рендеринга.
         .fractionalHeight и .fractionalWidth - относительная величина, принимает значения от 0 до 1 включительно, определят ширину относительно ширины контейнера, 0.5 — ширина равна половине ширины группы (контейнера) элемента;
         */
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 30)// Определяет отступы между элементами
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.8), heightDimension: .fractionalHeight(0.7))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging // .continuous - туда-сюда листаются, .groupPaging - постранично, .groupPagingCentered - по центру
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 30, bottom: 30, trailing: 30) // Определяет отступы между секциями(Количество пространства, добавленное вокруг содержимого элемента для корректировки его окончательного размера после вычисления его положения.)
        
        return section
        
    }
    private func createTagSection() ->  NSCollectionLayoutSection {
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(110), heightDimension: .estimated(10))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [.init(layoutSize: groupSize)])// В качестве размера элемента добавляем размер группы
        group.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: nil, top: nil, trailing: .fixed(10), bottom: nil)// Добавляем отступ
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 30, bottom: 20, trailing: 30)
        section.orthogonalScrollingBehavior = .continuous // Вид скрола
        
        return section
    }
    private func createDescriptionSection() -> NSCollectionLayoutSection {
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(10))
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [.init(layoutSize: groupSize)])// В качестве размера элемента добавляем размер группы
        group.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: nil, top: nil, trailing: nil, bottom: .fixed(10))// Добавляем отступ
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 30, bottom: 0, trailing: 30)
        
        return section
    }
    private func createCommentFieldSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 30, leading: 30, bottom: 60, trailing: 30)
        return section
    }
    private func createMapSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(160))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 30, bottom: 0, trailing: 30)
        return section
    }
}

extension DetailsView: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        6
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return presenter.item.photos.count
        case 1:
            return presenter.item.tags?.count ?? 0
        case 2,4,5:
            return 1
        case 3:
            return presenter.item.comments?.count ?? 0
        default:
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = presenter.item
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailsPhotoCell.reuseId, for: indexPath) as! DetailsPhotoCell
            cell.configureCell(image: presenter.item.photos[indexPath.item])
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagCollectionCell.reuseId, for: indexPath) as! TagCollectionCell
            cell.configureCell(tagText: item.tags?[indexPath.item] ?? "")
            return cell
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailsDescriptionCell.reuseId, for: indexPath) as! DetailsDescriptionCell
            cell.configureCell(date: nil, text: item.description ?? "")
            return cell
        case 3:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailsDescriptionCell.reuseId, for: indexPath) as! DetailsDescriptionCell
            let comment = item.comments?[indexPath.row]
            cell.configureCell(date: comment?.date, text: comment?.comment ?? "")
            return cell
        case 4:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailsAddCommentCell.reuseId, for: indexPath) as! DetailsAddCommentCell
            cell.completion = { /*[weak self]*/ comment in
//                guard let self = self else { return }
                print (comment)
            }
            return cell
        case 5:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailsMapCell.reuseId, for: indexPath) as! DetailsMapCell
            cell.configureCell(coordinate: item.location)
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
            cell.backgroundColor = .red
            return cell
        }
        
    }
    
    
}

extension DetailsView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) { // Сообщает делегату, что выбран элемент
        if indexPath.section == 0{
            let itemPhoto = presenter.item.photos[indexPath.item]
            photoView = Builder.createPhotoViewController(image: UIImage (named: itemPhoto)) as? PhotoView
            
            addChild(photoView) //Добавляет указанный контроллер в качестве дочернего элемента текущего контроллера
            photoView.view.frame = view.bounds
            view.addSubview(photoView.view) // Добавляет представление в иерархию
            photoView.didMove(toParent: self)// Уведомляет конторлер о его добавлении
            
            photoView.comletion = { [weak self] in
                self?.photoView.willMove(toParent: nil) // Уведомляет конторлер о его удалении
                self?.photoView.view.removeFromSuperview() // Убирает представление из иерархию
                self?.photoView.removeFromParent() // Удаляет контроллер  из родительского
                self?.photoView = nil
            }
            
        }
    }
}

extension DetailsView: DetailsViewProtocol {
    
}
