// const contract = require('truffle-contract');

// const contract_artifact = require('../build/contracts/EthPay.json');
// var contract_instance = contract(contract_artifact);


module.exports = {

    getAccounts: function(callback) {

    var self = this;
    // Bootstrap the contract_instance abstraction for Use.
    // contract_instance.setProvider(self.web3.currentProvider);

    let fun = async () => {
        try {
            let accounts = await self.web3.eth.getAccounts()
            data = {
              'acounts' : accounts,
              // 'account_len' : self.accounts.length,
            }
            callback(data);
            
        } catch (e) {
            callback(e);
            console.log(e)
        }
    }
    fun();

  
  },

  //获取订单数量
  getOrderCount:function(callback) {
        var self = this;
        

        let fun = async () => {
        try {

                let res = await  self.contract_instance.methods.getOrderCount().call({
                    from: self.contract_creator,
                })
             
                console.log('v1:', res)
                
                callback(res);
            } catch (e) {
                console.log(e)
            }
        }

        fun()
    },


    //提交订单
    postOrder:function (amount , order_sn , account, callback) {

        var self = this;
        let from = account
        let address = self.contract_address


        console.log('amount:', amount)
        console.log('order_sn:', order_sn)
        console.log('account:', account)
        console.log('address:', address)
        // amount = self.web3.utils.toWei(amount, 'ether')
        let fun = async () => {
        try {
            let res = await self.contract_instance.methods.pay(order_sn,amount).send({
                from: from, //如果不指定from，那么会使⽤默认账户defaultAccount的值
                to: address,
                gas: '6000000',
                value: amount,
            })

            } catch (e) {
                console.log(e)
            }
        }

        fun()

    },  


    //获取订单信息
    getOrder:function (order_sn ,callback) {

        var self = this;

        let fun = async () => {
        try {

                let accounts = await self.web3.eth.getAccounts()
                console.log('accounts :', accounts)
                let from = accounts[0]
                let res = await self.contract_instance.methods.getOrder(order_sn).call({
                    from: from,
                })
                console.log('v1:', res)

                callback(res);
            } catch (e) {
                console.log(e)
            }
        }

        fun()
    },  

    //获取转账数量
    getTradeCount:function(callback) {
        var self = this;
        

        let fun = async () => {
        try {

                let res = await  self.contract_instance.methods.getTradeCount().call({
                    from: self.contract_creator,
                })
             
                console.log('v1:', res)
                
                callback(res);
            } catch (e) {
                console.log(e)
            }
        }

        fun()
    },


    //提交转账
    postTrade:function (amount , trade_no , account, callback) {

        var self = this;
        let from = account
        let address = self.contract_address


        console.log('amount:', amount)
        console.log('order_sn:', order_sn)
        console.log('account:', account)
        console.log('address:', address)
        // amount = self.web3.utils.toWei(amount, 'ether')
        let fun = async () => {
        try {
            let res = await self.contract_instance.methods.pay(trade_no,amount).send({
                from: from, //如果不指定from，那么会使⽤默认账户defaultAccount的值
                to: address,
                gas: '6000000',
                value: amount,
            })

            } catch (e) {
                console.log(e)
            }
        }

        fun()

    }, 

    //获取转账信息
    getTrade:function (trade_no ,callback) {

        var self = this;

        let fun = async () => {
        try {

                let accounts = await self.web3.eth.getAccounts()
                console.log('accounts :', accounts)
                let from = accounts[0]
                let res = await self.contract_instance.methods.getTrade(trade_no).call({
                    from: from,
                })
                console.log('v1:', res)

                callback(res);
            } catch (e) {
                console.log(e)
            }
        }

        fun()
    },
    




    //获取区块金额
    getBalance:function(account,callback) {
        var self = this;
        

        let fun = async () => {
        try {

                let accounts = await self.web3.eth.getAccounts()
                console.log('accounts :', accounts)
                let account = accounts[0]
                let res = await  self.web3.eth.getBalance(self.contract_creator,6135079)
                console.log('v1:', res)
                
                callback(res);
            } catch (e) {
                console.log(e)
            }
        }

        fun()
    },


    


    //获取合约余额
    getContractBalance:function(callback) {
        var self = this;
       

        let fun = async () => {
        try {
              
                let res = await self.contract_instance.methods.getBalance().call({
                    from: self.contract_creator,
                })
                console.log('v1:', res)
                
                callback(res);
            } catch (e) {
                console.log(e)
            }
        }

        fun()
    },


    

    //获取区块信息
    getBlockInfo:function (block_num,callback) {

        var self = this;
        self.web3.eth.getBlock(block_num, function(error, result){
            if(!error)
                console.log(JSON.stringify("no error", result));
            else
                console.error("error", error);
        })

    },

    

    //账号间转账
    sendTransaction:function (from , to , amount , callback) {

        var self = this;
        
        amount = self.web3.utils.toWei(amount, 'ether')
        var meta;
        contract_instance.deployed().then(function(value) {
            return self.web3.eth.sendTransaction({
                from: from, //如果不指定from，那么会使⽤默认账户defaultAccount的值
                to: to,
                gas: '6000000',
                value: amount,
            });
        }).then(function(value) {
            callback(value.valueOf());
        }).catch(function(e) {
            console.log(e);
            callback("Error 404");
        });

    },  

  

  
}
