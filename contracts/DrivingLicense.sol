// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.14;

contract DrivingLicense{

    address private admin;

    struct License{
        string name;
        int256 id;
        uint timestamp;
    }

    mapping(int256 => License) public licenses;
    int256[] public ids;
    
    constructor () {

        admin = msg.sender;
    }

    modifier isAdmin{
        require(msg.sender == admin,'You should be an admin');
        _;
    }

    event LicenseCreated(int256 id);


    function containes(int256 id) private view returns(bool){
     bool doesListContainElement = false;
        for (uint i=0; i < ids.length; i++) {
            if (id == ids[i]) {
                doesListContainElement = true;
             }
             } 
              return doesListContainElement;
         
    }
    function createLicense(string memory name,int256 id) public isAdmin {
        require(containes(id) == false ,'There is already a user');
        
        ids.push(id);
        licenses[id] = License({
            name: name,
            id: id,
            timestamp: block.timestamp
        });
        emit LicenseCreated(id);
    }

    function getLicensesSize() external view returns(uint256){
        return ids.length;
    }


}