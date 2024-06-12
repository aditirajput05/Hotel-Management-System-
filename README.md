
# Hotel Management System
This Solidity program provides simple functionality for managing hotel rooms and guests on the blockchain.

## Description
This program consists of simple functions and variables which help in mapping data, creating rooms, booking rooms, checking out of rooms, and getting the current guest of a room. It includes checks to prevent invalid room bookings and checkouts.

## Getting Started
This program contains straightforward functions and variables designed for mapping data, creating rooms, booking rooms, checking out of rooms, and getting the current guest of a room.

## Executing program
To run this program, you can utilize Remix, an online Solidity IDE. Begin by navigating to the Remix website at Remix Ethereum.

Once you're on the Remix website, initiate a new file by selecting the "+" icon in the left-hand sidebar. Save the file with a.sol extension (for instance, HotelManagementSystem.sol). Then, copy and paste the provided code into the file.

solidity Copy code
```
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

contract HotelManagementSystem {
    struct Room {
        uint256 roomId;
        string roomType;
        uint256 capacity;
        bool isAvailable;
        address currentGuest;
    }

    struct Guest {
        address guestAddress;
        string guestName;
        uint256 roomId;
    }

    mapping(uint256 => Room) public rooms;
    mapping(address => Guest) public guests;
    uint256 public roomCount;

    event RoomCreated(uint256 roomId, string roomType, uint256 capacity);
    event RoomBooked(uint256 roomId, address guest);
    event RoomCheckedOut(uint256 roomId, address guest);

    // Create a new room
    function createRoom(string calldata roomType, uint256 capacity) external {
        require(bytes(roomType).length > 0, "Room type cannot be empty");
        require(capacity > 0, "Capacity must be greater than 0");

        roomCount++;
        rooms[roomCount] = Room({
            roomId: roomCount,
            roomType: roomType,
            capacity: capacity,
            isAvailable: true,
            currentGuest: address(0)
        });

        emit RoomCreated(roomCount, roomType, capacity);
    }

    // Book a room
    function bookRoom(uint256 roomId) external {
        require(roomId > 0 && roomId <= roomCount, "Room does not exist");
        require(rooms[roomId].isAvailable, "Room is not available");
        require(rooms[roomId].currentGuest == address(0), "Room is already booked");

        rooms[roomId].isAvailable = false;
        rooms[roomId].currentGuest = msg.sender;

        guests[msg.sender] = Guest({
            guestAddress: msg.sender,
            guestName: "",
            roomId: roomId
        });

        emit RoomBooked(roomId, msg.sender);

        // Ensure the room is booked correctly
        assert(!rooms[roomId].isAvailable);
    }

    // Check out of a room
    function checkOut(uint256 roomId) external {
        require(roomId > 0 && roomId <= roomCount, "Room does not exist");
        require(!rooms[roomId].isAvailable, "Room is not booked");
        require(rooms[roomId].currentGuest == msg.sender, "Only the current guest can check out");

        rooms[roomId].isAvailable = true;
        rooms[roomId].currentGuest = address(0);

        delete guests[msg.sender];

        emit RoomCheckedOut(roomId, msg.sender);

        // Ensure the room is available again
        assert(rooms[roomId].isAvailable);
    }

    // Get the current guest of a room
    function getCurrentGuest(uint256 roomId) external view returns (address) {
        require(roomId > 0 && roomId <= roomCount, "Room does not exist");
        return rooms[roomId].currentGuest;
    }

    // Example function using revert() statement
    function exampleRevert() external pure {
        // Revert with a custom error message
        revert("Transaction Reverted");
    }

    fallback() external payable {
        revert("Direct payments not allowed");
    }

    receive() external payable {
        revert("Direct payments not allowed");
    }
}
```
To compile the code, click on the "Solidity Compiler" tab in the left-hand sidebar. Make sure the "Compiler" option is set to "0.8.7" (or another compatible version), and then click on the "Compile HotelManagementSystem.sol" (or whatever the file name is) button.

Once the code is compiled, you can deploy the contract by clicking on the "Deploy & Run Transactions" tab in the left-hand sidebar. Select the "HotelManagementSystem" contract from the dropdown menu, and then click on the "Deploy" button.

After deployment, you can interact with the contract using the default addresses provided. You can create new rooms, book rooms, check out of rooms, and get the current guest of a room.

## Authors

Aditi Rajput
[@Chandigarh University](https://www.linkedin.com/in/aditi-rajput-b9360720b/)


## License
This project is licensed under the MIT License - see the LICENSE.md file for details
