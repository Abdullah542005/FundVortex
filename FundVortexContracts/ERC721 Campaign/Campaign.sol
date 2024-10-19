// SPDX-License-Identifier: MIT
pragma solidity  0.8.26;
import {SBT} from "FundVortex/SBTs.sol";
import {PublicMint} from "FundVortex/NFTPublicMint.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "FundVortex/NFTMiscDetails.sol";
contract NFTCampaignCreator is Ownable{
    
    address[] public NFTs;
    SBT public sbtAddress;
    struct CampaignTargets{
        address CampaignCreator;
        bool Listed; 
        address NFTDetails;
        address PublicNFTSale;
        address WhiteListNFTSale;
    }
    mapping(address=>CampaignTargets) public NFTCampaign;
     event CampaignCreated(address,address);
    mapping (address=>uint) public CampaignsCreated;
    constructor(address _sbt) Ownable(msg.sender){
          sbtAddress =  SBT(_sbt);
    } 
    modifier  sbtRequired{
         require(sbtAddress.balanceOf(msg.sender)!=0,"Not A Verfied Entity");
        _;
    }
    modifier  onlyCampaignCreator(address _NFT){
        require(NFTCampaign[_NFT].CampaignCreator == msg.sender,"User is not the campaign creator");
        _;
    }

    function listNFT(address _NFT) external  sbtRequired {
        require(!NFTCampaign[_NFT].Listed,"Campaign Already Listed");
        NFTCampaign[_NFT].CampaignCreator = msg.sender;
        NFTCampaign[_NFT].Listed  = true;
        NFTs.push(_NFT);
        CampaignsCreated[msg.sender]++;
    }
    
    function deList(address _NFT) external  onlyOwner{
       delete NFTCampaign[_NFT].Listed; 
    }

    function createPublicCampaign(
       address _NFTContract,
       uint[] memory _launchInfo
    ) external sbtRequired onlyCampaignCreator(_NFTContract){
        require(NFTCampaign[_NFTContract].Listed,"NFT Not Listed");
        PublicMint pMint = new PublicMint(
         msg.sender,
         _NFTContract,
        _launchInfo
        );
        NFTCampaign[_NFTContract].PublicNFTSale = address(pMint);    
         emit CampaignCreated(_NFTContract,msg.sender);
    }



    function setMiscDetails(
       address _NFTContract,
       string memory _description,
       string memory  _webpage,
       string memory _NFTImageUrl,
       string memory _bannerImageUrl
    ) external sbtRequired  onlyCampaignCreator(_NFTContract){
       require(NFTCampaign[_NFTContract].Listed);
       NFTMiscDetails  miscDetails = new NFTMiscDetails(_description,_webpage,_NFTImageUrl,
       _bannerImageUrl);
       NFTCampaign[_NFTContract].NFTDetails = address(miscDetails);
    }



    function getListedNFTs() public view returns(address[] memory){
       return NFTs;
    }

}