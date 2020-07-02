pragma solidity ^0.4.23;

contract Bank {
    
    address private owner;

    
    mapping (address => uint256) private balance;
    mapping (address => uint256) private coinBalance; 
    
    
    
    event DepositEvent(address indexed from, uint256 value, uint256 timestamp);
    event WithdrawEvent(address indexed from, uint256 value, uint256 timestamp);
    event TransferEvent(address indexed from, address indexed to, uint256 value, uint256 timestamp);
    event MintEvent(address indexed from, uint256 value, uint256 timestamp);
    
    event BuyCoinEvent(address indexed from, uint256 value, uint256 timestamp);
    event TransferOwnerEvent(address indexed oldOwner, address indexed newOwner, uint256 timestamp);
     event TransferCoinEvent(address indexed from, address indexed to, uint256 value, uint256 timestamp);
    
    
    modifier isOwner() {
        require(owner == msg.sender, "you are not owner");
        _;
    }
    
    
    constructor() public payable {
        owner = msg.sender;
    }
    
    
    function deposit(uint256 amt) public payable {
        uint256 weiamt = amt;
       
        
        balance[msg.sender] += weiamt;

        // emit DepositEvent
        emit DepositEvent(msg.sender, msg.value, now); 
    }
    
    
    function withdraw(uint256 etherValue) public {
        uint256 weiValue = etherValue ; 

        require(balance[msg.sender] >= weiValue, "your balances are not enough"); 

       // msg.sender.transfer(weiValue);

        balance[msg.sender] -= weiValue;

        // emit WithdrawEvent
        emit WithdrawEvent(msg.sender, etherValue, now);
    }
    
    
    function transfer(address to, uint256 etherValue) public {
        uint256 weiValue = etherValue;

        require(balance[msg.sender] >= weiValue, "your balances are not enough");

        balance[msg.sender] -= weiValue;
        balance[to] += weiValue;

        // emit TransferEvent
        emit TransferEvent(msg.sender, to, etherValue, now);
    }
    
    
    // mint coin       
    function mint(uint256 coinValue) public isOwner {
        
        uint256 value = coinValue;
        
        coinBalance[msg.sender] += value;


        // emit MintEvent
        emit MintEvent(msg.sender,value,now);

    }
    
    function buy(uint256 coinValue) public {
        uint256 value = coinValue ;

       
        require(coinBalance[msg.sender] >= value );

        
        require(balance[msg.sender] >= value );
        

        
        balance[msg.sender] -= value;
        
       
        balance[msg.sender] += value;
        

       
        coinBalance[msg.sender] += value;

        
      
        coinBalance[msg.sender] -= value;

        

        // emit BuyCoinEvent
        emit BuyCoinEvent(msg.sender , value, now );

    }
    
    
  
    function transferCoin(address to, uint256 coinValue) public {
        uint256 value = coinValue;

        
        require(coinBalance[msg.sender] >= value);
        
        
        coinBalance[msg.sender] -= value;
        
       
        coinBalance[to] += value;

       
        emit TransferCoinEvent(msg.sender, to , value ,now);
    }
    
    
     function getBankBalance() public view returns (uint256) {
        return balance[msg.sender];
    }
    
    function getCoinBalance() public view returns (uint256) {
        return coinBalance[msg.sender];
    }
    
    // get owner
    function getOwner() public view returns (address)  {
        return owner;
    }
    

function transferOwner(address newOwner) public isOwner {

        // transfer ownership
        owner = newOwner;
        
        // emit TransferOwnerEvent
        emit TransferOwnerEvent(owner, newOwner, now);
        
    }

  

    function kill() public isOwner {
        selfdestruct(owner);
    }

}