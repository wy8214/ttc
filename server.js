const express = require('express')
const app = express();
const port = 3000 || process.env.PORT;
const Web3 = require('web3');

const bodyParser = require('body-parser');
const url = require('url');
const HDWalletProvider = require('truffle-hdwallet-provider')
const truffle_connect = require('./api/ttc.js');

const config = require('./config/app_config.js');

const terms = config.terms;
const netIp = config.netIp;
const interface = config.interface;
const contract_address = config.contract_address;

const web3 = new Web3()
const provider = new HDWalletProvider(terms, netIp)
web3.setProvider(provider)
truffle_connect.web3 = web3
truffle_connect.contract_instance = new web3.eth.Contract(JSON.parse(interface),contract_address)
truffle_connect.contract_address = contract_address
truffle_connect.contract_creator = ""


// parse application/x-www-form-urlencoded
app.use(bodyParser.urlencoded({ extended: false }));

// parse application/json
app.use(bodyParser.json());

app.use(express.static('public_static'));

app.use((req, res,next) => {
  console.log("**** init ****");

  next()
});




app.get('/getAccounts', (req, res) => {
  console.log("**** GET /getAccounts ****");

  truffle_connect.getAccounts(function (answer) {
    res.send(answer);
  })
});

app.get('/postOrder', (req, res) => {
  console.log("**** GET /postOrder ****");
  let params = url.parse(req.url, true).query;
  let amount = params.amount;
  let order_sn = params.order_sn;
  let account = params.account;

  truffle_connect.postOrder(amount,order_sn, account,(answer) => {
      res.send(answer);
  });
});


app.get('/getOrder', (req, res) => {
  console.log("**** GET /getOrder ****");

  let params = url.parse(req.url, true).query;
  let index = params.index;

  truffle_connect.getOrder(index, (answer) => {
      res.send(answer);
  });
});

app.get('/getOrderCount', (req, res) => {
  console.log("**** GET /getOrderCount ****");
  let params = url.parse(req.url, true).query;

  truffle_connect.getOrderCount((answer) => {
    
      res.send(answer);
    
  });
});


app.get('/postTrade', (req, res) => {
  console.log("**** GET /postTrade ****");
  let params = url.parse(req.url, true).query;
  let amount = params.amount;
  let trade_no = params.trade_no;
  let account = params.account;

  truffle_connect.postOrder(amount,order_sn, account,(answer) => {
      res.send(answer);
  });
});


app.get('/getTrade', (req, res) => {
  console.log("**** GET /getTrade ****");

  let params = url.parse(req.url, true).query;
  let trade_no = params.trade_no;

  truffle_connect.getTrade(trade_no, (answer) => {
      res.send(answer);
  });
});

app.get('/getTradeCount', (req, res) => {
  console.log("**** GET /getTradeCount ****");
  let params = url.parse(req.url, true).query;

  truffle_connect.getTradeCount((answer) => {
    
      res.send(answer);
    
  });
});



app.get('/getBalance', (req, res) => {
  console.log("**** GET /getBalance ****");
  let params = url.parse(req.url, true).query;
  let account = params.account;

  truffle_connect.getBalance(account, (answer) => {
    
      res.send(answer);
    
  });
});




app.listen(port, () => {

  
  let fun = async () => {
  try {

          let accounts = await web3.eth.getAccounts()

          truffle_connect.contract_creator = accounts[0]
          console.log("+++++contract_creator++++",truffle_connect.contract_creator)
      } catch (e) {
          console.log(e)
      }
  }

  fun()
  console.log("Express Listening at http://localhost:" + port);

});
