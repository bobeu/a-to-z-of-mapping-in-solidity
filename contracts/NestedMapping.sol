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