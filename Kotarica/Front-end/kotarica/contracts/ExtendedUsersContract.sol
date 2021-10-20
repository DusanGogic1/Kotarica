pragma solidity >=0.4.22 <0.9.0;
pragma experimental ABIEncoderV2;

import "./StringUtils.sol";
import "./UsersContract.sol";

contract ExtendedUsersContract {
    struct UserExists {
        uint256 index;
        bool exists;
    }

    modifier onlyBaseContract {
        require(
            msg.sender == address(usersContract),
            "This method can only be called by the appropriate UsersContract instance."
        );
        _;
    }

    UsersContract public usersContract;

    // Unique user identifiers/properties
    int constant private _NUM_PROPERTIES = 4;
    int constant private _PROPERTY_USERNAME     = 0;
    int constant private _PROPERTY_EMAIL        = 1;
    int constant private _PROPERTY_PHONE_NUMBER = 2;
    int constant private _PROPERTY_OWNER        = 3;

    mapping(int => bool) private stringProperty;

    mapping(string => UserExists) private byUserName;
    mapping(string => UserExists) private byEmail;
    mapping(string => UserExists) private byPhoneNumber;
    mapping(address => UserExists) private byOwner;

    event UserInfoChanged(uint256 indexed id);
    event UserOwnerChanged(uint256 indexed id, address indexed owner);

    constructor(address _usersContractAddress) public {
        usersContract = UsersContract(_usersContractAddress);
        usersContract.setExtendedContract();

        _initProperties();
    }

    function _initProperties() private {
        stringProperty[_PROPERTY_USERNAME] = true;
        stringProperty[_PROPERTY_EMAIL] = true;
        stringProperty[_PROPERTY_PHONE_NUMBER] = true;
    }

    function _cacheUser(UsersContract.User memory user) private {
        byUserName[user.essentials.username] = UserExists(user.essentials.id, true);
        byEmail[user.details.email] = UserExists(user.essentials.id, true);
        byPhoneNumber[user.details.phone] = UserExists(user.essentials.id, true);
        byOwner[user.essentials.owner] = UserExists(user.essentials.id, true);
    }

    function cacheUser(UsersContract.User memory user) onlyBaseContract public {
        _cacheUser(user);
    }

    function unCacheUser(UsersContract.User memory user) onlyBaseContract public {
        delete byUserName[user.essentials.username];
        delete byEmail[user.details.email];
        delete byPhoneNumber[user.details.phone];
        delete byOwner[user.essentials.owner];
    }

    function _getUser(uint256 index) private view returns (UsersContract.User memory) {
        UsersContract.UserEssentials memory essentials;
        UsersContract.UserPersonal memory personal;
        UsersContract.UserMoreDetails memory moreDetails;
        (essentials, personal, moreDetails) = usersContract.users(index);

        return UsersContract.User(essentials, personal, moreDetails);
    }

    function _getUserByAuth(string memory userName, address caller) private returns (UsersContract.User memory) {
        UserExists memory ex = byUserName[userName];
        if (ex.exists) {
            UsersContract.User memory user = _getUser(ex.index);
            require(user.essentials.owner == caller, "User authentication failed.");
            return user;
        }

        (uint256 index, bool success) = usersContract.attemptLogin(userName, caller);
        require(success, "User authentication failed.");

        UsersContract.User memory userFromBase = _getUser(index);
        _cacheUser(userFromBase);
        return userFromBase;
    }

    function _getUserIndexByStringProperty(int propertyId, string memory value) private returns (uint256 index, bool exists) {
        require (0 <= propertyId && propertyId < _NUM_PROPERTIES, "Invalid property id.");
        require (stringProperty[propertyId], "Property is not of string type.");

        UserExists memory ex;
        // Read from cache
        if (propertyId == _PROPERTY_USERNAME)           ex = byUserName[value];
        else if (propertyId == _PROPERTY_EMAIL)         ex = byEmail[value];
        else if (propertyId == _PROPERTY_PHONE_NUMBER)  ex = byPhoneNumber[value];

        if (ex.exists) {
            return (ex.index, true);
        }

        for(uint256 i = 0; i < usersContract.userCount(); i++) {
            UsersContract.User memory user = _getUser(i);

            string memory compareTo;
            if (propertyId == _PROPERTY_USERNAME)           compareTo = user.essentials.username;
            else if (propertyId == _PROPERTY_EMAIL)         compareTo = user.details.email;
            else if (propertyId == _PROPERTY_PHONE_NUMBER)  compareTo = user.details.phone;

            if(StringUtils.equal(compareTo, value)) {
                _cacheUser(user);
                return (i, true);
            }
        }

        return (0, false);
    }

    function getUserIndexByUserName(string memory userName) public returns (uint256 index, bool exists) {
        return _getUserIndexByStringProperty(_PROPERTY_USERNAME, userName);
    }

    function getUserIndexByEmail(string memory email) public returns (uint256 index, bool exists) {
        return _getUserIndexByStringProperty(_PROPERTY_EMAIL, email);
    }

    function getUserIndexByPhoneNumber(string memory phoneNumber) public returns (uint256 index, bool exists) {
        return _getUserIndexByStringProperty(_PROPERTY_PHONE_NUMBER, phoneNumber);
    }

    function getUserIndexByOwner(address owner) public returns (uint256 index, bool exists) {
        UserExists memory ex = byOwner[owner];
        if (ex.exists) {
            return (ex.index, true);
        }

        for(uint256 i = 0; i < usersContract.userCount(); i++) {
            UsersContract.User memory user = _getUser(i);

            if (user.essentials.owner == owner) {
                _cacheUser(user);
                return (i, true);
            }
        }

        return (0, false);
    }

    function changeUserInfo(
        string memory currentUserName,
        string memory firstName, string memory lastName,
        string memory email, string memory phoneNumber,
        string memory personalAddress, string memory city, string memory zipCode,
        string memory ipfsImageHash
    ) public {
        UsersContract.User memory user = _getUserByAuth(currentUserName, msg.sender);

        if (!StringUtils.equal(user.details.email, email)) {
            (, bool exists) = getUserIndexByEmail(email);
            require(!exists, "User with the specified email already exists.");

            delete byEmail[user.details.email];
            byEmail[email] = UserExists(user.essentials.id, true);
        }

        if (!StringUtils.equal(user.details.phone, phoneNumber)) {
            (, bool exists) = getUserIndexByPhoneNumber(phoneNumber);
            require(!exists, "User with the specified phone number already exists.");

            delete byPhoneNumber[user.details.phone];
            byPhoneNumber[phoneNumber] = UserExists(user.essentials.id, true);
        }

        user.personal.firstname = firstName;
        user.personal.lastname = lastName;
        user.personal.personal_address = personalAddress;
        user.details.email = email;
        user.details.phone = phoneNumber;
        user.details.city = city;
        user.details.zip_code = zipCode;
        user.details.image = ipfsImageHash;

        usersContract.setUser(user.essentials.id, user);
        emit UserInfoChanged(user.essentials.id);
    }

    function changeUserOwner(string memory currentUserName, address newOwner) public {
        UsersContract.User memory user = _getUserByAuth(currentUserName, msg.sender);
        if (user.essentials.owner == newOwner) {
            return;
        }

        (, bool exists) = getUserIndexByOwner(newOwner);
        require(!exists, "New owner already owns an account.");

        user.essentials.owner = newOwner;

        delete byOwner[msg.sender];
        byOwner[newOwner] = UserExists(user.essentials.id, true);

        usersContract.setUser(user.essentials.id, user);
        emit UserOwnerChanged(user.essentials.id, user.essentials.owner);
    }

    function getUser(uint256 id) public view returns(UsersContract.User memory) {
        return usersContract.getUser(id);
    }
}
