// This script turns JSON info into PC/NPC cards.

// To use this script, first put something like this in the html file:
/*<h2>Colony Leadership</h2>
<div class="leader"></div>
<section class="clearfix"></section>*/

// Then call this script with something like this:
/*let options = [
  {type: "npc", div: "leader"},
  {type: "npc", div: "security"},
  {type: "npc", div: "merchant"},
  {type: "npc", div: "colonist"},
]
fillCards(options, function () {
  clickLoad('article');
})*/

function fillJSON(divClass) {
  let sl = 'main .' + divClass;
  let section = document.querySelector(sl);
  let requestURL = 'js/personadb.json';
  let request = new XMLHttpRequest();
  request.open('GET', requestURL);
  request.responseType = 'json';
  request.send();
  request.onload = function () {
    let localJObj = request.response;
    showJSON(localJObj, divClass);
  }
  function showJSON(jsonObj, divClass) {
    let localJObj = jsonObj[divClass];

    for (let i = 0; i < localJObj.length; i++) {
      let myArticle = document.createElement('article');
      let myH2 = document.createElement('h2');
      let myH3 = document.createElement('h3');
      let myPara1 = document.createElement('p');
      let myPara2 = document.createElement('p');
      let myPara3 = document.createElement('p');
      let myPara4 = document.createElement('p');
      let myIMG = document.createElement('img');
      let myList1 = document.createElement('ul');

      myIMG.setAttribute('src', localJObj[i].imgref);
      myIMG.setAttribute('alt', localJObj[i].name);

      let listSkill = document.createElement('li');
      listSkill.textContent = 'Influenced by: ' + localJObj[i].skills;
      myList1.appendChild(listSkill);

      let listBias = document.createElement('li');
      listBias.textContent = 'Known Biases: ' + localJObj[i].biases;
      myList1.appendChild(listBias);

      let listStrength = document.createElement('li');
      listStrength.textContent = 'Resistant towards: ' + localJObj[i].strengths;
      myList1.appendChild(listStrength);

      let listWeak = document.createElement('li');
      listWeak.textContent = 'Sympathetic towards: ' + localJObj[i].weakness;
      myList1.appendChild(listWeak);

      myH2.textContent = localJObj[i].announce;
      myH3.textContent = localJObj[i].title + ' ' + localJObj[i].name + ' ' + localJObj[i].surname;
      myPara1.textContent = 'Appearance: ' + localJObj[i].appearance;
      myPara2.textContent = 'Background: ' + localJObj[i].background;
      myPara3.textContent = 'Cause of Death: ' + localJObj[i].death;
      myPara4.textContent = 'Social Profile: ';

      myArticle.appendChild(myH2);
      myArticle.appendChild(myH3);
      myArticle.appendChild(myIMG);
      myArticle.appendChild(myPara1);
      myArticle.appendChild(myPara2);
      myArticle.appendChild(myPara3);
      myArticle.appendChild(myPara4);
      myArticle.appendChild(myList1);

      section.appendChild(myArticle);

      myArticle.setAttribute("class", localJObj[i].attitude);
    }
  }
}

function fillPCDB(divClass) {
  let sl = 'main .' + divClass;
  let section = document.querySelector(sl);
  let requestURL = 'js/personadb.json';
  let request = new XMLHttpRequest();
  request.open('GET', requestURL);
  request.responseType = 'json';
  request.send();
  request.onload = function () {
    let localJObj = request.response;
    showPCDB(localJObj, divClass);
  }
  function showPCDB(jsonObj, divClass) {
    let localJObj = jsonObj[divClass];

    for (let i = 0; i < localJObj.length; i++) {
      let myArticle = document.createElement('article');
      let myH2 = document.createElement('h2');
      let myH3 = document.createElement('h3');
      let myH4 = document.createElement('h4');
      let myPara1 = document.createElement('p');
      let myPara2 = document.createElement('p');
      let myPara3 = document.createElement('p');
      let myPara4 = document.createElement('p');
      let myIMG = document.createElement('img');
      let myList1 = document.createElement('ul');

      myIMG.setAttribute('src', localJObj[i].imgref);
      myIMG.setAttribute('alt', localJObj[i].name);

      let listAchieve = document.createElement('li');
      listAchieve.textContent = 'Known for: ' + localJObj[i].achievements;
      myList1.appendChild(listAchieve);

      let listBias = document.createElement('li');
      listBias.textContent = 'Known Biases: ' + localJObj[i].biases;
      myList1.appendChild(listBias);

      let listStrength = document.createElement('li');
      listStrength.textContent = 'Resistant towards: ' + localJObj[i].strengths;
      myList1.appendChild(listStrength);

      let listWeak = document.createElement('li');
      listWeak.textContent = 'Sympathetic towards: ' + localJObj[i].weakness;
      myList1.appendChild(listWeak);

      myH2.textContent = localJObj[i].announce;
      myH3.textContent = localJObj[i].title + ' ' + localJObj[i].name + ' ' + localJObj[i].surname;
      myH4.textContent = localJObj[i].race + ' ' + localJObj[i].camptrait + ' ' + localJObj[i].classes + ' ' + localJObj[i].persona;
      myPara1.textContent = 'Appearance: ' + localJObj[i].appearance;
      myPara2.textContent = 'Background: ' + localJObj[i].background;
      myPara3.textContent = 'Cause of Death: ' + localJObj[i].death;
      myPara4.textContent = 'Social Profile: ';

      myArticle.appendChild(myH2);
      myArticle.appendChild(myH3);
      myArticle.appendChild(myH4);
      myArticle.appendChild(myIMG);
      myArticle.appendChild(myPara1);
      myArticle.appendChild(myPara2);
      myArticle.appendChild(myPara3);
      myArticle.appendChild(myPara4);
      myArticle.appendChild(myList1);

      section.appendChild(myArticle);

      myArticle.setAttribute("class", localJObj[i].attitude);
    }
  }
}