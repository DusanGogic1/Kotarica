// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;
pragma experimental ABIEncoderV2;

import "./StringUtils.sol";
import "./ExtendedUsersContract.sol";

contract UsersContract{
    ExtendedUsersContract public extendedContract;

    uint256 public userCount;

    struct UserEssentials{
        uint256 id;
        string username;
        address owner;
        string json;
    }

    struct UserPersonal{
        string firstname;
        string lastname;
        string personal_address;
    }

    struct UserMoreDetails{
        string phone;
        string email;
        string city;
        string zip_code;
        string image;
    }

    struct User{
        UserEssentials essentials;
        UserPersonal personal;
        UserMoreDetails details;
    }

    modifier onlyExtended {
        require(
            msg.sender == address(extendedContract),
            "This method can only be called by an appropriate instance of ExtendedUsersContract."
        );
        _;
    }

    modifier userIndexExists(uint256 index) {
        require(
            index < userCount,
            "No user available at specified index."
        );
        _;
    }

    event UserDeleted(uint256 indexed id);

    mapping(uint256 => User) public users;

//    constructor() public {
//        address aaaa_owner = address(0x69744E137766467C1A4DD4CC4Ca20EaA7bAc4BDa);
//        address bbbb_owner = address(0x5BFbb7F2006ca2046d9747C654506Aa9C3ac4FCf);
////        address aaaa_owner = address(0xaA71f27E896f392b47548E03bD8E6dC28D761e44);
////        address bbbb_owner = address(0x31F9e16d75170A39b0c707878278Fb2d220cA453);
//
//        createUser("aaaa", '{ "id": 0, "username": "aaaa" }', "a", "a", "a", "0600000000", "a@a.aa", "Ada", "1", "QmWU6L23kVXRMNV78AEaWtL7jktRV2c4qJNjRNLhA27Lsh");
//        users[0].essentials.owner = bbbb_owner;
//        createUser("bbbb", '{ "id": 1, "username": "bbbb" }', "b", "b", "b", "0611111111", "b@b.bb", "Ada", "1", "QmWU6L23kVXRMNV78AEaWtL7jktRV2c4qJNjRNLhA27Lsh");
//        users[1].essentials.owner = bbbb_owner;
//
//        users[0].essentials.owner = aaaa_owner;
//    }

    function setExtendedContract() public {
        require(address(extendedContract) == address(0), "Extended contract already set.");
        extendedContract = ExtendedUsersContract(msg.sender);
    }

    function extendedContractExists() public view returns (bool) {
        return address(extendedContract) != address(0);
    }

    // funkcija za vracanje json-a
    function getJson(string memory _username) public view returns(string memory){
        for(uint256 i=0;i<userCount;i++){
            if(StringUtils.equal(users[i].essentials.username, _username) && users[i].essentials.owner == msg.sender)
                return users[i].essentials.json;
        }

        return "";
    }

    // funkcija login
    function attemptLogin(string memory _username, address caller) public view returns(uint256, bool){
        for(uint256 i=0;i<userCount;i++){
            if(StringUtils.equal(users[i].essentials.username, _username) && users[i].essentials.owner == caller)
                return (users[i].essentials.id, true);
        }

        return (0, false);
    }

    // provera da li korisnik vec postoji
    function checkUser(string memory _username, string memory _email, string memory _phone, address _owner) public view returns (uint){
        for(uint256 i=0;i<userCount;i++){
            if(StringUtils.equal(users[i].essentials.username, _username)){
                return 1;
            } else if(StringUtils.equal(users[i].details.email, _email)){
                return 2;
            } else if(StringUtils.equal(users[i].details.phone, _phone)){
                return 3;
            } else if(users[i].essentials.owner == _owner) {
                return 4;
            }
        }

        return 0;
    }

    // dodaje novog korisnika u koliko vec ne postoji korisnik sa istim podacima
    function createUser(string memory _username, string memory _json, string memory _firstname, string memory _lastname, string memory _personal_address, string memory _phone, string memory _email, string memory _city, string memory _zip_code, string memory _image) public{
        uint uniqueUserCheck = checkUser(_username, _email, _phone, msg.sender);
        if (uniqueUserCheck == 1) {
            revert("User with the specified user name already exists.");
        } else if (uniqueUserCheck == 2) {
            revert("User with the specified e-mail already exists.");
        } else if (uniqueUserCheck == 3) {
            revert("User with the specified phone number already exists.");
        } else if (uniqueUserCheck == 4) {
            revert("You already own an account.");
        }

        users[userCount] = User(UserEssentials(userCount ,_username, msg.sender, _json), UserPersonal(_firstname, _lastname, _personal_address), UserMoreDetails(_phone, _email, _city, _zip_code, _image));

        if (extendedContractExists()) {
            extendedContract.cacheUser(users[userCount]);
        }
        emit userCreated(_username, userCount);
        userCount++;
    }

    event userCreated(string user, uint256 userCount);

    // funkcija daj korisnika po indeksu
    function getUser(uint256 index) public view returns(User memory user){
        return users[index];
    }

    // funkcija koja za username vraca id
    function getUserByUsername(string memory _username) public view returns(uint256, bool){
        for(uint256 i=0;i<userCount;i++){
            if(StringUtils.equal(users[i].essentials.username, _username))
                return (users[i].essentials.id, true);
        }

        return (0, false);
    }
    // funkcija koja za username vraca user
    function getInfo(string memory _username) public view returns(User memory , bool){
        for(uint256 i=0;i<userCount;i++){
            if(StringUtils.equal(users[i].essentials.username, _username))
                return (users[i], true);
        }
        return (users[0], false);
    }


    // Privatni setter za users
    function _setUser(uint256 index, User memory user) userIndexExists(index) private {
        users[index] = user;
    }

    // Javni setter za users, dostupan samo instanci ugovora ExtendedUsersContract
    function setUser(uint256 index, User memory user) onlyExtended public {
        _setUser(index, user);
    }

    function deleteUser(uint256 index) public
    {
        if (extendedContractExists()) {
            extendedContract.unCacheUser(users[index]);
        }
        delete users[index];
        emit UserDeleted(index);
    }

}