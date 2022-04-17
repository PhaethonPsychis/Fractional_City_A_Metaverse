//SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;


import "@openzeppelin/contracts/access/Ownable.sol";
//import "@openzeppelin/contracts/utils/Context.sol";
import "https://github.com/PhaethonPsychis/playmaker/blob/main/MLVERC20.sol";

// a vending mchine for selling votes at a fixed price
// $DDRL is an Ethereum token that gives holders governance rights in the Decentralised Research and Design Lab. 
// The DDRL Token governs the development of the "Autonomous Cities in the Metaverse" project, giving holders the right to vote on the direction 
// and implementation of the project. The more DDRL tokens a user has locked in their voting contract, 
// the greater the decision-making power 

contract vendingMachineDDRL is Ownable{

    //initiate token
    DDRLToken public _DDRLToken;


    //contract state variables
    uint internal internal_number;
    uint256 public price;
    //uint public amountTickets;

  
    // Event that log buy operation
    event BuyTickets(address buyer, uint256 amountOfETH, uint256 amountOfTokens);
    event SellTokens(address seller, uint256 amountOfTokens, uint256 amountOfETH);

    constructor (address tokenAddress) {
        _DDRLToken = DDRL(tokenAddress);
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
