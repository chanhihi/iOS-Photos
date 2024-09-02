//
//  ForYouViewController.swift
//  iOSPhotos
//
//  Created by Chan on 8/27/24.
//

import UIKit
import Photos
import PhotosUI
import Combine

class ForYouViewController: UIViewController {
    var viewModel: ForYouViewModel!
    private var importLibraryTableView: ForYouTableView!
    private var libraryButton: UIButton!
    private var cancellables: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLayout()
        setupBindings()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground

        importLibraryTableView = ForYouTableView(viewModel: viewModel)
        
        libraryButton = UIButton(type: .system)
        libraryButton.setTitle("라이브러리 관리", for: .normal)
        libraryButton.addTarget(self, action: #selector(libraryButtonTapped), for: .touchUpInside)
    }
    
    private func setupLayout() {
        view.addSubview(libraryButton)
        view.addSubview(importLibraryTableView)
        
        libraryButton.translatesAutoresizingMaskIntoConstraints = false
        importLibraryTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            libraryButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            libraryButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            importLibraryTableView.topAnchor.constraint(equalTo: libraryButton.bottomAnchor, constant: 16),
            importLibraryTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            importLibraryTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            importLibraryTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func updateLibraryButton() {
        libraryButton.setTitle("모든 사진을 볼 수 있게 되어있어요.", for: .normal)
    }
    
    private func setupBindings() {
        viewModel.$photos
            .combineLatest(viewModel.$videos)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _, _ in
                self?.importLibraryTableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    @objc private func libraryButtonTapped() {
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        switch status {
        case .authorized:
            updateLibraryButton()
        case .limited:
            PHPhotoLibrary.shared().presentLimitedLibraryPicker(from: self)
        case .denied, .restricted:
            showPermissionDeniedAlert()
        case .notDetermined:
            requestPhotoLibraryPermission()
        default:
            break
        }
    }
    
    private func requestPhotoLibraryPermission() {
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
            DispatchQueue.main.async {
                switch status {
                case .authorized:
                    self.updateLibraryButton()
                case .limited:
                    PHPhotoLibrary.shared().presentLimitedLibraryPicker(from: self)
                case .denied, .restricted:
                    self.showPermissionDeniedAlert()
                case .notDetermined:
                    break
                default:
                    break
                }
            }
        }
    }
    
    private func showPermissionDeniedAlert() {
        let alert = UIAlertController(title: "권한 필요", message: "사진 라이브러리에 접근하기 위해 권한이 필요합니다.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "설정으로 이동", style: .default, handler: { _ in
            if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSettings)
            }
        }))
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
