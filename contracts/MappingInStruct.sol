// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.18;

contract MappingInStruct {
  error AlreadySignedUp();

  struct Profile {
    string surname;
    uint age;
    uint balance;
    bytes32 dataIntegrity;
    bool isUser;
  }

  // Structured data that contain users' balances and profiles
  struct Data {
    mapping(address => Profile) profiles;
  }

  Data private data;

  ///@dev Signs up a new user
  function signUp(string memory surname,uint8 age) public payable {
    if(data.profiles[msg.sender].isUser) revert AlreadySignedUp();
    data.profiles[msg.sender] = Profile(surname, age, msg.value, keccak256(abi.encodePacked(surname, msg.sender, age)),true);
  }

  ///@dev Get user's profile by their address.
  function getUserInfo(address who) public view returns(Profile memory _prof) {
    _prof = data.profiles[who];
  } 

  ///@notice Users can delete their account at will
  function deleteAccount() public {
    require(data.profiles[msg.sender].isUser, "Not registered");
    delete data.profiles[msg.sender];
  }

}