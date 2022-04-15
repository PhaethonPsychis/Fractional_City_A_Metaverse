//SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;


import "@openzeppelin/contracts/access/Ownable.sol";
//import "@openzeppelin/contracts/utils/Context.sol";
import "https://github.com/PhaethonPsychis/playmaker/blob/main/MLVERC20.sol";

// a vending mchine for selling tickets 

contract vendor is Ownable{

    //initiate token
    MLVERC20 public _MLVERC20;


    //contract state variables
   uint internal internal_number;
   uint256 public price;
   //uint public amountTickets;

  
    // Event that log buy operation
    event BuyTickets(address buyer, uint256 amountOfETH, uint256 amountOfTokens);
    event SellTokens(address seller, uint256 amountOfTokens, uint256 amountOfETH);

    constructor (address tokenAddress) {
        _MLVERC20 = MLVERC20(tokenAddress);
    }
    //owner sets a price for the ticket
    function setTicketPrice(uint _price) public onlyOwner {
        price = _price ;
    }
    
    function set_internal_number(uint _value) public {
        internal_number = _value;
    }


    function buyTickets(uint amountOfTickets) public payable returns (uint256){
        //amountTickets = _amountTickets;
        require(msg.value >= amountOfTickets * price * 1 wei, "Not enough Eth to buy the tickets");
        
        // check if the Vendor Contract has enough amount of tokens for the transaction
        uint256 vendorBalance = _MLVERC20.balanceOf(address(this));
        require(vendorBalance >= amountOfTickets, "Vendor contract has not enough tokens in its balance");
        
        // Transfer token to the msg.sender
        (bool sent) = _MLVERC20.transfer(msg.sender, amountOfTickets);
        require(sent, "Failed to transfer token to user");

        // emit the event
        emit BuyTickets(msg.sender, msg.value, amountOfTickets);

        return amountOfTickets;
    }

    //Allow owner to withdraw ETH from contract
    function withdraw() public {
        payable(owner()).transfer(address(this).balance);
    }
}
