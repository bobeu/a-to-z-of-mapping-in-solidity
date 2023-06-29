// SPDX-License-Identifier: UNLICENSED
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
  function addItem(uint outerKey, uint index, bytes32 newHash) public {
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