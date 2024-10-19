// SPDX-License-Identifier: MIT
pragma solidity  0.8.26;

import "@openzeppelin/contracts/access/Ownable.sol";
import  "FundVortex/ERC721.sol";
contract PublicMint is Ownable{
    mapping(address=>uint) public NFTMint;
    uint public totalNFTMinted;
    struct CampaignDetails{
       address NFTContract;
       uint  supply;
       uint startDate;
       uint endDate;
       uint maxBuy;
       uint price;
    }
    CampaignDetails public campaignDetails;
    constructor(
       address _owner,
       address _NFTContract,
       uint[] memory _launchInfo
    ) Ownable(_owner){
      campaignDetails = CampaignDetails(
             _NFTContract,
            _launchInfo[0], _launchInfo[1],_launchInfo[2],_launchInfo[3],_launchInfo[4]
      );
    }

    event NFTMinted(address, address);

    function revokeMintAuthority() public  onlyOwner{
         require(campaignDetails.endDate<block.timestamp,"Wait For The Campaign To End");
         NFT nft  = NFT(campaignDetails.NFTContract);
         nft.transferOwnership(msg.sender);
    }
   
   function  mint() payable  external {
        require(msg.value>=campaignDetails.price,"Not Enough Amount");
        require(campaignDetails.endDate>block.timestamp &&
        campaignDetails.startDate<block.timestamp
        ,"Wait For The Campaign To Start");
        require(totalNFTMinted<(campaignDetails.supply/1e18),"ALL NFT Minted");
        require(NFTMint[msg.sender]<campaignDetails.maxBuy/1e18,"Maximum Mint Limit Reach");
        totalNFTMinted++;
        NFTMint[msg.sender]++;
        NFT nft = NFT(campaignDetails.NFTContract);
        nft.safeMint(msg.sender);
        emit NFTMinted(msg.sender,campaignDetails.NFTContract);
   }

   function collect() payable external onlyOwner{
       require((campaignDetails.endDate<=block.timestamp ||
       totalNFTMinted==(campaignDetails.supply/1e18)
       ) ,"Campaign Not Ended / Supply not reached");
       payable(msg.sender).transfer(address(this).balance);
    }






}