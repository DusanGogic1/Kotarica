// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;
pragma experimental ABIEncoderV2;


contract ProductMarksContract{
    //storage
    uint256 public MarksCount = 0; //broj ocena
    mapping(uint256 => Ocena) public marks; //ocene

    /*struct Ocena{
        uint256 brojZvezda; //ocena
        string username; //ko je dao ocenu
    }*/
    struct Ocena{
        uint256 reviewer; //ko ocenjuje
        uint256 id; //id proizovda
        uint256 ocena;
    }

    event PostRated(uint256 indexed id, uint256 indexed reviewerId, uint256 rating);

    //dodavanje ocene za proizvod
    function addMarks(uint256 _ocena, uint256 _id, uint256 _reviewer) public
    {
        Ocena memory ocena;
        ocena.id = _id;
        ocena.ocena = _ocena;
        ocena.reviewer = _reviewer;
        marks[MarksCount] = ocena;
        MarksCount++;
        emit PostRated(_id, _reviewer, _ocena);
    }
    /* provera da li je korsinik vec ocenio proizvod */
    function toRate(uint256 _username, uint256 _id) public view returns(bool)
    {
        for(uint256 i=0; i<MarksCount; i++) //kroz sve ocene
        {
            if(marks[i].reviewer == _username && marks[i].id == _id) return false;
        }
        return true;
    }

}
