pragma solidity 0.8.20; //Do not change the solidity version as it negatively impacts submission grading
// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/access/Ownable.sol";
import "./YourToken.sol";

contract Vendor is Ownable {
    event BuyTokens(address buyer, uint256 amountOfETH, uint256 amountOfTokens);
    event SellTokens(address seller, uint256 amountOfTokens, uint256 amountOfETH);

    YourToken public yourToken;
    uint256 public tokensPerEth = 100;

    constructor(address tokenAddress) Ownable(msg.sender) {
        yourToken = YourToken(tokenAddress);
    }

    // ToDo: create a payable buyTokens() function:
    function buyTokens() external payable {
        require(msg.value > 0, "You need to send some ether");

        uint256 amountOfTokens = msg.value * tokensPerEth;
        require(yourToken.balanceOf(address(this)) >= amountOfTokens, "Not enough tokens in the reserve");

        yourToken.transfer(msg.sender, amountOfTokens);
        emit BuyTokens(msg.sender, msg.value, amountOfTokens);
    }

    // ToDo: create a withdraw() function that lets the owner withdraw ETH
    function withdraw() external onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "No ether to withdraw");

        (bool success, ) = msg.sender.call{ value: balance }("");
        require(success, "Transfer failed");
    }

    // ToDo: create a sellTokens(uint256 _amount) function:
    function sellTokens(uint256 _amount) external {
        require(_amount > 0, "You need to sell at least some tokens");
        require(yourToken.balanceOf(msg.sender) >= _amount, "You don't have enough tokens");

        uint256 amountOfETH = _amount / tokensPerEth;
        require(address(this).balance >= amountOfETH, "Not enough ether in the reserve");

        yourToken.transferFrom(msg.sender, address(this), _amount);
        payable(msg.sender).transfer(amountOfETH);
        emit SellTokens(msg.sender, _amount, amountOfETH);
    }
}
