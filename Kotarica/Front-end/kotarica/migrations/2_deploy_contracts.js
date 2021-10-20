const StringUtils = artifacts.require("StringUtils");
const UsersContract = artifacts.require("UsersContract");
const ExtendedUsersContract = artifacts.require("ExtendedUsersContract");
const PostsContract = artifacts.require("PostsContract");
const LikesContract = artifacts.require("LikesContract");
const ProductMarksContract = artifacts.require("ProductMarksContract");
const BuyingContract = artifacts.require("BuyingContract");
const SavedAdsContract = artifacts.require("SavedAdsContract");

module.exports = async function (deployer) {
  await deployer.deploy(StringUtils);
  deployer.link(StringUtils, [UsersContract, ExtendedUsersContract]);

  await deployer.deploy(UsersContract);
  await deployer.deploy(ExtendedUsersContract, UsersContract.address);

  await deployer.deploy(PostsContract, UsersContract.address);
  await deployer.deploy(BuyingContract, PostsContract.address, ExtendedUsersContract.address);

  await deployer.deploy(LikesContract);
  await deployer.deploy(ProductMarksContract);
  await deployer.deploy(SavedAdsContract);
};
