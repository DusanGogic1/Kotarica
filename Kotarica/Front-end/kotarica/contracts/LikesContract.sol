// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;
pragma experimental ABIEncoderV2;


contract LikesContract{

    //storage
    uint256 public likesAmount = 0; //broj Ocena
    uint256 private indexUser; //indeks korisnika
    mapping(uint256 => LD) public likes; //lajkovi
    uint256 private flag;
    uint256 private flag2;

    //KORISNIK KOJI OCENJUJE
    struct LD{
        uint256 liker; //ocenjivac
        uint256 liked; //ocenjen
        bool isLIked;  //da li je lajk ili dislajk
        //pri ocenjivanju odgovora na tri pitanja
        string odgovor1;
        string odgovor2;
        string odgovor3;
    }
    //KORISNIK KOJI SE OCENJUJE
    /*struct Like{
        string username; //username
        uint256 nlikes; //broj lajkova
        uint256 ndislikes; //broj dislajkova
        LD[] listaOcena;  //lista ocena koji su ga vec ocenili
    }*/
    //Ocenili ste ---> TODO


    // Eventovi za notifikacije
    event AddedLike(uint256 by, uint256 who, string message1, string message2, string message3);
    event AddedDislike(uint256 by, uint256 who, string message1, string message2, string message3);

    /* ------------ Lajkovanje --------- */
    /* parametri (korisnik koji ocenjuje, korisnik koji se ocenjuje, odgovor1,odgovor2,odgovor3) */
    function addLike(uint256 _username, uint256 _username2, string memory _mess1, string memory _mess2, string memory _mess3) public {

        LD memory like;

        like.liker = _username;
        like.liked = _username2;
        like.odgovor1 = _mess1;
        like.odgovor2 = _mess2;
        like.odgovor3 = _mess3;

        like.isLIked = true;

        likes[likesAmount] = like;
        likesAmount+=1;
        emit AddedLike(_username, _username2, _mess1, _mess2, _mess3);
    }

    /* ------ DISLAJKOVANJE ---------*/
    /* parametri (korisnik koji ocenjuje, korisnik koji se ocenjuje, odgovor1,odgovor2,odgovor3) */
    function addDislike(uint256 _username, uint256 _username2, string memory _mess1, string memory _mess2, string memory _mess3) public {

        LD memory like;

        like.liker = _username;
        like.liked = _username2;
        like.odgovor1 = _mess1;
        like.odgovor2 = _mess2;
        like.odgovor3 = _mess3;

        like.isLIked = false;

        likes[likesAmount] = like;
        likesAmount+=1;
        emit AddedDislike(_username, _username2, _mess1, _mess2, _mess3);
    }


    /* ------ Vraca broj lajkova  ---------- */
    function getNumLikes(string memory _username) public view returns(uint256) {
        uint256 numLikes = 0;
        for(uint256 i=0; i<likesAmount; i++) {
            if(keccak256(abi.encodePacked(likes[i].liked)) == keccak256(abi.encodePacked(_username)) && likes[i].isLIked == true)
            {
                numLikes++;
            }
        }
        return numLikes;
    }

    /* ------ Vraca broj dislajkova  ---------- */
    function getNumDislikes(string memory _username) public view returns(uint256) {
        uint256 numDislikes = 0;
        for(uint256 i=0; i<likesAmount; i++) {
            if(keccak256(abi.encodePacked(likes[i].liked)) == keccak256(abi.encodePacked(_username)) && likes[i].isLIked == false)
            {
                numDislikes++;
            }
        }
        return numDislikes;
    }
}