// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;
import {ERC20Token} from "FundVortex/ERC20Token.sol";

contract ERC20TokenCreator{   
   function createToken(
    string memory _name,
    string memory _symbol,
    uint _totalSupply
    ) external {
      ERC20Token token  = new ERC20Token(_name,_symbol,msg.sender,_totalSupply);   
   }
}