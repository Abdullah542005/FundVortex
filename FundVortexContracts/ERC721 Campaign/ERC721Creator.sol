// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;
import "FundVortex/ERC721.sol";
contract CreateNFT{ 
    function createNFT(
        string memory _name,
        string memory _symbol,
        uint _totalSupply
    ) external returns(address){
         NFT nft = new NFT(
            msg.sender,
            _name,
            _symbol,
            _totalSupply
         );
         return  address(nft);
    } 
}