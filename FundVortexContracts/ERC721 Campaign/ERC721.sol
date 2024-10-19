// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract NFT is Ownable, ERC721{
    uint256 private _nextTokenId;
    string private _baseTokenURI;
    uint public totalSupply;
    constructor(
        address _owner,
        string memory _name,
        string memory _symbol,
        uint _totalSupply
    ) Ownable(_owner) ERC721(_name,_symbol){
         totalSupply = _totalSupply;
    }

    function safeMint(address _target) public onlyOwner{
         require(_nextTokenId<=totalSupply,"Total Supply Reached");
         uint tokenId  = _nextTokenId++;
        _safeMint(_target, tokenId);
    }
    function setBaseUri(string memory _URI) public onlyOwner{
       _baseTokenURI = _URI;
    }
    function tokenURI(uint tokenId) view public  override  returns(string memory){
        return  _baseTokenURI;
    }

}