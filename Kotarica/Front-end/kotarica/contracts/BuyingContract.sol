pragma solidity >=0.4.22 <0.9.0;
pragma experimental ABIEncoderV2;

import './PostsContract.sol';
import './ExtendedUsersContract.sol';

contract BuyingContract {

    uint256 public pendingCount = 0;
    mapping(uint256 => Purchase) public  pending;

    uint256 public confirmedCount = 0;
    mapping(uint256 => Purchase) public confirmed;

    uint256 public canceledCount = 0;
    mapping(uint256 => Purchase) public canceled;

    struct Purchase{
        uint256 buyer;
        uint256 seller;
        uint256 productId;
        uint256 amount;

        string unit;
        string adresa;
        string phoneNumber;
        string paidIn;
    }


    event purchase(uint256 buyer, uint256 seller, uint256 productId, uint256 amount, string adresa, string phoneNumber, string tip);
    // tip: pending, confirmed, cancelled

    function addToPending(uint256 buyer, uint256 seller, uint256 productId, uint256 amount, string memory adresa, string memory phoneNumber, string memory unit, string memory paidIn) public
    {
        Purchase memory p;
        p.buyer = buyer;
        p.seller = seller;
        p.productId = productId;
        p.amount = amount;
        p.adresa = adresa;
        p.phoneNumber = phoneNumber;
        p.unit = unit;
        p.paidIn = paidIn;


        pending[pendingCount] = p;
        pendingCount+=1;

        emit purchase(buyer, seller, productId, amount, adresa, phoneNumber, "pending");
    }

    function addToConfirmed(uint256 id) public
    {
        Purchase memory p;
        p.buyer = pending[id].buyer;
        p.seller = pending[id].seller;
        p.productId = pending[id].productId;
        p.amount = pending[id].amount;
        p.adresa = pending[id].adresa;
        p.phoneNumber = pending[id].phoneNumber;
        p.unit = pending[id].unit;
        p.paidIn = pending[id].paidIn;

        confirmed[confirmedCount] = p;
        confirmedCount++;

        delete pending[id];
        emit purchase(p.buyer, p.seller, p.productId, p.amount, p.adresa, p.phoneNumber, "confirmed");
    }

    function addToCanceled(uint256 id) public
    {
        Purchase memory p;
        p.buyer = pending[id].buyer;
        p.seller = pending[id].seller;
        p.productId = pending[id].productId;
        p.amount = pending[id].amount;
        p.adresa = pending[id].adresa;
        p.phoneNumber = pending[id].phoneNumber;
        p.unit = pending[id].unit;
        p.paidIn = pending[id].paidIn;

        canceled[canceledCount] = p;
        canceledCount++;

        delete pending[id];
        emit purchase(p.buyer, p.seller, p.productId, p.amount, p.adresa, p.phoneNumber, "cancelled");
    }
}