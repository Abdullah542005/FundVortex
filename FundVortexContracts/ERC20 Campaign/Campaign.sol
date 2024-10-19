// SPDX-License-Identifier: MIT
pragma solidity  0.8.26;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import {PublicTokenSale} from "PublicSale.sol";
import {WhiteListTokenSale} from "WhiteListSale.sol";
import {TokenMiscDetails} from "TokenMiscDetails.sol";
import {SBT} from "FundVortex/SBTs.sol";

contract TokenCampaignCreator is Ownable{

    SBT sbtAddress;
    address[] public Token;
    mapping(address=>uint) ProjectCreated;
    struct CampaignTargets{
        address CampaignCreator;
        bool Listed; 
        address TokenMiscDetails;
        address PublicTokenSale;
        address WhiteListTokenSale;
    }
   mapping(address=>CampaignTargets) public TokenCampaign;
   event TokenListed(address,address);
   event CampaignCreated(address,address);

    modifier  SBTRequired{
      require(sbtAddress.balanceOf(msg.sender)>0,"SBT Required");
      _;
    }

    modifier  OnlyCampaignCreator(address _token){
      require(TokenCampaign[_token].CampaignCreator == msg.sender);
      _;
    }
    
    constructor(
      address  _sbtAddress
    ) Ownable(msg.sender){
      sbtAddress = SBT(_sbtAddress);
    }


   function listToken(
        address _token
    ) external SBTRequired{
        ERC20 token  = ERC20(_token);
        require(token.balanceOf(msg.sender)>(token.totalSupply()/2),"Must Be Owner OF 50% Supply");
        Token.push(_token);
        TokenCampaign[_token].CampaignCreator = msg.sender;
        TokenCampaign[_token].Listed = true;
        ProjectCreated[msg.sender]++;
        emit  TokenListed(_token,msg.sender);
    }

   function createPublicCampaign(
       address _tokenContract,
       uint[] memory _launchInfo,
       bool _claim,
       uint _claimDate
    ) external SBTRequired OnlyCampaignCreator(_tokenContract) {
       require(TokenCampaign[_tokenContract].Listed);
       PublicTokenSale publicTokenSale = new PublicTokenSale(
          msg.sender,_tokenContract,_launchInfo,_claim,_claimDate
       );
       TokenCampaign[_tokenContract].PublicTokenSale = address(publicTokenSale);
       emit CampaignCreated(_tokenContract,msg.sender);
    }

   function createWhiteListCampaign(
       address _tokenContract,
       uint[] memory _launchInfo,
       address[]  memory _allowedAddresses,
       bool _claim,
       uint _claimDate
    ) external SBTRequired OnlyCampaignCreator(_tokenContract) {
       require(TokenCampaign[_tokenContract].Listed);
       WhiteListTokenSale whiteListTokenSale = new WhiteListTokenSale(
        msg.sender,_tokenContract,_launchInfo,_allowedAddresses,_claim,_claimDate
       );
       TokenCampaign[_tokenContract].WhiteListTokenSale = address(whiteListTokenSale);
    }

   function setMiscDetails(
       address _tokenContract,
       string memory _description,
       string memory  _webpage,
       string memory _tokenImageUrl,
       string memory _bannerImageUrl,
       string memory _tokenomicsImageUrl
    ) external SBTRequired  OnlyCampaignCreator(_tokenContract){
       require(TokenCampaign[_tokenContract].Listed);
       TokenMiscDetails  miscDetails = new TokenMiscDetails(_description,_webpage,_tokenImageUrl,
       _tokenomicsImageUrl,_bannerImageUrl);
       TokenCampaign[_tokenContract].TokenMiscDetails = address(miscDetails);
    }

    function deListCampaign(address _tokenContract) external  onlyOwner {
       delete  TokenCampaign[_tokenContract];
    }


    function getListedTokens() public view returns(address[] memory){
       return Token;
    }

} 

