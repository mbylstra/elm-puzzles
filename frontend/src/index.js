import './main.css';
import { PuzzlesApp } from './PuzzlesApp.elm';

var puzzlesApp = PuzzlesApp.embed(document.getElementById('root'));

puzzlesApp.ports.newlyCompiledElmSource.subscribe((jsSource) => {
  console.log(jsSource);

  var script = document.createElement("script");
  script.innerHTML = jsSource
  document.head.appendChild(script);

  console.log(Elm.Main);
  Elm.Main.embed(document.getElementById('compiled'));
});
