// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {Trump} from "../src/TrumpWasRightToken.sol";

contract DeployToken is Script {
    uint256 public constant TOKEN_SUPPLY = 1000000 ether;

    function run() external returns (Trump) {
        // Deploy the token
        vm.startBroadcast();
        Trump twr = new Trump(TOKEN_SUPPLY);
        vm.stopBroadcast();
        return twr;
    }
}
