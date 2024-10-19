// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract WhiteListTokenSale is Ownable {
  uint public TotalTokensSubscribed;
    mapping(address=>uint) public userSubscription;
    mapping(address=>bool) public tokenClaimed;
    mapping(address=>bool) public allowedAddresses;

    struct CampaignDetails{
      address tokenContract;
       uint  supply;
       uint startDate;
       uint endDate;
       uint minBuy;
       uint maxBuy;
       uint  price; 
       bool claim;
       uint claimDate;
    }

    CampaignDetails public campaignDetails;

    constructor(
       address _owner,
       address _tokenContract,
       uint[] memory _launchInfo,
       address[]  memory _allowedAddresses,
       bool _claim,
       uint _claimDate
    ) Ownable(_owner){
      campaignDetails = CampaignDetails(
             _tokenContract,
            _launchInfo[0], _launchInfo[1],_launchInfo[2],_launchInfo[3],_launchInfo[4],
            _launchInfo[5],_claim,_claimDate
      );
      _setWhiteListSpots(_allowedAddresses);  
    }

    function _setWhiteListSpots(
        address[] memory addresses
    ) internal {
        for(uint i = 0; i< addresses.length; i++){
            allowedAddresses[addresses[i]] = true;
        }
    }


    function subscribe() payable  external  {
       require((campaignDetails.startDate<=block.timestamp)&&
       (campaignDetails.endDate>=block.timestamp) ,"Campaign Not Live");
       require(allowedAddresses[msg.sender],"Not A Whitelisted Address");
       uint tokenAmount  = ((msg.value/campaignDetails.price)*10**18);
       uint TotalAmount  = tokenAmount+userSubscription[msg.sender];
       require(TotalAmount>=campaignDetails.minBuy,"Less than the Min Buy");
       require(TotalAmount<=campaignDetails.maxBuy,"Greater than Max Buy");
       require((TotalTokensSubscribed+tokenAmount)<=campaignDetails.supply,"No Tokens Left To  Subscribe");
       userSubscription[msg.sender] += tokenAmount;
       TotalTokensSubscribed +=tokenAmount;
    }


    function collect() payable external onlyOwner{
      require((campaignDetails.endDate<=block.timestamp ||
       TotalTokensSubscribed==campaignDetails.supply
       ) ,"Campaign Not Ended");
       payable(msg.sender).transfer(address(this).balance);
    }


    function claim() external {
         require(userSubscription[msg.sender]>0);
         require(campaignDetails.claimDate<=block.timestamp,"Please Wait For The Claim Date");
         ERC20 token = ERC20(campaignDetails.tokenContract);
         require(!tokenClaimed[msg.sender],"Tokens Already Claimed");
         tokenClaimed[msg.sender] = true;
         token.transfer(msg.sender, userSubscription[msg.sender]);
    }

}