// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './ERC721Connector.sol';

contract KryptoBirdz is ERC721Connector{
    
    string[] public kryptoBirds;

    mapping(string=>bool) _kryptoBirdsExist;

    function mint(string memory _kryptoBird) public {

        require(!_kryptoBirdsExist[_kryptoBird],'Error - KryptoBird already exist');

        kryptoBirds.push(_kryptoBird);
        uint _id = kryptoBirds.length - 1;
        _mint(msg.sender, _id);

        _kryptoBirdsExist[_kryptoBird] = true;
    }
    
    constructor() ERC721Connector('KryptoBird', 'KBIRDZ'){
        
    }
}