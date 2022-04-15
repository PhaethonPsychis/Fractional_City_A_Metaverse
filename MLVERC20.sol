//SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";


contract MLVERC20 is ERC20, Ownable {

    uint256 public constant minimumMintInterval = 60 seconds;
    uint256 public constant mintCap = 200; // 2%

    uint256 public nextMint; // Timestamp


    constructor()

        ERC20("Metaverse Lands Vision", "MLV") {
        _mint(msg.sender, 500000);
        _mint(address(this), 2000000);
        nextMint = block.timestamp + minimumMintInterval;
    }

    function decimals() public pure override returns (uint8) {
		    return 0;        
    }

    //Owner transfer tickets from this contract to fill up the vending machine
    function transferFromContract(address dest, uint256 amount) external onlyOwner {
        _transfer(address(this), dest, amount);
    }
        
    /**
     * @dev Mints new tokens. Can only be executed every `minimumMintInterval`, by the owner, and cannot
     *      exceed `mintCap / 10000` fraction of the current total supply.
     * @param dest The address to mint the new tokens to.
     * @param amount The quantity of tokens to mint.
     */
    function mint(address dest, uint256 amount) external onlyOwner {
        require(amount <= (totalSupply() * mintCap) / 10000, "MLV: Mint exceeds maximum amount");
        require(block.timestamp >= nextMint, "MLV: Cannot mint yet");

        nextMint = block.timestamp + minimumMintInterval;
        _mint(dest, amount);
    }
      
}
