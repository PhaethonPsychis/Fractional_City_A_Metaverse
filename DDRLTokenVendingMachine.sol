//SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;


import "@openzeppelin/contracts/access/Ownable.sol";
//import "@openzeppelin/contracts/utils/Context.sol";
import "https://github.com/PhaethonPsychis/Fractional_City_A_Metaverse/blob/main/DDRLToken.sol";


// ***** A Metaverse for collective ownership of cities *****
// Everyone can own a fraction of the city, and help shape its future.
// Fractional ownership unlocks the potential of the world’s most sought after assets: Cities!
// 
// ***** Decentralized Design Research Lab DDRL **********
// DDRL is a crypto-cooperative, a self-organised ecosystem of communities and teams that 
// are focused on building a cyber-urban metaverse 
//
// ***** $DDRL Decentralized Community Governance Token *****
// $DDRL is an Ethereum token that gives holders governance rights over the development, direction and implementation of the "Autonomous Metaverse Cities" project. 
// The more DDRL tokens a user has locked in their voting contract, the greater the decision-making power
//
// ***** Smart Contract Vending Machine Selling Votes *****
// This is a vending machine that runs on blockchain selling votes at a fixed price
//  
  


contract DDRLTokenVendingMachine is Ownable{

    //our token contract 
    DDRLToken public DDRLtoken;


    //contract state variables
    //the price for the vote token that this vending machine sell
    uint256 public TokensPerEthRate;
    

  
    // Event that log buy operation
    event BuyDDRLtoken(address buyer, uint256 amountOfETH, uint256 amountOfTokens);
   

    constructor () {
        DDRLtoken = DDRLToken(0x604183b3CE47FF4cc627cEd93fa75Acb42A3a5A4);
    }
    //owner sets a price for the vote token as a rate votes per eth
    function ExchangeRate(uint rate) public onlyOwner {
        TokensPerEthRate = rate ;
    }
    


function SellMeDDRLtoken() public payable returns (uint256 tokenAmount) {
    require(msg.value > 0, "Send ETH to buy some tokens");

    uint256 amountToBuy = (msg.value * TokensPerEthRate) / 1e18;

    // check if the Vendor Contract has enough amount of tokens for the transaction
    uint256 vendorBalance = DDRLtoken.balanceOf(address(this));
    require(vendorBalance >= amountToBuy, "Vendor contract has not enough tokens in its balance");

    // Transfer token to the msg.sender
    (bool sent) = DDRLtoken.transfer(msg.sender, amountToBuy);
    require(sent, "Failed to transfer token to user");

    // emit the event
    emit BuyDDRLtoken(msg.sender, msg.value, amountToBuy);

    return amountToBuy;
  }

    //Allow owner to withdraw ETH from contract
    function withdraw() public {
        payable(owner()).transfer(address(this).balance);
    }
}
