/**
 *Submitted for verification at Etherscan.io on 2019-08-06
*/

pragma solidity ^0.4.24;


library SafeMath {
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }
        uint256 c = a * b;
        assert(c / a == b);
        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        // assert(b > 0); // Solidity automatically throws when dividing by 0
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold
        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        assert(b <= a);
        return a - b;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        assert(c >= a);
        return c;
    }
}

contract EthPay {

  address public owner;
    uint public order_amount;
    struct Order {
        string order_sn;
        uint256   amount;
        address addr;
    }
    
    Order[] public order_list;
    
    constructor()  public {
      owner = msg.sender;
    }


    event EventPay(string _event_name,address _addr, uint amount,string order_sn); 

    event EventCashOut(string _event_name,address _addr, address _to_addr,uint amount);
   

    function pay(string order_sn) payable public {
        
        order_amount = msg.value;
        
        Order memory  _order = Order(order_sn,order_amount,msg.sender);
        
        order_list.push(_order);

        emit EventPay("EventPay",msg.sender, msg.value,order_sn); 
        
    }
    
    function getOrder(uint _index) public view returns(string , uint256 , address)
    {
        Order memory order = order_list[_index];
        return (order.order_sn, order.amount, order.addr);
    }

    function cashOut(address _addr,uint _money) onlyManager  public {
        
        _addr.transfer(_money);
        emit EventCashOut("EventCashOut",msg.sender, _addr, _money); 
    }
    
    modifier onlyManager {
        require(msg.sender == owner);
        _;
    }

    function getBalance() public view returns(uint){
      return address(this).balance;
    }

    

    
}