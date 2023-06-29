// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.18;

contract IterationVsMapping {

  // initialise a counter and an mapping in addition to the mapping you intend to iterate over
  uint counter; // you should initialize this to 0 in the constructor

  // the value in the counterToAddress mapping points to the key in the next mapping
  mapping (uint => address) private counterToAddress;

  // intend to iterate over the mappings mapping:
  mapping (address => uint) private mappings;

  constructor() {
    counter = 0;
  }

  function addToMappings(address target) public {
    counter ++;
    counterToAddress[counter] = target;
    mappings[counterToAddress[counter]] = counter;
  }

  function iterateOverMappings() public view returns(uint currentValue) {
    for (uint i=0; i < counter; i++) {
      currentValue = mappings[counterToAddress[i]];
    }
  }
  
}
