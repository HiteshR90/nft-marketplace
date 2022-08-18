// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


contract ERC721 {

    event Transfer(
                address indexed from, 
                address indexed to, 
                uint256 indexed tokenId);

    //mapping from token id to owner
    mapping (uint256 => address) private _tokenOwner;

    //mapping from token owner to number of owned token
    mapping(address => uint256) private _ownedTokenCount;

    function _exist(uint256 _tokenId) internal view returns(bool) {
        address owner = _tokenOwner[_tokenId];
        return owner != address(0);
    }

    function _mint(address to, uint256 tokenId) internal {
        //requires that address isn't zero
        require(to != address(0), 'ECR721: Minting to 0 address');
        //requires the token does not already exist
        require(!_exist(tokenId), 'ECR721: Token already minted');
        //we are adding a new address with a token id for mining
        _tokenOwner[tokenId] = to;
        //keeping track of each address miniting and adding one to the count
        _ownedTokenCount[to] += 1;

        emit Transfer(address(0), to, tokenId);
    }
}