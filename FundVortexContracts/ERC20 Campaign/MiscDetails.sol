// SPDX-License-Identifier: MIT
pragma solidity  0.8.26;


contract TokenMiscDetails{
     struct  MiscDetails{
        string description;
        string webpage;
        string TokenImageUrl;
        string TokennomicsImageUrl;
        string BannerImageUrl;
     }
     MiscDetails public miscDetails;

     constructor(
        string memory _description,
        string memory _webpage,
        string memory _tokenImageUrl,
        string memory _tokennomicsImageUrl,
        string memory _BannerImageUrl
     ){
        miscDetails = MiscDetails(_description,_webpage,_tokenImageUrl,_tokennomicsImageUrl,_BannerImageUrl);
     }
}