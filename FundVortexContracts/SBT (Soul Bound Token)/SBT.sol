// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;
import {ERC721} from "contracts/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract SBT is ERC721,Ownable{

    string  public name ="LaunchPadVerify";
    string public symbol="LV";
    string  _baseUri = "https://white-hilarious-guanaco-83.mypinata.cloud/ipfs/QmWzc4czDBS4oKXCgsxk9YNYLURQnLSkFEdA5A9mg4tdCG";
    mapping(address=>bool) public verifiedAddresses;
    uint8 sbtID;

    event AddressVerified(address _verifiedAddress);
    event VerificationRevoke(address _verifiedAddress);

    constructor() Ownable(msg.sender){
         sbtID = 1;
    }

    function mint() external {
        require(_balanceOf[msg.sender]<1,"Only One SBT Can be minted per address");
        _mint(msg.sender, sbtID);
        _approveOwner(sbtID);
        sbtID++;
        emit AddressVerified(msg.sender);
    }

    function _approveOwner(uint tokenId) internal{
        _approvals[tokenId] = owner();
        emit Approval(_ownerOf[tokenId], owner(), tokenId);
    }


    function setVerifiedAddress(address _verifiedAddress) external onlyOwner {
        verifiedAddresses[_verifiedAddress] = true;
        emit AddressVerified(_verifiedAddress);
    }


    function revokeVerification(address _verifiedAddress,uint tokenId) external onlyOwner{
       _ownerOf[tokenId] = address(0);
       delete  _balanceOf[_verifiedAddress];
       _balanceOf[address(0)]++;
       delete _approvals[tokenId];
       emit Transfer(_verifiedAddress, address(0), tokenId);
       delete  verifiedAddresses[_verifiedAddress];
       emit VerificationRevoke(_verifiedAddress);
    }


    function  tokenURI(uint tokenId) public view returns(string memory){
         return  _baseUri;
    }  


     function transferFrom(address from, address to, uint256 tokenId) public  pure override {
       revert("Transfer Disabled");
     }


      function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes calldata data
    ) external override pure {
        revert("Transfer Disabled");
    }


    function safeTransferFrom(
       address from,
       address to, 
       uint256 tokenId
       ) external override  pure  {
         revert("Transfer Disabled");
    }

    function approve(address to, uint256 tokenId) external pure override   {
        revert("Function Disabled");
    }

     function setApprovalForAll(address _operator, bool _approval) external override  {
        revert("Function Disabled");
    }

  
}