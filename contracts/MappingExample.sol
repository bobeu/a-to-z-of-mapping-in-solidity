// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

contract MappingExamples {

  // Maps uint to bytes
  mapping(uint256 => bytes) public nameCodes;

  // uint256 to string
  mapping(uint256 => string) public names;

  // bytes to bytes32
  mapping(bytes => bytes32) public nameHashes;

  // bytes32 to uint
  mapping(bytes32 => uint) public ids;

  function getNameCode(uint key) public view returns(bytes memory) {
    return nameCodes[key];
  }
  function getName(uint key) public view returns(string memory) {
    return names[key];
  }
  function getNameHash(string memory key) public view returns(bytes32) {
    return nameHashes[bytes(key)];
  }
  function getNameCode(bytes32 key) public view returns(uint) {
    return ids[key];
  }

}