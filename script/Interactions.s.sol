// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Script} from "forge-std/Script.sol";
import {DiamondToken} from "src/DiamondToken.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract MintDiamondToken is Script {
    address public owner;

    constructor() {
        HelperConfig helperConfig = new HelperConfig();
        owner = helperConfig.i_owner();
    }

    function run() public {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment(
            "DiamondToken",
            block.chainid
        );
        mintDiamondTokenOnContract(mostRecentlyDeployed);
    }

    function mintDiamondTokenOnContract(address diamondToken) public {
        vm.startBroadcast();
        DiamondToken(diamondToken).mint(owner, 1000 ether);
        vm.stopBroadcast();
    }
}
