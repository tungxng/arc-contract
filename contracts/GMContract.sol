// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/**
 * @title GMContract
 * @dev Simple contract to send GM messages
 */
contract GMContract {
    event GMSent(address indexed from, address indexed to, string message, uint256 timestamp);

    struct GMMessage {
        address from;
        address to;
        string message;
        uint256 timestamp;
    }

    mapping(address => GMMessage[]) public gmHistory;
    mapping(address => uint256) public gmCount;
    
    // Mappings for received messages
    mapping(address => GMMessage[]) public receivedGMHistory;
    mapping(address => uint256) public receivedGMCount;

    /**
     * @dev Send a GM message
     * @param to The address to send GM to
     * @param message The GM message
     */
    function sendGM(address to, string memory message) public {
        require(to != address(0), "Cannot send to zero address");
        require(bytes(message).length > 0, "Message cannot be empty");

        GMMessage memory gm = GMMessage({
            from: msg.sender,
            to: to,
            message: message,
            timestamp: block.timestamp
        });

        // Store in sender's history
        gmHistory[msg.sender].push(gm);
        gmCount[msg.sender]++;
        
        // Store in receiver's history
        receivedGMHistory[to].push(gm);
        receivedGMCount[to]++;

        emit GMSent(msg.sender, to, message, block.timestamp);
    }

    /**
     * @dev Send a simple GM (default message)
     * @param to The address to send GM to
     */
    function sendSimpleGM(address to) public {
        sendGM(to, "GM!");
    }

    /**
     * @dev Get GM count for an address
     * @param user The address to check
     * @return The number of GMs sent by this address
     */
    function getGMCount(address user) public view returns (uint256) {
        return gmCount[user];
    }

    /**
     * @dev Get GM history for an address (messages sent by this address)
     * @param user The address to get history for
     * @return An array of GMMessage structs
     */
    function getGMHistory(address user) public view returns (GMMessage[] memory) {
        return gmHistory[user];
    }

    /**
     * @dev Get received GM count for an address
     * @param user The address to check
     * @return The number of GMs received by this address
     */
    function getReceivedGMCount(address user) public view returns (uint256) {
        return receivedGMCount[user];
    }

    /**
     * @dev Get received GM history for an address (messages received by this address)
     * @param user The address to get received history for
     * @return An array of GMMessage structs
     */
    function getReceivedGMHistory(address user) public view returns (GMMessage[] memory) {
        return receivedGMHistory[user];
    }
}

