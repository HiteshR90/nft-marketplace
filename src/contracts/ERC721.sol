// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './ERC165.sol';
import './interfaces/IERC721.sol';

contract ERC721 is ERC165, IERC721 {

    //mapping from token id to owner
    mapping (uint256 => address) private _tokenOwner;

    //mapping from token owner to number of owned token
    mapping(address => uint256) private _ownedTokenCount;

    //mapping from token id to approve addresses
    mapping(uint256 => address) private _tokenApprovals;

    constructor () {
        _registerInterface(bytes4(keccak256('balanceOf(bytes4)')
                                ^keccak256('ownerOf(bytes4)')
                                ^keccak256('transferFrom(bytes4)')));
    }

    function balanceOf(address _owner) public view returns(uint256) {
        require(_owner != address(0), 'Owner query for non-existnce token');
        return _ownedTokenCount[_owner];
    }

    function ownerOf(uint256 _tokenId) public view returns(address) {
        address owner = _tokenOwner[_tokenId];
        require(owner != address(0),'ERC721: Invalid token id');
        return owner;
    }

    function _exist(uint256 _tokenId) internal view returns(bool) {
        address owner = _tokenOwner[_tokenId];
        return owner != address(0);
    }

    function _mint(address to, uint256 tokenId) internal virtual {
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

    /// @notice Transfer ownership of an NFT -- THE CALLER IS RESPONSIBLE
    ///  TO CONFIRM THAT `_to` IS CAPABLE OF RECEIVING NFTS OR ELSE
    ///  THEY MAY BE PERMANENTLY LOST
    /// @dev Throws unless `msg.sender` is the current owner, an authorized
    ///  operator, or the approved address for this NFT. Throws if `_from` is
    ///  not the current owner. Throws if `_to` is the zero address. Throws if
    ///  `_tokenId` is not a valid NFT.
    /// @param _from The current owner of the NFT
    /// @param _to The new owner
    /// @param _tokenId The NFT to transfer
    function _transferFrom(address _from, address _to, uint256 _tokenId) internal {
        require(ownerOf(_tokenId) == _from, 'Trying to transfer a token the address does not own!');
        require(_to != address(0), 'Error - ERC721 Transfer to zero address');

        _tokenOwner[_tokenId] = _to;
        _ownedTokenCount[_to] += 1;

        _ownedTokenCount[_from] -= 1;

        emit Transfer(_from, _to, _tokenId);
    }

    function transferFrom(address _from, address _to, uint256 _tokenId) public{
        require(isApprovedOrOwner(msg.sender, _tokenId));
        _transferFrom(_from, _to, _tokenId);
    }

   function approve(address _to, uint256 _tokenId) public {
        address owner = ownerOf(_tokenId);
        require(msg.sender == owner, 'Current caller is not the owner of the token');
        require(owner!= _to, 'Error - approval to current owner');
        _tokenApprovals[_tokenId] = _to;

        emit Approval(owner, _to, _tokenId);
    }

    function isApprovedOrOwner(address spender, uint tokenId) internal view returns (bool){
        require(_exist(tokenId), 'Token does not exist');
        address owner = ownerOf(tokenId);
        return (spender == owner);
    }
}