/**
 *Submitted for verification at Etherscan.io on 2019-08-06
*/

pragma solidity ^0.4.24;


contract SafeMath {
     //internal > private 
    //internal < public
  
    function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a * b;
        assert(a == 0 || c / a == b);
        return c;
    }
    
    function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
        assert(b > 0);
        uint256 c = a / b;
        assert(a == b * c + a % b);
        return c;
    }
    
    
    function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
        assert(b <= a);
        assert(b >=0);
        return a - b;
    }
    
    function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        assert(c>=a && c>=b);
        return c;
    }
}

contract  EthPay is SafeMath {
    
    
    string public name; 
    string public symbol; 
    uint8 public decimals; 
    uint256 public totalSupply; 
     
    /* This creates an array with all balances */
    mapping (address => uint256) public balanceOf;
    mapping (address => uint256) public freezeOf;
    
    mapping (address => mapping (address => uint256)) public allowance; 
    /* This generates a public event on the blockchain that will notify clients */ 
    event Transfer(address indexed from, address indexed to, uint256 value); 
    /* This notifies clients about the amount burnt */ 
    event Burn(address indexed from, uint256 value); 
    /* This notifies clients about the amount frozen */ 
    event Freeze(address indexed from, uint256 value);
    /* This notifies clients about the amount unfrozen */
    event Unfreeze(address indexed from, uint256 value);
    

    address public owner;
    
    struct Order {
        string      order_sn;
        uint256     amount;
        address     addr;
    }
    mapping (string => Order)  order_list;
    // Order[] public order_list;
    
    struct Trade {
        string      trade_no;
        uint256     amount;
        address     addr;
    }
    mapping (string => Trade)  trade_list;
    // Trade[] public trade_list;

    
    
    constructor(
        uint256 _initialSupply, //发行数量 
        string _tokenName, //token的名字 TTCoin
        string _tokenSymbol //HTC
        ) public {
            
        decimals = 1;//_decimalUnits;                           // Amount of decimals for display purposes
        balanceOf[msg.sender] = _initialSupply * 1;              // Give the creator all initial tokens
        totalSupply = _initialSupply * 1;                        // Update total supply
        name = _tokenName;                                   // Set the name for display purposes
        symbol = _tokenSymbol;                               // Set the symbol for display purposes
     
        owner = msg.sender;
    }

    /* Send coins */
    function transfer(address _to, uint256 _value,string trade_no) public {
        
        if (_to == 0x0) throw;                               // Prevent transfer to 0x0 address. Use burn() instead
        if (_value <= 0) throw; 
        if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
        if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
       
        balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                     // Subtract from the sender
        balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);   
        
        Trade memory  _trade = Trade(trade_no,_value,msg.sender);
        
        trade_list[trade_no] = _trade;
        
        emit Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
    }

    /* Allow another contract to spend some tokens in your behalf */
    function approve(address _spender, uint256 _value) public returns (bool success) {
        assert (_value <= 0) ; 
        allowance[msg.sender][_spender] = _value;
        return true;
    }
       

    /* A contract attempts to get the coins */
    function transferFrom(address _from , address _to, uint256 _value) public returns (bool success) {
        if (_to == 0x0) throw;                                // Prevent transfer to 0x0 address. Use burn() instead
        if (_value <= 0) throw; 
        if (balanceOf[_from] < _value) throw;                 // Check if the sender has enough
        
        if (balanceOf[_to] + _value < balanceOf[_to]) throw;  // Check for overflows
        
        if (_value > allowance[_from][msg.sender]) throw;     // Check allowance
           
        balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);                           // Subtract from the sender
        
        balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                             // Add the same to the recipient
       
       
        allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);
        emit Transfer(_from, _to, _value);
        
       
        return true;
    }

    function burn(uint256 _value) public returns (bool success) {
        if (balanceOf[msg.sender] < _value) throw;            // Check if the sender has enough
        if (_value <= 0) throw; 
        balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender
        totalSupply = SafeMath.safeSub(totalSupply,_value);                                // Updates totalSupply
        emit Burn(msg.sender, _value);
        return true;
    }
    
    function freeze(uint256 _value) public returns (bool success) {
        if (balanceOf[msg.sender] < _value) throw;            // Check if the sender has enough
        if (_value <= 0) throw; 
        balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender
        freezeOf[msg.sender] = SafeMath.safeAdd(freezeOf[msg.sender], _value);                                // Updates totalSupply
        emit Freeze(msg.sender, _value);
        return true;
    }
    
    function unfreeze(uint256 _value) public returns (bool success) {
        if (freezeOf[msg.sender] < _value) throw;            // Check if the sender has enough
        if (_value <= 0) throw; 
        freezeOf[msg.sender] = SafeMath.safeSub(freezeOf[msg.sender], _value);                      // Subtract from the sender
        balanceOf[msg.sender] = SafeMath.safeAdd(balanceOf[msg.sender], _value);
        emit Unfreeze(msg.sender, _value);
        return true;
    }
    
    // transfer balance to owner
    function withdrawEther(uint256 amount) public {
        if(msg.sender != owner)throw;
        owner.transfer(amount);
    }

    function pay(string order_sn, uint256 _value) payable public returns (bool success) {
        
        if (_value <= 0) throw; 
        if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
        if (balanceOf[owner] + _value < balanceOf[owner]) throw; // Check for overflows
        
        balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                     // Subtract from the sender
        balanceOf[owner] = SafeMath.safeAdd(balanceOf[owner], _value);     
       
        Order memory  _order = Order(order_sn,_value,msg.sender);
        order_list[order_sn] = _order;
       
        emit Transfer(msg.sender, owner, _value); 

        return true;
        
    }
    
    function getOrder(string _order_sn) public view returns(string , uint256 , address)
    {
        Order memory order = order_list[_order_sn];
        return (order.order_sn, order.amount, order.addr);
    }
    
    function getTrade(string _trade_no) public view returns(string , uint256 , address)
    {
        Trade memory trade = trade_list[_trade_no];
        return (trade.trade_no, trade.amount, trade.addr);
    }

    
    modifier onlyManager {
        require(msg.sender == owner);
        _;
    }

    function getBalance() public view returns(uint){
      return address(this).balance;
    }

    

    
}