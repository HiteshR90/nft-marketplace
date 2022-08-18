// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './ERC721Metadata.sol';
import './ERC721.sol';

contract ERC721Connector is ERC721Metadata, ERC721{

    string[] public kryptoBirds;

    mapping(string=>bool) _kryptoBirdsExist;

    function mint(string memory _kryptoBird) public {

        require(!_kryptoBirdsExist[_kryptoBird],'Error - KryptoBird already exist');

        kryptoBirds.push(_kryptoBird);
        uint _id = kryptoBirds.length - 1;
        _mint(msg.sender, _id);

        _kryptoBirdsExist[_kryptoBird] = true;
    }

    constructor(string memory name, string memory symbol) ERC721Metadata(name, symbol){

    }
}