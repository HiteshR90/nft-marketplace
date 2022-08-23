// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library SafeMath {

    function add(uint256 x, uint256 y) internal pure returns(uint256) {
        uint256 r = x + y;
        require(r >= x, 'SafeMath: addition overflow');
        return r;
    }

    function sub(uint256 x, uint256 y) internal pure returns(uint256) {
        require(x >= y, 'SafeMath: subtraction overflow');
        uint256 r = x - y;
        return r;
    }

    function mul(uint256 x, uint256 y) internal pure returns(uint256) {
        uint256 r = x * y;
        require(r/x == y, 'SafeMath: multiplication overflow');
        return r;
    }

    function devide(uint256 x, uint256 y) internal pure returns(uint256) {
        require(y >0, 'SafeMath: devision overflow');
        return x / y;
    }

    function mod(uint256 x, uint256 y) internal pure returns(uint256) {
        require(y != 0, 'SafeMath: modulo overflow');
        return x % y;
    }
}