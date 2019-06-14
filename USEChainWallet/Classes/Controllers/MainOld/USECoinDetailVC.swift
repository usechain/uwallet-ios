//
//  USECoinDetailVC.swift
//  USEChainWallet
//
//  Created by Jacob on 2019/3/1.
//  Copyright © 2019 Jacob. All rights reserved.
//

import UIKit

private let USECoinDetailCellID = "USECoinDetailCellID"

class USECoinDetailVC: USEWalletBaseVC {

    @objc func clickBtn(btn: UIButton) {
        if btn.tag == 1 {
            self.navigationController?.pushViewController(USEQRCodeRefundVC(), animated: true)
        } else {

            self.navigationController?.pushViewController(USETransferVC(), animated: true)
        }
    }
    
    override func loadView() {
        super.loadView()
        self.navigationItem.title = "USE"
        setupUI()
        prepareTableView()
        txRecordTableView.mj_header.beginRefreshing()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        let umAddress = kGetCurrentAccountUMAdderss()
        UseChainNetTools.getUSEBalance(address: umAddress) { (result, error) in
            if result != nil {
                let resultBalance = (result as! [String: Any])["result"] as! String
                let bigNumResultBalance = BigNumber(hexString: resultBalance)
                let tempStr = Payment.formatEther(bigNumResultBalance, options: (EtherFormatOption.commify.rawValue | EtherFormatOption.approximate.rawValue))
                self.coinCount.text = tempStr
                UseChainNetTools.getTokenInfo(address: "0xd9485499499d66b175cf5ed54c0a19f1a6bcb61a") { (result, error) in
                    if result != nil {
                        if (result as! [String: Any])["price"] != nil {
                            let rate = ((result as! [String: Any])["price"] as! [String: Any])["rate"] as! Double
                            let price = rate * 6.9027
                            self.estimateRMB.text = "≈ ¥ " + String(format: "%.3f", (tempStr! as NSString).doubleValue * price)
                        }
                    }
            }
            }
        }
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
    }
    
    fileprivate lazy var coinCount: UILabel = UILabel(title: "0.0", fontSize: 25, color: UIColor.black, redundance: 0)
    fileprivate lazy var estimateRMB: UILabel = UILabel(title: "≈ ￥ 0.000", fontSize: 15, color: UIColor.gray, redundance: 0)
    fileprivate lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black
        return view
    }()
    fileprivate lazy var txRecordLabel: UILabel = UILabel(title: "交易记录", fontSize: 12, color: UIColor.gray, redundance: 0)
    fileprivate lazy var txRecordTableView: UITableView = UITableView()
    
    fileprivate lazy var gatheringBtn: UIButton = {
        let temp = UIButton(title: "收款", fontSize: 15, color: UIColor.white, imageName: nil, backColor: UIColor(red: 40/255, green: 113/255, blue: 251/255, alpha: 1.0))
        temp.addTarget(self, action: #selector(USECoinDetailVC.clickBtn(btn:)), for: UIControl.Event.touchUpInside)
        temp.tag = 1
        return temp
    }()
    fileprivate lazy var translateBtn: UIButton =  {
        let temp = UIButton(title: "转账", fontSize: 15, color: UIColor.white, imageName: nil, backColor: UIColor(red: 11/255, green: 43/255, blue: 97/255, alpha: 1.0))
        temp.addTarget(self, action: #selector(USECoinDetailVC.clickBtn(btn:)), for: UIControl.Event.touchUpInside)
        temp.tag = 2
        return temp
    }()
    fileprivate lazy var viewModel: USETxRecordViewModel = USETxRecordViewModel()
    fileprivate lazy var dataArrayM = [USETxRecordSingleViewModel]()
}

extension USECoinDetailVC {
    
    fileprivate func setupUI() {
        // addSubviews
        self.view.addSubview(coinCount)
        self.view.addSubview(estimateRMB)
        self.view.addSubview(lineView)
        self.view.addSubview(txRecordLabel)
        self.view.addSubview(txRecordTableView)
        
        self.view.addSubview(gatheringBtn)
        self.view.addSubview(translateBtn)
        
        for v in self.view.subviews {
            v.translatesAutoresizingMaskIntoConstraints = false
        }
        // layout
        coinCount.snp.makeConstraints { (make) in
            make.top.equalTo(self.view).offset(110)
            make.centerX.equalTo(self.view)
        }
        estimateRMB.snp.makeConstraints { (make) in
            make.top.equalTo(coinCount.snp.bottom).offset(10)
            make.centerX.equalTo(self.view)
        }
        lineView.snp.makeConstraints { (make) in
            make.top.equalTo(estimateRMB.snp.bottom).offset(20)
            make.left.right.equalTo(self.view)
            make.height.equalTo(1)
        }
        txRecordLabel.snp.makeConstraints { (make) in
            make.top.equalTo(lineView.snp.bottom).offset(10)
            make.left.equalTo(self.view).offset(20)
        }
        txRecordTableView.snp.makeConstraints { (make) in
            make.top.equalTo(txRecordLabel.snp.bottom).offset(20)
            make.left.right.equalTo(self.view)
            make.bottom.equalTo(self.view).offset(-40)
        }
        gatheringBtn.snp.makeConstraints { (make) in
            make.left.equalTo(self.view)
            make.bottom.equalTo(self.view)
            make.height.equalTo(60)
            make.width.equalTo(UIScreen.main.bounds.size.width / 2)
        }
        translateBtn.snp.makeConstraints { (make) in
            make.right.bottom.equalTo(self.view)
            make.height.equalTo(60)
            make.width.equalTo(UIScreen.main.bounds.size.width / 2)
        }
    }
}

extension USECoinDetailVC: UITableViewDelegate, UITableViewDataSource {
    fileprivate func prepareTableView() {
        txRecordTableView.delegate = self
        txRecordTableView.dataSource = self
        txRecordTableView.register(USEWalletTxRecordCell.self, forCellReuseIdentifier: USECoinDetailCellID)
        txRecordTableView.tableFooterView = UIView()
        txRecordTableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {
            print("footer")
            self.viewModel.loadPreTurnInDatas(finished: { (result) in
                print(result)
                print(self.viewModel.useTxRecordPullRequestList)
                self.dataArrayM = NSMutableArray.init(array: self.viewModel.useTxRecordPullRequestList) as! [USETxRecordSingleViewModel]
                self.txRecordTableView.reloadData()
                self.txRecordTableView.mj_footer.endRefreshing()
            })
        })
        (txRecordTableView.mj_footer as! MJRefreshAutoStateFooter).setTitle("点击或上拉加载更多", for: MJRefreshState.idle)
        (txRecordTableView.mj_footer as! MJRefreshAutoStateFooter).setTitle("正在加载更多的数据...", for: MJRefreshState.refreshing)
        txRecordTableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            print("header")
            self.viewModel.loadTurnInDatas { (result) in
                print(result)
                print(self.viewModel.useTxRecordPullRequestList)
                self.dataArrayM = NSMutableArray.init(array: self.viewModel.useTxRecordPullRequestList) as! [USETxRecordSingleViewModel]
                self.txRecordTableView.reloadData()
                self.txRecordTableView.mj_header.endRefreshing()
            }
        })
        (txRecordTableView.mj_header as! MJRefreshStateHeader).setTitle("下拉刷新", for: .idle)
        (txRecordTableView.mj_header as! MJRefreshStateHeader).setTitle("释放立即刷新", for: .pulling)
        (txRecordTableView.mj_header as! MJRefreshStateHeader).setTitle("正在刷新…", for: .refreshing)
    }
    // 只是fakeData的
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArrayM.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: USECoinDetailCellID) as! USEWalletTxRecordCell
            cell.model = self.dataArrayM[indexPath.row].assetsRecodModel
            return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentCellTxHash = self.dataArrayM[indexPath.row].assetsRecodModel.txHash
        UserDefaults.standard.setValue(currentCellTxHash, forKey: "currentTXHash")
        self.navigationController?.pushViewController(USETransferCompletedVC(), animated: true)
    }
}

extension USECoinDetailVC {
    // 下拉刷新
    fileprivate func  loadPullRequest() {
        self.viewModel.loadTurnInDatas { (result) in
            print(result)
            print(self.viewModel.useTxRecordPullRequestList)
            self.dataArrayM = NSMutableArray.init(array: self.viewModel.useTxRecordPullRequestList) as! [USETxRecordSingleViewModel]
        }
    }
}
