# Introduction

Writing deployable smart contracts on the Celo Blockchain is influence largely by the Solidity programming language. Being skilful in any profession depends on deep is our knowledge of the subject. Understanding Solidity's data types will increase your proficiency of the language. I have prepared this guide to dive deeper into mapping in Solidity. We will explore couple of ways you can use mapping while blending it with other Solidity types to give you desired result. 

# Prerequisites

To get the best from this tutorial, you need to have general programming knowledge and be at least a beginner in Solidity programming. I also assume that you know how to write unit testing otherwise, I recommend starting from **[here]()**

# Requirements

Basically, you need not install any tools if you are familiar with online IDE like **[Remix]()**. But I am fond of working with the commandline, so VSCode is my favorite.

If you intend to use Code editor such as VSCode, follow the steps below to set up a hardhat project.

- Install Hardhat

```bash
mkdir mappingInSolidity && cd mappingInSolidity
```
```bash
npm install hardhat
```

- Start Hardhat project

```bash
npx hardhat
```

- Follow the instructions in the terminal to complete the setup.

> Note: You do not need to install all the dependencies given in the terminal. We only need hardhat to compile the contracts which is done by the `npm install hardhat` command.

# Contents

- What is mapping in Solidity
- Mapping Conventions and best practices
- Array in Mapping
- Mapping example
- Enum in Mapping: Using Enum as a Key
- Enum in Mapping: Using Enum both as a Key and value
- Mapping in Struct
- Struct in Mapping
- Nested Mapping
- Interating through Mapping

## 1. What is mapping in Solidity

Mapping is a reference type just like arrays and structs in Solidity. It is one of the data types well-used in Solidity and is used to persist data across functions in smart contracts i.e. storage. Mapping is represented as a key-value pair in storage where a generic data type is mapped to another generic or user-defined type.

### What are generic types?

These are built-in types in Solidity. Examples are `uint256`, `uint128`, `bytes`, `bytes32` and so on.

### What are user-defined types

Just as in C++, you can create your own type in solidity using the generic types. To create a user-defined type, Solidity provides a keyword `struct`. To create a user-defined types, use the following syntax.

```js
struct <TypeName> {

}
```
You use the `struct` keyword followed by the desired name. A good practice is to start with an Uppercase such as:

```js
struct MyDataType {
  uint128 value;
  string surname;
  bytes32 password;
}
```

The syntax of mapping can be written as: 

```js
mapping(_KeyType => _ValueType) <visibility> <identifier>;
```
Where:
`_KeyType` − can be any built-in types plus bytes and string except for reference type or complex objects such as struct, mapping and array .

`_ValueType` − can be any type.

## 2. Mapping Conventions and best practices

### Things to note about mapping

- Mapping can only have type of storage and are generally used for state variables.

- Visibility in mapping is optional is earlier versions of Solidity but it defaults to `private` in later versions.

- When Mapping is marked public, Solidity automatically create a getter function for it.

- Mapping cannot be directly iterated. But we have special ways in doing that.

- Complex types such as array or struct cannot be used as key.

- You cannot return the full contents in a mapping at once.


### Declaring a mapping

Precuations must be taken when declaring a mapping.

- In mapping declarations, do not separate the keyword `mapping` from its type by whitespace.

The code below displays examples of mapping. Examine it vividly to identify the best and wrong ways of declaring mapping.

```js
  // SPDX-License-Identifier: MIT
  pragma solidity 0.8.18;

  contract MappingConventionsAndBestPractices {
    struct Data {
      bytes somedata;
    }

    enum Steps {START, STOP}

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
```

## 3. Array in Mapping

In the example code below, I show how arrays can be used inside mapping.
It explains: 
  - Declaring an array of hashes in a `mapping`.
  - Adding, replacing, fetching and deleting item in an array in a `mapping`.
  - A generic type `uint256` is used as the key referencing the value array of `bytes32` values.
  - Different numbers within `2^256-1` cannot have values other than a list of hashes. Solidity will automatically create a getter function for the `hashes` with type `uint256` as an argument. So if we give any number within the uint256 range, we get an array of `bytes32` in return.
  - We can loop through the array in the mapping.  

```js
  // SPDX-License-Identifier: MIT
  pragma solidity 0.8.18;

  contract ArrayInMapping {

    mapping(uint256 => bytes32[]) public hashes;

    /**@dev Retrieves a hash from the list of hashes in a mapping
      @param hashId : Index or position of the hash in the array of hashes
      @param outerKey : outer index or key in the mapping

      Note: 
    */
    function getHash(uint outerKey, uint hashId) public view returns(bytes32 _hash) {
      _hash = hashes[outerKey][hashId];
    }

    /**@dev Retrieves an array of hashses from the mapping using a number of type uint as a key
      @param outerKey : outer index or key in the mapping
    */
    function getHash(uint outerKey) public view returns(bytes32[] memory _hashes) {
      _hashes = hashes[outerKey];
    }

    /** @dev Adds an item to the end of an array in a mapping
     */
    function addItem(uint outerKey, bytes32 newHash) public {
      hashes[outerKey].push(newHash);
    }

    /** @dev Replace an item in an array in mapping at a specific index
     */
    function replaceItem(uint outerKey, uint index, bytes32 newHash) public {
      hashes[outerKey][index] = newHash;
    }

    /**@dev Deletes an array of hashes in a mapping
     */
    function deleteHashes(uint outerKey) public {
      delete hashes[outerKey];
    }

    /**@dev Deletes a hash in an array in mapping
      Note: This method leaves a gap in the array
    */
    function deleteHash(uint outerKey, uint hashId) public {
      delete hashes[outerKey][hashId];
    }

  }
```

## 4. Mapping example

Here is an example showing how mapping can be used with a few generic types: `bytes`, `string`, `bytes32` and `uint`. The code displays how we can fetch data of different types from mapping. I strongly recommend to go the code to fully understand how mapping was used.


```js
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
```

## 5. Enum in Mapping: Using Enum as a Key

This is one of the patterns I love using when coding in Solidity. The below code demonstrates how to use enum in mapping. Enumerator otherwise called `enum` is used as a key.

Here is how enums are declared in solidity

```js
enum <identifier> { MEMBER1, MEMBER2, ..., MEMBERn }
```
- In the contract below, we use enum `Form` to denote the different classes of students while the `students` mapping shows the number of students in each class.

- The modifier `ensureIndexTally` ensures the argument supplied does not exceed the length of the members of enum `Form` else we get error.

>Note: Similar to arrays, enums are zero-based so the index of the last item in our enum `Form` will be 5.

- In the constructor, we accept an array of the number of students in the classes

> Note: The length of the `umberOfStudents` cannot be greater than 6 else it will not deploy.

- Since we have length of the `umberOfStudents` array tally with the enum `Form`, we can run a loop to simplify the process instead of adding them one after the other.

```js
  // SPDX-License-Identifier: MIT
  pragma solidity 0.8.18;

  /**@title EnumVsMapping: 
      
  */

  contract EnumInMappingEnumAsKey {

    enum Form { A, B, C, D, E, F}

    ///@dev Using enum as the key, and uint256 type for value
    mapping(Form => uint256) public students;

    modifier ensureIndexTally(uint8 classID) {
      require(classID < 6, "ID Out of bound");
      _;
    }

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
```

## 6. Enum in Mapping: Using Enum both as a Key and value

The `EnumInMappingEnumToEnum` demonstrates how to use enum in mapping both for key and value.

In the contract below, we use enum `Class` to denote the different classes in an interhouse sport, while `Positions` represents each Class's performances.

> Note: In `enum Class {BLUE, YELLOW, GREEN, RED}`
> Clas.BLUE IS equivalent to 0.
> Class.YELLOW = 1.
> Class.GREEN = 2.
> Class.RED = 3.

- The modifier `ensureIndexTally` enforces a check that ensures the argument supplied does not exceed the length of the members in the `Class` enum else we get error.

- In the constructorm we want to be sure each of the houses has no position set yet. Although, by default in the mapping, each house has `NONE` as position. But for demonstration purpose, it is ok to do that.

```js
  // SPDX-License-Identifier: MIT
  pragma solidity 0.8.18;

  contract EnumInMappingEnumToEnum {

    enum Class {BLUE, YELLOW, GREEN, RED}

    enum Position {NONE, FIRST, SECOND, THIRD, FOURTH}

    ///@dev Using enum for both key and value.
    mapping(Class => Position) public performances;

    modifier ensureIndexTally(uint8 classID) {
      require(classID < 4, "ID Out of bound");
      _;
    }

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
```

## 7. Mapping in Struct

The following code displays how user-defined type i.e.`struct` can be used in a mapping.

- We declared a `struct` as a reference type to the data we will need in the storage. 

- Inside the struct we also declared a mapping. Even though a mapping is a storage reference, yet we do not have any data in storge until we explicitly created a top storage reference as a state variable named `data`.

- The `data` storage reference creates a slot in storage with `Data` as the type of data we can keep in the storage.

- The `Profile` struct was used as the value with an address as the key or reference. If an address is given, a `Profile` object returned. 

- I used the `signUp` function as example to show how we can input data to the mapping via the state variable `data`. It simply signs up a new user. Other functions `deleteAccount` allows users to remove themselves from the system while `getUserInfo` returns information about specific user address.


```js
  // SPDX-License-Identifier: MIT
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
```

## 8. Struct in Mapping

The example contract below shows how to deep-nest struct in struct and use the root struct as a value in mapping. The contract displays how to register students in a school. The power to register students is given to a special account `registrar`. In real-world scenario, a registrar account could be the school admin where centralization plays or a multisig account in a decentralized world.


```js
  // SPDX-License-Identifier: MIT
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
```

## 9. Nested Mapping

The following contract shows how to nest mapping inside another mapping using the struct `Player` as the final value. Its a simple game I built to show how nested mapping works. 

> Note: Do not use these contracts in production. Even though I introduced a few necessary checks, yet it can contain potential bugs that may cause severe loss if not properly audited.

- Anyone can be a player by calling the `enterGame` function.
- There can be a maximum of 3 players in round after which the game auto locks itself until admin account explicitly calls the `selectWinner` function, the game will be in locked mode. Using an index, teh admin can randomly pick a winner. In production, you'd want to use an unbias means of seleecting a winner such as an getting random value intot your contracts through an oracle.

```js
  // SPDX-License-Identifier: MIT
  pragma solidity 0.8.18;

  contract NestedMapping {
    error GameAlreadyOpened();
    error GameClosed();

    /**Admin address that rolls the dice.
      Often, an oracle is used such as the Chainlink Keeper
    */
    address public admin;

    bool public gameOpen;

    uint public totalPlayerInRound;

    // Player information
    struct Player {
      bool isPlayed;
      uint256 winnings;
      address account;
    }

    // Current round of the game
    uint256 public currentRound;

    // Nested mappings
    // Mapping round to position to players
    mapping(uint256 => mapping(uint => Player)) private players;

    ///@dev Only admin can do certain things
    modifier onlyAdmin() {
      require(msg.sender == admin, "Not authorized");
      _;
    }

    constructor(address _admin) {
      require(_admin != address(0), "Admin cannot be the zero address");
      admin = _admin;
    }

    /**@dev Admin selects winner.
          After winnings are splitted, the game is open again 
    */
    function selectWinner(uint winningPosition) public onlyAdmin {
      require(!gameOpen, "Player in current round not complete");
      Player memory winner = players[currentRound][winningPosition];
      uint balances = address(this).balance;
      uint256 boardShare = balances - ((20 * balances)/100); // Winner takes 80% of total game balances while 20% goes to the boardman
      (bool sent,) = admin.call{value: boardShare}("");
      if(sent) {
        (bool success,) = winner.account.call{value: balances - boardShare}("");
        if(success) gameOpen = true;
      }
    }

    // Player enters current round of game.
    function enterGame() public payable {
      totalPlayerInRound ++;
      if(!gameOpen) revert GameClosed();
      require(msg.value > 5 ether, "Insufficient bet");
      require(!players[currentRound][totalPlayerInRound].isPlayed, "Player already in game");
      players[currentRound][totalPlayerInRound] = Player(true, 0, msg.sender);
      if(totalPlayerInRound == 3) {
        totalPlayerInRound = 0;
        gameOpen = false;
        currentRound ++;
      }
    }
    
  }
```

## 10. Interating through Mapping

Mapping is like a hash table that stores data as key-value pairs where the key can be of any generic or built-in type except for reference types such as `struct` and `arrays`. It is similar to a dictionary. Solidity did not provide a way to loop through mapping but developers has somehow found a ways to achieve this. In the code highlighted below, I show you can loop through a mapping.

- First, we initialise a counter and an mapping in addition to the mapping we intend to iterate over.

- The value in the `counterToAddress` mapping points to the key in the next mapping

- We use the `mappings` to intend to iterate over the mapping:

- The `addToMappings(address target)` can be used to add several items to the `mappings` while we used the `iterateOverMappings` to loop over it.

```js
  // SPDX-License-Identifier: MIT
  pragma solidity 0.8.18;

  contract IterationInMapping {

    uint counter; // you should initialize this to 0 in the constructor

    mapping (uint => address) private counterToAddress;

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
```

### Compilation

Copy the contracts to Remix IDE to compile or run the following command if you're using Hardat.

```bash
npx hardhat compile
```
### Testing deployment

To set up your environment deployment onto Celo Alfajores, Follow **[this guide]()**

## Final Note

Your understanding of mapping in solidity is paramount to coding effectively using the Solidity language and writing optimized smart contracts. A lot of times, mapping is preferred to array in storage because it presents data in hash form compared to array. They can also be expensive where they are deep nested. 

## Next step

Improve your skills in smart contract through consistent learning. Start with each data type in Solidity. Gain deeper undertanding how they work. You're a step away to becoming a whitehat. 


## About the Author​

**Isaac Jesse**, aka Bobelr is a full-stack web3 developer with proficiency in smart contracts development. He was an ambassador and DevAm for several projects like Algorand etc. 

- Say hi to Isaac on **[Twitter](http://twitter.com/Bobman7000)** or **[Linkedin](https://www.linkedin.com/in/isaac-j-a6764a169)**
- Send me **[Email](mailto:bobmatea27@gmail.com)** 
- Check me on **[Github](https://github.com/Bobeu)**

## Further Reading and Resources

- **[Celo developers resources](https://celo.academy/c/tutorials/4)**
- **[Solidity documenation](https://docs.soliditylang.org/en/v0.8.20/)**
