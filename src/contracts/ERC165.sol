// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './interfaces/IERC165.sol';

contract ERC165 is IERC165 {

    mapping(bytes4 => bool) private _supportedInterfaces;

    function supportsInterface(bytes4 interfaceID) external view returns (bool) {
        return _supportedInterfaces[interfaceID];
    }

    constructor () {
        _registerInterface(bytes4(keccak256('supportsInterface(bytes4)')));
    }

    function _registerInterface(bytes4 interfaceId) internal {
        require(interfaceId != 0xffffffff, "Invalid Interface request");
        _supportedInterfaces[interfaceId] = true;
    }
}