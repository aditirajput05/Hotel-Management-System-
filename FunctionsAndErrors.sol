For this project, write a smart contract that implements the require(), assert() and revert() statements.


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
