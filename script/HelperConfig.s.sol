// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Script} from "forge-std/Script.sol";

contract HelperConfig is Script {
    address public i_owner;

    constructor() {
        if (block.chainid == 31337) {
            i_owner = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;
        } else {
            i_owner = 0x01BF49D75f2b73A2FDEFa7664AEF22C86c5Be3df;
        }
    }
}
