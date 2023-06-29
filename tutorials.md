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

