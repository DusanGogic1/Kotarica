# kotarica

Decentralizovana online prodavnica domaćih proizvoda

# Konfigurisanje

Pre nego što pokrenete projekat potrebno je instalirati najnoviju verziju [Node.js](https://nodejs.org/en/),
[IPFS Desktop](https://github.com/ipfs/ipfs-desktop), [Flutter](https://flutter.dev/docs/get-started/install),
[Truffle](https://www.trufflesuite.com/) i [Ganache](https://www.trufflesuite.com/ganache)

Kada instalirate sve neophodne programe za rad aplikacije pokrenite sledeće naredbe

```console
    npm install -g truffle
    
    npm install os
    npm install express
    npm install body-parser
    npm install ipfs-http-client
    npm install express-fileupload
    npm install ipfs-api
    
    ipfs daemon
```

i nakon toga za pokretanje servera udjite u fajl Back-end/node i ukucajte komandu

```console
    node index.js
```

Pre nego što pokrenete Flutter aplikaciju potrebno je u fajlovima OneTrust\App\Front-end\kotarica\truffle-config.js
i OneTrust\App\Front-end\kotarica\lib\constants\networks.dart konfigurisati konstantne IP adrese kako bi projekat ispravno radio
Nakon toga u folderu OneTrust\App\Front-end\kotarica ukucajte 
```console
    truffle migrate 
```
kako bi se svi pametni ugovori prebacili na blockchain mrežu i aplikacija je nakon toga spremna za rad