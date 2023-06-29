// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.18;

contract MappingConventionsAndBestPractices {
  struct Data {
    bytes somedata;
  }

  enum Steps {START, STOP}

  /**In mapping declarations, do not separate the keyword `mapping` 
    from its type by a space. Do not separate any nested mapping keyword from its type by whitespace.
  */
  // Good
  mapping(uint => uint) good;
  mapping(address => bool) isAddress;
  mapping(uint => mapping(bool => Data[])) public data;
  mapping(uint => mapping(uint => Steps)) steps;

  // Wrong
  mapping (uint => uint) wrong;
  mapping( address => bool ) isAddress2;
  mapping (uint => mapping (bool => Data[])) public data2;
  mapping(uint => mapping (uint => Steps)) steps2;
}