// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "src/ERC721.sol";

contract ERC721Test is Test {
  TestNFT testNFT;
  address noah = address(0x1);
  address sofia = address(0x2);

  event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
  event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);

  function setUp() public {
    testNFT = new TestNFT();
  }

  function testMint() public {
    testNFT.mint(noah, "testhash");
    address owner_of = testNFT.ownerOf(0);
    assertEq(noah, owner_of);
  }

  function testBalance() public {
    testNFT.mint(sofia, "testhash");
    testNFT.mint(sofia, "testhash");
    testNFT.mint(sofia, "testhash");

    uint balance = testNFT.balanceOf(sofia);
    assertEq(balance, 3);
  }

  function testOwnerOf() public {
    testNFT.mint(noah, "testhash");

    address owner = testNFT.ownerOf(0);
    assertEq(owner, noah);
  }

  function testApprove(address approveTo) public {
    testNFT.mint(noah, "testhash");
    vm.startPrank(noah);

    testNFT.approve(approveTo, 0);
    address approvedToAddress = testNFT.getApproved(0);

    assertEq(approveTo, approvedToAddress);
  }

  function testApprove_EmitsApproval(address approveTo) public {
    testNFT.mint(noah, "testhash");
    vm.startPrank(noah);

    vm.expectEmit(true, true, true, false);
    emit Approval(noah, approveTo, 0);

    testNFT.approve(approveTo, 0);
  }

  function testTransfer() public {
    testNFT.mint(noah, "ahash");
    vm.startPrank(noah);
    testNFT.safeTransferFrom(noah, sofia, 0);

    address ownerOf = testNFT.ownerOf(0);
    assertEq(sofia, ownerOf);
  }

  function testTransfer_EmitsTransfer() public {
    testNFT.mint(noah, "ahash");
    vm.startPrank(noah);

    vm.expectEmit(true, true, true, false);
    emit Transfer(noah, sofia, 0);

    testNFT.safeTransferFrom(noah, sofia, 0);
  }

  function testTransferFail() public {
    testNFT.mint(noah, "ahash");
    testNFT.mint(sofia, "ahash2");

    vm.startPrank(noah);
    vm.expectRevert();
    testNFT.safeTransferFrom(noah, sofia, 1);
  }
}
