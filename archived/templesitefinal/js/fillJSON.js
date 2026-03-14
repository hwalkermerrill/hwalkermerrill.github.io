window.onload = fillJSON;

function fillJSON(){
    //var header = document.querySelector('header');
    var section = document.querySelector('main .temples');
    var requestURL = 'js/templedata.json';
    var request = new XMLHttpRequest();
    request.open('GET', requestURL);
    request.responseType = 'json';
    request.send();
    request.onload = function() {
        var localTemples = request.response;
        //populateHeader(localTemples);
        showTemples(localTemples);
    }
    function showTemples(jsonObj) {
        var temples = jsonObj['temples'];

        for (var i = 0; i < temples.length; i++) {
            var myArticle = document.createElement('article');
            var myH2 = document.createElement('h2');
            var myH3 = document.createElement('h3');
            var myPara2 = document.createElement('p');
            var myPara3 = document.createElement('p');
            var myPara4 = document.createElement('p');
            var myPara5 = document.createElement('p');
            var myList1 = document.createElement('ul');
            var myPara6 = document.createElement('p');
            var myList2 = document.createElement('ul');
            var myPara7 = document.createElement('p');
            var myList3 = document.createElement('ul');
            var myPara8 = document.createElement('p');
            var myList4 = document.createElement('ul');
            var myPara9 = document.createElement('p');
            var myList5 = document.createElement('ul');
            var myIMG = document.createElement('img');

            if (temples[i].name == "Indianapolis Indiana Temple") {
                myIMG.setAttribute('src', 'images/indianapolis-indiana-720w.jpg');
                myIMG.setAttribute('alt', 'Indianapolis');
            } else if (temples[i].name == "Laie Hawaii Temple") {
                myIMG.setAttribute('src', 'images/laie-hawaii-720w.jpg');
                myIMG.setAttribute('alt', 'Hawaii');
            } else if (temples[i].name == "Louisville Kentucky Temple") {
                myIMG.setAttribute('src', 'images/louisville-kentucky-720w.jpg');
                myIMG.setAttribute('alt', 'Kentucky');
            } else if (temples[i].name == "Nauvoo Illinois Temple") {
                myIMG.setAttribute('src', 'images/nauvoo-illinois-720w.jpg');
                myIMG.setAttribute('alt', 'Nauvoo');
            } else if (temples[i].name == "Redlands California Temple") {
                myIMG.setAttribute('src', 'images/redlands-california-720w.jpg');
                myIMG.setAttribute('alt', 'Redlands');
            } else {
                myIMG.setAttribute('src', 'images/winter-quarters-nebraska-720w.jpg');
                myIMG.setAttribute('alt', 'Winter Quarters');
            }

            myH2.textContent = temples[i].name;
            myH3.textContent = 'Est. ' + temples[i].history[2];
            myPara2.textContent = 'Address: ' + temples[i].address;
            myPara3.textContent = 'Telephone: ' + temples[i].telephone;
            myPara4.textContent = 'Email: ' + temples[i].email;
            myPara5.textContent = 'Services: ';
            myPara6.textContent = 'Ordinances: ';
            myPara7.textContent = 'Endowment Schedule: ';
            myPara8.textContent = 'Closure Schedule: ';
            myPara9.textContent = 'History: ';

            var services = temples[i].services;
            for (var j = 0; j < services.length; j++) {
                var listItem = document.createElement('li');
                listItem.textContent = services[j];
                myList1.appendChild(listItem);
            }

            var ordSched = temples[i].ordSched;
            for (var j = 0; j < ordSched.length; j++) {
                var listItem = document.createElement('li');
                listItem.textContent = ordSched[j];
                myList2.appendChild(listItem);
            }

            var sesSched = temples[i].sesSched;
            for (var j = 0; j < sesSched.length; j++) {
                var listItem = document.createElement('li');
                listItem.textContent = sesSched[j];
                myList3.appendChild(listItem);
            }

            var closureSchedule = temples[i].closureSchedule;
            for (var j = 0; j < closureSchedule.length; j++) {
                var listItem = document.createElement('li');
                listItem.textContent = closureSchedule[j];
                myList4.appendChild(listItem);
            }

            var history = temples[i].history;
            for (var j = 0; j < history.length; j++) {
                var listItem = document.createElement('li');
                listItem.textContent = history[j];
                myList5.appendChild(listItem);
            }

            myArticle.appendChild(myH2);
            myArticle.appendChild(myH3);
            myArticle.appendChild(myPara2);
            myArticle.appendChild(myPara3);
            myArticle.appendChild(myPara4);
            myArticle.appendChild(myPara5);
            myArticle.appendChild(myList1);
            myArticle.appendChild(myPara6);
            myArticle.appendChild(myList2);
            myArticle.appendChild(myPara7);
            myArticle.appendChild(myList3);
            myArticle.appendChild(myPara8);
            myArticle.appendChild(myList4);
            myArticle.appendChild(myPara9);
            myArticle.appendChild(myList5);
            myArticle.appendChild(myIMG);

            section.appendChild(myArticle);
        }
    }
}