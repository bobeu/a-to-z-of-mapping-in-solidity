// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.18;

/**@title EnumVsMappingEnumToEnum: 
    Demonstrates how to use enum in mapping: enum for both key and value

    Ex. In the contract below, we use enum `Class` to denote the 
        different classes in an interhouse sport, while `Positions` represents each class's performance.
*/

contract EnumInMappingEnumToEnum {

  /**Note: 
        Clas.BLUE equivalent to 0.
        Class.YELLOW = 1.
        Class.GREEN = 2.
        Class.RED = 3.
   */
  enum Class {BLUE, YELLOW, GREEN, RED}

  enum Position {NONE, FIRST, SECOND, THIRD, FOURTH}

  ///@dev Using enum for both key and value.
  mapping(Class => Position) public performances;

  // We have to ensure the argument supplied does not exceed the length of the form else we get error.
  /// Note: Similar to arrays, enums are zero-based so the index of the last item in our enum `Form` will be 5.
  modifier ensureIndexTally(uint8 classID) {
    require(classID < 4, "ID Out of bound");
    _;
  }

  /**@dev We want to be sure each of the houses has no position yet.
     Although, by default in the mapping, each house has `NONE` as position. But for demonstration purpose, it is
     ok to do that.
   */
  constructor() {
    for (uint i = 0; i < 4; i++) {
      performances[Class(i)] = Position.NONE; // Each house will have no positon
    }
  }

  /// @dev retrives the performance of a particular house
  function getPerformance(uint8 classID) public ensureIndexTally(classID) returns(string memory) {
    return _getPosition(uint8(performances[Class(classID)]));
  }

  function _getPosition(uint8 index) internal returns(string memory _position) {
    _position = index == 4 ? "FOURTH" : index == 3? "THIRD" : index == 2? "SECOND" : "FIRST";
  } 

  /**@dev Change the number of students in a class
   */
  function updatePerformance(uint8 classID, uint positionID) public ensureIndexTally(classID){
    // Ensure the positionID tally with the length of the Position enum;
    performances[Class(classID)] = Position(positionID);
  }
}