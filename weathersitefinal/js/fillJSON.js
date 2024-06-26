window.onload = fillJSON;

function fillJSON(){
    //var header = document.querySelector('header');
    var section = document.querySelector('main .town');
    var requestURL = 'js/towndata.json';
    var request = new XMLHttpRequest();
    request.open('GET', requestURL);
    request.responseType = 'json';
    request.send();
    request.onload = function() {
        var localTowns = request.response;
        //populateHeader(localTowns);
        showTowns(localTowns);
    }
    /*function populateHeader(jsonObj) {
        var myH1 = document.createElement('h1');
        myH1.textContent = jsonObj['squadName'];
        header.appendChild(myH1);

        var myPara = document.createElement('p');
        myPara.textContent = 'Hometown: ' + jsonObj['homeTown'] + ' // Formed: ' + jsonObj['formed'];
        header.appendChild(myPara);
    }*/
    function showTowns(jsonObj) {
        var towns = jsonObj['towns'];

        for (var i = 0; i < towns.length; i++) {
            var myArticle = document.createElement('article');
            var myH2 = document.createElement('h2');
            var myH3 = document.createElement('h3');
            var myPara2 = document.createElement('p');
            var myPara3 = document.createElement('p');
            var myPara4 = document.createElement('p');
            var myPara5 = document.createElement('p');
            var myList = document.createElement('ul');
            var myIMG = document.createElement('img');

            if (towns[i].name == "Franklin") {
                myIMG.setAttribute('src', 'images/honolulu.jpg');
                myIMG.setAttribute('alt', 'Franklin Image');
            } else if (towns[i].name == "Fish Haven") {
                myIMG.setAttribute('src', 'images/wahiawa.jpg');
                myIMG.setAttribute('alt', 'Fish Haven');
            } else if (towns[i].name == "Greenville") {
                myIMG.setAttribute('src', 'images/lanakila.jpg');
                myIMG.setAttribute('alt', 'Greenville');
            } else if (towns[i].name == "Placerton") {
                myIMG.setAttribute('src', 'images/kailua.jpg');
                myIMG.setAttribute('alt', 'Placerton');
            } else if (towns[i].name == "Preston") {
                myIMG.setAttribute('src', 'images/ewabeach.jpg');
                myIMG.setAttribute('alt', 'Preston');
            } else if (towns[i].name == "Soda Springs") {
                myIMG.setAttribute('src', 'images/kahului.jpg');
                myIMG.setAttribute('alt', 'Soda Springs');
            } else {
                myIMG.setAttribute('src', 'images/waianae.jpg');
                myIMG.setAttribute('alt', 'Springfield');
            }

            myH2.textContent = towns[i].name;
            myH3.textContent = '"' + towns[i].motto + '"';
            myPara2.textContent = 'Year Founded: ' + towns[i].yearFounded;
            myPara3.textContent = 'Current Population: ' + towns[i].currentPopulation;
            myPara4.textContent = 'Average Rainfall: ' + towns[i].averageRainfall;
            myPara5.textContent = 'Events:';

            var localEvents = towns[i].events;
            for (var j = 0; j < localEvents.length; j++) {
                var listItem = document.createElement('li');
                listItem.textContent = localEvents[j];
                myList.appendChild(listItem);
            }

            myArticle.appendChild(myH2);
            myArticle.appendChild(myH3);
            myArticle.appendChild(myPara2);
            myArticle.appendChild(myPara3);
            myArticle.appendChild(myPara4);
            myArticle.appendChild(myPara5);
            myArticle.appendChild(myList);
            myArticle.appendChild(myIMG);

            section.appendChild(myArticle);
        }
    }
}