//
//  USEImportWalletVC.swift
//  USEChainWallet
//
//  Created by Jacob on 2019/3/14.
//  Copyright © 2019 Jacob. All rights reserved.
//

import UIKit
import SwipeMenuViewController
import QRCodeReader
import AVFoundation

open class USEImportWalletVC: UIViewController, SwipeMenuViewDelegate, SwipeMenuViewDataSource, QRCodeReaderViewControllerDelegate {
    
    @objc func clickBtn() {
        _ = self.navigationController?.popViewController(animated: true)
    }

    @objc fileprivate func clickRightBtn() {
        if !USEAVCaptureTools.hasAVCaptureAuthorization() {
            USEAVCaptureTools.requestForAVCaptureAuthorization { (result) in
            }
        }
        let alert = UIAlertController(
            title: "选择图片源",
            message: "",
            preferredStyle: UIAlertController.Style.actionSheet
        )
        alert.addAction(
            UIAlertAction(
                title: "拍照",
                style: .default,
                handler: { (_) in
                        DispatchQueue.main.async {
                            guard USEAVCaptureTools.checkScanPermissions(mySelf: self) else {return}
                                self.readerVC.modalPresentationStyle = .formSheet
                                self.readerVC.delegate = self
                                self.readerVC.completionBlock = { (result: QRCodeReaderResult?) in
                                if let result = result {
                                     UserDefaults.standard.setValue(result.value, forKey: "scanPrivateKeyStr")
                                }
                            }
                        self.present(self.readerVC, animated: true, completion: nil)
            }
        }))
        alert.addAction(UIAlertAction(
            title: "相册",
            style: .default,
            handler: { (_) in
                    DispatchQueue.main.async {
                            guard USEAVCaptureTools.checkScanPermissions(mySelf: self) else {return}
                        self.navigationController?.pushViewController(USEImportPhotoLibraryVC(), animated: false)
            }
        }))
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.navigationItem.title = "导入助记词"
        self.addChild(USEMenmonicImportVC())
        self.addChild(USEPrivateKeyImportVC())
        self.addChild(USEKeystoreImportVC())
        cusSwipeMenuView()
        cusBackBtn()
    }
    
    open var swipeMenuView: SwipeMenuView!
    lazy var reader: QRCodeReader = QRCodeReader()
    lazy var readerVC: QRCodeReaderViewController = {
        let builder = QRCodeReaderViewControllerBuilder {
            $0.reader                  = QRCodeReader(metadataObjectTypes: [.qr], captureDevicePosition: .back)
            $0.showTorchButton         = true
            $0.preferredStatusBarStyle = .lightContent
            $0.showOverlayView        = true
            $0.rectOfInterest          = CGRect(x: 0.2, y: 0.2, width: 0.6, height: 0.6)
            $0.reader.stopScanningWhenCodeIsFound = false
        }
        return QRCodeReaderViewController(builder: builder)
    }()
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
    }
    
    open override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        swipeMenuView.willChangeOrientation()
    }
    
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addSwipeMenuViewConstraints()
    }
    
    private func addSwipeMenuViewConstraints() {
        swipeMenuView.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 11.0, *), view.hasSafeAreaInsets, swipeMenuView.options.tabView.isSafeAreaEnabled {
            NSLayoutConstraint.activate([
                swipeMenuView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                swipeMenuView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                swipeMenuView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                swipeMenuView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
                ])
        } else {
            NSLayoutConstraint.activate([
                swipeMenuView.topAnchor.constraint(equalTo: topLayoutGuide.topAnchor),
                swipeMenuView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                swipeMenuView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                swipeMenuView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
                ])
        }
    }
    
    // MARK: - SwipeMenuViewDataSource
    open func numberOfPages(in swipeMenuView: SwipeMenuView) -> Int {
        return children.count
    }
    
    open func swipeMenuView(_ swipeMenuView: SwipeMenuView, titleForPageAt index: Int) -> String {
        let titleArray = ["助记词", "私钥", "keyStore"]
        return titleArray[index]
    }
    
    open func swipeMenuView(_ swipeMenuView: SwipeMenuView, viewControllerForPageAt index: Int) -> UIViewController {
        let vc = children[index]
        vc.didMove(toParent: self)
        return vc
    }
}

extension USEImportWalletVC {
    
    fileprivate func cusSwipeMenuView() {
        swipeMenuView = SwipeMenuView(frame: view.frame)
        swipeMenuView.delegate = self
        swipeMenuView.dataSource = self
        var options: SwipeMenuViewOptions = SwipeMenuViewOptions()
        options.tabView.addition = .none
        options.tabView.needsAdjustItemViewWidth = false
        options.tabView.style = .segmented
        options.tabView.height = 60
        options.tabView.itemView.selectedTextColor = UIColor(hexString: "3289fc")!
        options.tabView.additionView.backgroundColor = UIColor(hexString: "3289fc")!
        options.tabView.additionView.padding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        swipeMenuView.reloadData(options: options)
        view.addSubview(swipeMenuView)
    }
    
    //自定义左侧返回按钮
    fileprivate func cusBackBtn() {
        let backBtn = UIButton()
        backBtn.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        backBtn.setImage(UIImage.init(named: "Left"), for: UIControl.State.normal)
        backBtn.setImage(UIImage.init(named: "Left"), for: UIControl.State.highlighted)
        backBtn.sizeToFit()
        let backItem = UIBarButtonItem.init(customView: backBtn)
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 11/255, green: 43/255, blue: 97/255, alpha: 1.0)
        let dict:NSDictionary = [NSAttributedString.Key.foregroundColor: UIColor.white,NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18)]
        self.navigationController?.navigationBar.titleTextAttributes = dict as? [NSAttributedString.Key : AnyObject]
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self as UIGestureRecognizerDelegate
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        backBtn.addTarget(self, action: #selector(USEWalletBaseVC.clickBtn), for: UIControl.Event.touchUpInside)
        self.navigationItem.leftBarButtonItem = backItem
    }
    
    public func swipeMenuView(_ swipeMenuView: SwipeMenuView, didChangeIndexFrom fromIndex: Int, to toIndex: Int) {
        print(toIndex)
        switch toIndex {
        case 0:
            self.navigationItem.title = "导入助记词"
            self.navigationItem.rightBarButtonItem = nil
        case 1:
            self.navigationItem.title = "导入私钥"
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage.init(named: "saoyisao"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(USEImportWalletVC.clickRightBtn))
        case 2:
            self.navigationItem.title = "导入keystore"
             self.navigationItem.rightBarButtonItem = nil
        default:
            self.navigationItem.title = "导入助记词"
        }
    }
}
extension USEImportWalletVC {
    // MARK: - QRCodeReader Delegate Methods
    public  func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        reader.stopScanning()
        dismiss(animated: true) { [weak self] in
        }
    }
    
    public func reader(_ reader: QRCodeReaderViewController, didSwitchCamera newCaptureDevice: AVCaptureDeviceInput) {
        print("Switching capture to: \(newCaptureDevice.device.localizedName)")
    }
    
    public func readerDidCancel(_ reader: QRCodeReaderViewController) {
        reader.stopScanning()
        dismiss(animated: true, completion: nil)
    }
}

extension USEImportWalletVC: UIGestureRecognizerDelegate {

}
