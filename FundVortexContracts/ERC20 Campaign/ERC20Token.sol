// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";


contract ERC20Token is ERC20{
    constructor(
        string memory _name,
        string memory _symbol,
        address _creator,
        uint _totalSupply
        ) ERC20(_name,_symbol){
          _mint(_creator, _totalSupply);  
    }
}
