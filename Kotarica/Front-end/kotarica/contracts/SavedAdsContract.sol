// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;
pragma experimental ABIEncoderV2;


contract SavedAdsContract{

    uint256 public countSavedAdverts = 0; // broj sacuvanih oglasa
    mapping(uint256 => SavedAdverts) public savedAdverts; // oglasi

    struct SavedAdverts{
        uint id;
        uint advert_id;
        bool visible;
    }

    /* Cuvanje oglasa */
    /* Dodaj indeks oglasa i username korisnika u koliko oglas ne postoji */
    /* U koliko oglas postoji revertuj visibility */
    function save(uint _id, uint _advert_id) public {
        uint256 index;
        bool contains;

        (contains, index) = getIndex(_id, _advert_id);
        if(contains == true){
            if(savedAdverts[index].visible == false)
                savedAdverts[index].visible = true;
            else
                savedAdverts[index].visible = false;
        } else {
            savedAdverts[countSavedAdverts] = SavedAdverts(_id,_advert_id, true);
            countSavedAdverts++;
        }
    }

    /* Vraca id oglasa ako ga pronadje */
    function getIndex(uint _id, uint _advert_id) public view returns(bool, uint256) {
        for(uint i=0;i<countSavedAdverts;i++) {
            if(savedAdverts[i].id == _id && savedAdverts[i].advert_id == _advert_id)
                return (true, i);
        }
        return(false, 0); // bitan je prvi parametar
    }

    /* Provera da li je oglas sacuvan */
    function check(uint _id, uint _advert_id) public view returns (bool){
        for(uint i=0;i<countSavedAdverts;i++) {
            if(savedAdverts[i].id == _id && savedAdverts[i].advert_id == _advert_id && savedAdverts[i].visible == true)
                return true;
        }
        return false;
    }
}