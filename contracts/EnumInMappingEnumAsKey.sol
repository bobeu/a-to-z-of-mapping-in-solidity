// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.18;

/**@title EnumVsMapping: 
    Demonstrates how to use enum in mapping

    Ex. In the contract below, we use enum `Form` to denote the 
        different classes of students while the `students` mapping
        shows the number of students in each class. 
*/

contract EnumInMappingEnumAsKey {

  enum Form { A, B, C, D, E, F}

  ///@dev Using enum as the key, and uint256 type for value
  mapping(Form => uint256) public students;

  // We have to ensure the argument supplied does not exceed the length of the form else we get error.
  /// Note: Similar to arrays, enums are zero-based so the index of the last item in our enum `Form` will be 5.
  modifier ensureIndexTally(uint8 classID) {
    require(classID < 6, "ID Out of bound");
    _;
  }

  /**@dev In the constructor, we accept an array of the number of students in the classes
        Note: The length of thr `umberOfStudents` cannot be greater than 6 else it will not deploy.
              Since we have length of the `umberOfStudents` array tally with the enum `Form`, we can run a loop
              to simplify the process rather than adding them one by one.
   */
  constructor(uint[6] memory numberOfStudents) {
    for (uint i = 0; i < numberOfStudents.length; ++i) {
      students[Form(i)] = numberOfStudents[i];
    }
  }

  function fetchTotalStudentInAClass(uint8 classID) public view ensureIndexTally(classID) returns(uint256) {
    return students[Form(classID)];
  } 

  /**@dev Change the number of students in a class
   */
  function updateNumberOfStudents(uint8 classID, uint newNumberOfStudent) public ensureIndexTally(classID){
    students[Form(classID)] = newNumberOfStudent;
  }
}