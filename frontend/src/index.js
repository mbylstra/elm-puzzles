import './main.css';
import { PuzzlesApp } from './PuzzlesApp.elm';

var puzzlesApp = PuzzlesApp.embed(document.getElementById('root'));

puzzlesApp.ports.newlyCompiledElmSource.subscribe((jsSource) => {
  if (typeof(Elm) !== "undefined") {
    delete Elm.Main;
  }
  console.log(jsSource);

  var script = document.createElement("script");
  script.innerHTML = jsSource
  document.head.appendChild(script);

  var answerNode = document.getElementById('compiled');
  console.log(Elm.Main);
  Elm.Main.embed(answerNode);

  setTimeout(function() {
    puzzlesApp.ports.renderedAnswerReady.send(answerNode.innerText, 0);
  })
});
