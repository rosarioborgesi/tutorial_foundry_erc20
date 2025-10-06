// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Script} from "forge-std/Script.sol";
import {DiamondToken} from "../src/DiamondToken.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract DeployDiamondToken is Script {
    
    function run() public returns (DiamondToken) {
        HelperConfig helperConfig = new HelperConfig();
        address owner = helperConfig.i_owner();

        vm.startBroadcast();
        DiamondToken diamondToken = new DiamondToken(owner);
        vm.stopBroadcast();
        return diamondToken;
    }
}
