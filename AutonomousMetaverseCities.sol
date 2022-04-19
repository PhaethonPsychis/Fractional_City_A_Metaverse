//SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;


import "@openzeppelin/contracts/access/Ownable.sol";
//import "@openzeppelin/contracts/utils/Context.sol";
import "https://github.com/PhaethonPsychis/Fractional_City_A_Metaverse/blob/main/DDRLToken.sol";

// a vending machine for selling votes at a fixed price
// $DDRL is an Ethereum token that gives holders governance rights in Decentralised Design and Research Lab. 
// The DDRL Token governs the development of the "Autonomous Cities in the Metaverse" project, giving holders the right to vote 
// on the direction and implementation of the project. The more DDRL tokens a user has locked in their voting contract, 
// the greater the decision-making power 
//
//  ***** Decentralized Design Research Lab DDRL **********
// Autonomous Metaverse Cities is a solution and a model for the development of Private Cities backed by 
//  fractional ownership in the city's revenue streams

contract vendingMachineDDRL is Ownable{

    //our token contract 
    DDRLToken public _DDRLToken;


    //contract state variables
    //the price for the vote token that this vending machine sell
    uint256 public _rate;
    

  
    // Event that log buy operation
    event BuyVotes(address buyer, uint256 amountOfETH, uint256 amountOfTokens);
   

    constructor () {
        _DDRLToken = DDRLToken(0xFa3f054416336D2a5648a1dc3f44829d35D20E8B);
    }
    //owner sets a price for the vote token as a rate votes per eth
    function setVotePrice(uint rate) public onlyOwner {
        _rate = rate ;
    }
    


function buyTokens() public payable returns (uint256 tokenAmount) {
    require(msg.value > 0, "Send ETH to buy some tokens");

    uint256 amountToBuy = (msg.value * _rate) / 1e18;

    // check if the Vendor Contract has enough amount of tokens for the transaction
    uint256 vendorBalance = _DDRLToken.balanceOf(address(this));
    require(vendorBalance >= amountToBuy, "Vendor contract has not enough tokens in its balance");

    // Transfer token to the msg.sender
    (bool sent) = _DDRLToken.transfer(msg.sender, amountToBuy);
    require(sent, "Failed to transfer token to user");

    // emit the event
    emit BuyVotes(msg.sender, msg.value, amountToBuy);

    return amountToBuy;
  }

    //Allow owner to withdraw ETH from contract
    function withdraw() public {
        payable(owner()).transfer(address(this).balance);
    }
}
