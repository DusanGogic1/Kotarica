pragma solidity >=0.4.22 <0.9.0;
pragma experimental ABIEncoderV2;

import "./UsersContract.sol";

contract PostsContract {
    UsersContract public usersContract;

    uint256 public postCount;

    struct AboutOwner{
        uint256 ownerId;
        string image;
    }

    struct BasicInfo{
        uint256 id;
        string title;
        string category_subcategory; // string splitted with '-'
        string city;
        string[] images;

        bool exists;
    }

    struct OtherInfo{
        string about;
        uint256 priceRSD;
        uint256 priceInWei;
        string measuringUnit;
        string tip;
        string date;
    }

    struct Post{
        AboutOwner ownerInfo;
        BasicInfo basic;
        OtherInfo other;
    }

    modifier postExists(uint256 postId) {
        requirePostExists(postId);
        _;
    }

    function requirePostExists(uint256 postId) public view {
        require(
            postId < postCount && posts[postId].basic.exists,
            "Post with the specified id doesn't exist."
        );
    }

    mapping(uint256 => Post) public posts;

    event postCreated(string title, uint256 postCount);
    event PostChanged(uint256 indexed id);
    event PostDeleted(uint256 indexed id);

    constructor(address usersContractAddress) public {
        usersContract = UsersContract(usersContractAddress);
    }

    function createPost(uint256 _ownerId, string memory _title, string memory _category_subcategory,
        string memory _about, uint256 _priceRSD, uint256 _priceInWei, string[] memory _images, string memory _measuringUnit, string memory _tip, string memory _date) public {
        UsersContract.User memory user = usersContract.getUser(_ownerId);

        posts[postCount] = Post(AboutOwner(_ownerId, user.details.image), BasicInfo(postCount, _title, _category_subcategory, user.details.city, _images, true), OtherInfo(_about, _priceRSD, _priceInWei, _measuringUnit, _tip, _date));

        emit postCreated(_title, postCount);
        postCount++;

    }

    function updatePost(uint256 postId, string memory _title, string memory _category_subcategory,
        string memory _about, uint256 _priceRSD, uint256 _priceInWei, string[] memory _images, string memory _measuringUnit, string memory _tip, string memory _date) public postExists(postId) {
        UsersContract.User memory user = usersContract.getUser(posts[postId].ownerInfo.ownerId);

        posts[postId].ownerInfo.image = user.details.image;
        posts[postId].basic = BasicInfo(postId, _title, _category_subcategory, user.details.city, _images, true);
        posts[postId].other = OtherInfo(_about, _priceRSD, _priceInWei, _measuringUnit, _tip, _date);

        emit PostChanged(postId);
    }

    function deletePost(uint postId) public postExists(postId) {
        //delete posts[postId];
        posts[postId].basic.exists = false;
        emit PostDeleted(postId);
    }

    // vraca proizvod na osnovu ID
    function getProductById(uint id) public view returns(Post memory proizvod, bool vrati) {
        for(uint256 i=0;i<postCount;i++)
        {
            if(posts[i].basic.id == id && posts[i].basic.exists == true)
            {
                return (posts[i], true);
            }
        }
        return (posts[0], false); // mora da se vrati proizvod ali proverava se samo da l je true ili false
    }
}
