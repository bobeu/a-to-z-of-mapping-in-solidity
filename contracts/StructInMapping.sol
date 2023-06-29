// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.18;

contract StructInMapping {
  enum Remark {NONE, POOR, AVERAGE, GOOD, EXCELLENT}
  enum Term {FIRST, SECOND, THIRD}
  enum Classes {FORM1, FORM2, FORM3, FORM4, FORM5}

  uint public totalStudents;

  address public registrar;

  struct StudentData {
    Bios bio;
    OfficialInfo officialInfo;
  }

  struct Wallet {
    uint totalAmountInWallet;
    uint spent;
  }

  struct Bios {
    string surname;
    string lastName;
    uint age;
    uint height;
    string stateOfOrigin;
    uint dateOfBirth;
  }

  struct OfficialInfo {
    uint dateRegistered;
    Classes classAdmitted;
    uint tuitionFee;
    uint otherFee;
    bool admitted;
    Wallet wallet;
    ClassActivities activity;
  }

  struct ClassActivities {
    uint tests;
    uint examScores;
    uint grade;
    Remark remark;
  }

  ///@dev Maps student address to their data
  mapping(address => mapping(Term => StudentData)) public students;

  constructor(address _registrar) {
    registrar = _registrar;
  }

  function registerStudent(
    string memory surname,
    string memory lastName,
    string memory stateOfOrigin,
    uint8 class,
    uint age,
    uint height,
    uint tuitionFee,
    uint dateOfBirth,
    address studentID
  ) public {
    require(msg.sender == registrar, "Only registrar is allowed");
    require(class < 5, "Out of bound");
    students[studentID][Term.FIRST] = StudentData(
      Bios(surname, lastName, age, height, stateOfOrigin, dateOfBirth),
      OfficialInfo(
        block.timestamp, 
        Classes(class),
        tuitionFee, 
        0, 
        true,
        Wallet(0, 0),
        ClassActivities(0, 0, 0, Remark.NONE)
      )
    );
  }
  
}