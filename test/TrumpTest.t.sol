// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Test, console} from "forge-std/Test.sol";
import {DeployToken} from "../script/DeployToken.s.sol";
import {Trump} from "../src/TrumpWasRightToken.sol";

contract TrumpTest is Test {
    Trump public twr2024;
    DeployToken public deployer;

    address jacory = makeAddr("Jacory");
    address ian = makeAddr("Ian");
    address elijah = makeAddr("Elijah");
    address uriel = makeAddr("Uriel");

    uint256 public constant STARTING_BALANCE = 100 ether;

    function setUp() external {
        deployer = new DeployToken();
        twr2024 = deployer.run();

        vm.prank(address(msg.sender));
        twr2024.transfer(jacory, STARTING_BALANCE);
    }

    function testJacoryBalance() public {
        assertEq(STARTING_BALANCE, twr2024.balanceOf(jacory));
    }

    function testAllowancesWorks() public {
        uint256 initalAllowance = 1000;

        //Jacory approves Ian to spend tokens on his behalf
        vm.prank(jacory);
        twr2024.approve(ian, initalAllowance);

        uint256 transferAmount = 500;

        vm.prank(ian);
        twr2024.transferFrom(jacory, elijah, transferAmount);

        assertEq(transferAmount, twr2024.balanceOf(elijah));
        assertEq(STARTING_BALANCE - transferAmount, twr2024.balanceOf(jacory));
        console.log("Elijah's balance: ", twr2024.balanceOf(elijah));
        console.log("Jacory's balance: ", twr2024.balanceOf(jacory));
        console.log("Ian's balance: ", twr2024.balanceOf(ian));
    }

    function testTransfer() public {
        uint256 transferAmount = 50;

        // Jacory transfers tokens to Ian
        vm.prank(jacory);
        twr2024.transfer(ian, transferAmount);

        assertEq(transferAmount, twr2024.balanceOf(ian));
        assertEq(STARTING_BALANCE - transferAmount, twr2024.balanceOf(jacory));
        console.log("Ian's balance: ", twr2024.balanceOf(ian));
        console.log("Jacory's balance: ", twr2024.balanceOf(jacory));
    }

    function testTransferFrom() public {
        uint256 initialAllowance = 1000;

        // Jacory approves Ian to spend tokens on his behalf
        vm.prank(jacory);
        twr2024.approve(ian, initialAllowance);

        uint256 transferAmount = 200;

        // Ian transfers tokens from Jacory to Uriel
        vm.prank(ian);
        twr2024.transferFrom(jacory, uriel, transferAmount);

        assertEq(transferAmount, twr2024.balanceOf(uriel));
        assertEq(STARTING_BALANCE - transferAmount, twr2024.balanceOf(jacory));
        console.log("Uriel's balance: ", twr2024.balanceOf(uriel));
        console.log("Jacory's balance: ", twr2024.balanceOf(jacory));
        console.log("Ian's balance: ", twr2024.balanceOf(ian));
    }

    // function testInsufficientAllowance() public {
    //     uint256 initialAllowance = 100;

    //     // Jacory approves Ian to spend tokens on his behalf
    //     vm.prank(jacory);
    //     twr2024.approve(ian, initialAllowance);

    //     uint256 transferAmount = 200;

    //     // Ian attempts to transfer more than the approved allowance from Jacory to Elijah
    //     vm.prank(ian);
    //     bool success = twr2024.transferFrom(jacory, elijah, transferAmount);

    //     assertFalse(
    //         success,
    //         "Transfer should fail due to insufficient allowance"
    //     );
    // }
}
