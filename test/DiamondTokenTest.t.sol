// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Test} from "forge-std/Test.sol";
import {DiamondToken} from "src/DiamondToken.sol";
import {Ownable} from "lib/openzeppelin-contracts/contracts/access/Ownable.sol";
import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import {IERC20Errors} from "lib/openzeppelin-contracts/contracts/interfaces/draft-IERC6093.sol";

contract DiamondTokenTest is Test {
    DiamondToken public diamondToken;
    address public constant OWNER = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;
    uint256 public constant DECIMALS = 18;
    uint256 public constant INITIAL_SUPPLY = 10000 * 10 ** DECIMALS;

    address bob = makeAddr("bob");
    address alice = makeAddr("alice");

    function setUp() public {
        diamondToken = new DiamondToken(OWNER);
    }

    function testOwner() public view {
        assertEq(diamondToken.owner(), OWNER);
    }

    function testName() public view {
        assertEq(diamondToken.name(), "DiamondToken");
    }

    function testSymbol() public view {
        assertEq(diamondToken.symbol(), "DMT");
    }

    function testDecimals() public view {
        assertEq(diamondToken.decimals(), 18);
    }

    function testInitialSupply() public view {
        assertEq(diamondToken.totalSupply(), INITIAL_SUPPLY);
    }

    function testOwnerBalance() public view {
        assertEq(diamondToken.balanceOf(OWNER), INITIAL_SUPPLY);
    }

    function testMint() public {
        vm.prank(OWNER);
        diamondToken.mint(bob, 100 * 10 ** DECIMALS);
        assertEq(diamondToken.balanceOf(bob), 100 * 10 ** DECIMALS);
    }

    function testTotalSupplyAfterMint() public {
        vm.prank(OWNER);
        diamondToken.mint(bob, 100 * 10 ** DECIMALS);
        assertEq(diamondToken.totalSupply(), INITIAL_SUPPLY + 100 * 10 ** DECIMALS);
    }

    function testOnlyOwnerCanMint() public {
        vm.prank(bob);
        vm.expectRevert(
            abi.encodeWithSelector(
                Ownable.OwnableUnauthorizedAccount.selector,
                bob
            )
        );
        diamondToken.mint(bob, 100 * 10 ** DECIMALS);
    }

    function testTransfer() public {
        vm.prank(OWNER);
        diamondToken.transfer(bob, 100 * 10 ** DECIMALS);
        assertEq(diamondToken.balanceOf(bob), 100 * 10 ** DECIMALS);
    }

    function testTransferEmitsTransferEvent() public {
        vm.startPrank(OWNER);
        vm.expectEmit(true, true, false, true, address(diamondToken));
        emit IERC20.Transfer(OWNER, bob, 100 * 10 ** DECIMALS);
        diamondToken.transfer(bob, 100 * 10 ** DECIMALS);
        vm.stopPrank();
    }

    function testApprove() public {
        vm.prank(OWNER);
        diamondToken.approve(bob, 100 * 10 ** DECIMALS);
        assertEq(diamondToken.allowance(OWNER, bob), 100 * 10 ** DECIMALS);
    }

    function testApproveEmitsApprovalEvent() public {
        vm.startPrank(OWNER);
        vm.expectEmit(true, true, false, true, address(diamondToken));
        emit IERC20.Approval(OWNER, bob, 100 * 10 ** DECIMALS);
        diamondToken.approve(bob, 100 * 10 ** DECIMALS);
        vm.stopPrank();
    }

    function testTransferFromWithApproval() public {
        vm.prank(OWNER);
        diamondToken.approve(bob, 100 * 10 ** DECIMALS);

        vm.prank(address(bob));
        diamondToken.transferFrom(OWNER, alice, 100 * 10 ** DECIMALS);

        assertEq(diamondToken.balanceOf(alice), 100 * 10 ** DECIMALS);
        assertEq(diamondToken.allowance(OWNER, bob), 0);
    }

    function testCannotTransferWithoutApproval() public {
        vm.startPrank(bob);
        vm.expectRevert(
            abi.encodeWithSelector(
                IERC20Errors.ERC20InsufficientAllowance.selector,
                bob,
                0,
                100 * 10 ** DECIMALS
            )
        );
        diamondToken.transferFrom(OWNER, alice, 100 * 10 ** DECIMALS);
        vm.stopPrank();
    }

    function testBurn() public {
        uint256 ownerInitialBalance = diamondToken.balanceOf(OWNER);

        vm.prank(OWNER);
        diamondToken.burn(100 * 10 ** DECIMALS);

        assertEq(diamondToken.totalSupply(), INITIAL_SUPPLY - 100 * 10 ** DECIMALS);
        assertEq(diamondToken.balanceOf(OWNER), ownerInitialBalance - 100 * 10 ** DECIMALS);
    }

    function testBurnEmitsTransferEvent() public {
        vm.startPrank(OWNER);
        vm.expectEmit(true, true, false, true, address(diamondToken));
        emit IERC20.Transfer(OWNER, address(0), 100 * 10 ** DECIMALS);
        diamondToken.burn(100 * 10 ** DECIMALS);
        vm.stopPrank();
    }

    function testCannotBurnWithoutApproval() public {
        vm.prank(bob);
        vm.expectRevert(
            abi.encodeWithSelector(
                IERC20Errors.ERC20InsufficientAllowance.selector,
                bob,
                0,
                100 * 10 ** DECIMALS
            )
        );
        diamondToken.burnFrom(OWNER, 100 * 10 ** DECIMALS);
        vm.stopPrank();
    }
}
