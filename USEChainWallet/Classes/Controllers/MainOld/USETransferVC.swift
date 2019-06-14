//
//  USETransferVC.swift
//  USEChainWallet
//
//  Created by Jacob on 2019/3/24.
//  Copyright © 2019 Jacob. All rights reserved.
//

import UIKit
import LLKit
import QRCodeReader
import AVFoundation

private let USETransferFirstCellID = "USETransferFirstCellID"
private let USETransferSecondCellID = "USETransferSecondCellID"
private let USETransferThirdCellID = "USETransferThirdCellID"
private let USETransferFourthCellID = "USETransferFourthCellID"

class USETransferVC: USEWalletBaseVC, QRCodeReaderViewControllerDelegate {
    
    @objc fileprivate func clickRightBtn() {
        guard checkScanPermissions() else { return }
        readerVC.delegate               = self
        readerVC.completionBlock = { (result: QRCodeReaderResult?) in
            if let result = result {
                print("Completion with result: \(result.value) of type \(result.metadataType)")
                print(result.value)
                if !result.value.hasPrefix("iban") {
                    if result.value.hasPrefix("0x") {
                        self.scanAddress = result.value
                        self.tabView.reloadData()
                    }
                    showAlterView("请扫描地址二维码", mySelf: self)
                    return
                }
                let tempArray = result.value.components(separatedBy: ":")
                let addressString = tempArray.last
                self.scanAddress = UseEthersManager.address(fromIbanAddress: addressString)
                self.tabView.reloadData()
            }
        }
        present(readerVC, animated: true, completion: nil)
    }


    @objc func clickBtn(btn: UIButton) {
        let transferAmountIP = NSIndexPath(row: 1, section: 0)
        let transferAmountCell = tabView.cellForRow(at: transferAmountIP as IndexPath) as! USETransferSecondCell
        let transValue = transferAmountCell.moneyTextFiled.text
        let toAddressIndexpath = NSIndexPath(row: 2, section: 0)
        let toAddressInputCell = tabView.cellForRow(at: toAddressIndexpath as IndexPath) as! USETransferThirdCell
        let toAddress = toAddressInputCell.moneyTextFiled.text
        if !USEAddressTools.isValidUSEAddress(address: toAddress ?? "") {
            showAlterView("不是合法的USE地址", mySelf: self)
            return
        }

        let transferGasIP = NSIndexPath(row: 3, section: 0)
        let transferGasCell = tabView.cellForRow(at: transferGasIP as IndexPath) as! USETransferFourthCell
        var sliderPercent = transferGasCell.minerFeeSlider.value
        if sliderPercent <= 0.02 {
            sliderPercent = 0.02
        }
        let gasPrice = sliderPercent * 100000000000
        if transValue == "" {
            showAlterView("转账金额不能为空", mySelf: self)
            return
        }
        if !isPurnDouble(string: transValue!) {
            showAlterView("请输入正确转账金额", mySelf: self)
            return
        }
        let transDoubleValue = (transValue! as NSString).doubleValue
        if transDoubleValue == 0 {
            showAlterView("转账金额不能为0", mySelf: self)
            return
        }
        let walletStore = walletInfo[1]
        let correctPasscode = (UserDefaults.standard.value(forKey: walletStore) as! Array<String>).last
        let alertVC = UIAlertController(title: "请输入密码", message: "", preferredStyle: .alert)
        let cancelBtn = UIAlertAction(title: "取消", style: .cancel) { (action) in
        }
        let confirmBtn = UIAlertAction(title: "确认", style: .destructive) { (action) in
            let textField = alertVC.textFields?.first
            if textField?.text == correctPasscode {
                self.view.showHUD(withText: "正在发送交易")
                let account = kGetCurrentAccount()
                UseChainNetTools.sendUSETransactionWith(account: account, gasLimite: "22000", gasPrice: BigNumber(number: NSNumber(floatLiteral: Double(gasPrice)))!.decimalString, value: transferAmountCell.moneyTextFiled.text!, toAddress: toAddress!, data: nil, flag: 0, resource: { (result, error) in
                    self.hideHUD()
                    if result != nil {
                        if (result as! [String: Any])["error"] != nil {
                            showAlterView("交易发送失败", mySelf: self)
                            return
                        }
                        UserDefaults.standard.setValue((result as! [String: Any])["result"], forKey: "currentTXHash")
                    } else {
                        showAlterView("转账失败", mySelf: self)
                        return
                    }
                    self.navigationController?.pushViewController(USETransferCompletedVC(), animated: true)
                })
            } else {
                showAlterView("密码错误", mySelf: self)
                return
            }
        }
        confirmBtn.setValue(UIColor.red, forKey: "titleTextColor")
        alertVC.addAction(cancelBtn)
        alertVC.addAction(confirmBtn)
        alertVC.addTextField { (textfiled) in
            textfiled.placeholder = "请输入密码"
        }
        self.present(alertVC, animated: true) {
        }
    }
    override func loadView() {
        super.loadView()
        setupUI()
        prepareTabView()
        UseChainNetTools.getTokenInfo(address: "0xd9485499499d66b175cf5ed54c0a19f1a6bcb61a") { (result, error) in
            if result != nil {
                if (result as! [String: Any])["price"] != nil {
                    let rate = ((result as! [String: Any])["price"] as! [String: Any])["rate"] as! Double
                    let price = rate * 6.9027
                    let FourthIP = NSIndexPath(row: 3, section: 0)
                    let FourthCell = self.tabView.cellForRow(at: FourthIP as IndexPath) as! USETransferFourthCell
                    FourthCell.minerFee.text = "1USE ≈ ¥" + String(format: "%.3f", price)
                }
            }
            self.tabView.reloadData()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.navigationItem.title = "转账"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage.init(named: "saoyisao"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(USETransferVC.clickRightBtn))
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let umAddress = kGetCurrentAccountUMAdderss()
        UseChainNetTools.getUSEBalance(address: umAddress) { (result, error) in
            if result != nil {
                let resultBalance = (result as! [String: Any])["result"] as! String
                let bigNumResultBalance = BigNumber(hexString: resultBalance)
                let tempStr = Payment.formatEther(bigNumResultBalance, options: (EtherFormatOption.commify.rawValue | EtherFormatOption.approximate.rawValue))
                self.tempBalance = tempStr ?? "0"
                self.tabView.reloadData()
            }
        }
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if let toAddressFromAddressBook = UserDefaults.standard.value(forKey: "toAddressFromAddressBook") as? String {
            if toAddressFromAddressBook != "" {
                addressFromAddressBook = toAddressFromAddressBook
                UserDefaults.standard.setValue("", forKey: "toAddressFromAddressBook")
                tabView.reloadData()
            }
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
    }
    fileprivate var addressFromAddressBook: String?
    fileprivate var scanAddress: String?
    fileprivate lazy var walletInfo: Array = { () -> [String] in
        let useCurrentAccountArray = UserDefaults.standard.value(forKey: kUSECurrentAccountInfo) as? Array<String>
        return useCurrentAccountArray ?? []
    }()

    fileprivate var toAddress: String?
    fileprivate var tempBalance: String?
    fileprivate lazy var tabView: UITableView = {
        let temp = UITableView()
        temp.tableFooterView = UIView()
        return temp
    }()
    fileprivate lazy var confimBtn: UIButton = {
        let temp = UIButton(title: "开始转账", fontSize: 18, color: UIColor.white, imageName: nil, backColor: UIColor(red: 41/255, green: 126/255, blue: 251/255, alpha: 1.0))
        temp.addTarget(self, action: #selector(USETransferVC.clickBtn(btn:)), for: UIControl.Event.touchUpInside)
        return temp
    }()
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
}

extension USETransferVC {
    fileprivate func setupUI() {
        self.view.addSubview(tabView)
        self.view.addSubview(confimBtn)
        for v in self.view.subviews {
            v.translatesAutoresizingMaskIntoConstraints = false
        }
        tabView.snp.makeConstraints { (make) in
            make.top.equalTo(self.topLayoutGuide.snp.bottom)
            make.left.right.equalTo(self.view)
            make.bottom.equalTo(self.view).offset(-60)
        }
        confimBtn.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.view)
            make.bottom.equalTo(self.view)
            make.height.equalTo(60)
        }
    }
    
    fileprivate func prepareTabView() {
        tabView.delegate = self
        tabView.dataSource = self
        tabView.separatorStyle = .none
        tabView.register(USETransferFirstCell.self, forCellReuseIdentifier: USETransferFirstCellID)
        tabView.register(USETransferSecondCell.self, forCellReuseIdentifier: USETransferSecondCellID)
        tabView.register(USETransferThirdCell.self, forCellReuseIdentifier: USETransferThirdCellID)
        tabView.register(USETransferFourthCell.self, forCellReuseIdentifier: USETransferFourthCellID)
        tabView.keyboardDismissMode = .onDrag
    }
}

extension USETransferVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: USETransferFirstCellID) as! USETransferFirstCell
            cell.coinLabel.text = tempBalance
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: USETransferSecondCellID) as! USETransferSecondCell
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: USETransferThirdCellID) as! USETransferThirdCell
            if self.scanAddress != "" && self.scanAddress != nil {
                    cell.moneyTextFiled.text = self.scanAddress
            }
            if self.addressFromAddressBook != "" && self.addressFromAddressBook != nil {
                cell.moneyTextFiled.text = self.addressFromAddressBook
            }
            cell.delegate = self
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: USETransferFourthCellID) as! USETransferFourthCell
            return cell
        default:
            let cell = UITableViewCell()
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 150
        case 1:
            return 80
        case 2:
            return 100
        case 3:
            return 180
        default:
            return 44
        }
    }
    

}
extension USETransferVC {
    private func checkScanPermissions() -> Bool {
        do {
            return try QRCodeReader.supportsMetadataObjectTypes()
        } catch let error as NSError {
            let alert: UIAlertController
            
            switch error.code {
            case -11852:
                alert = UIAlertController(title: "啊哦!", message: "请开通访问相机的权限", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "设置", style: .default, handler: { (_) in
                    DispatchQueue.main.async {
                        if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.openURL(settingsURL)
                        }
                    }
                }))
                alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
            default:
                alert = UIAlertController(title: "啊哦！", message: "当前设备不支持", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "好的", style: .cancel, handler: nil))
            }
            present(alert, animated: true, completion: nil)
            return false
        }
    }
    // MARK: - QRCodeReader Delegate Methods
    public  func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        reader.stopScanning()
        dismiss(animated: true) { [weak self] in
            let alert = UIAlertController(
                title: "QRCodeReader",
                message: String (format:"%@ (of type %@)", result.value, result.metadataType),
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self?.present(alert, animated: true, completion: nil)
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
extension USETransferVC: USETransferThirdCellBtnClicked {
    
    func isPurnDouble(string: String) -> Bool {
        let scan: Scanner = Scanner(string: string)
        var val:Double = 0.0
        return scan.scanDouble(&val) && scan.isAtEnd
    }
    
    func clickedAddressBook(btn: UIButton) {
        self.navigationController?.pushViewController(USETransferToAddressListVC(), animated: true)
    }
    
}
