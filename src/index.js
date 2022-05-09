import './styles/main.css'
import { Elm } from './elm/Main.elm'
import * as serviceWorker from './javascript/serviceWorker'

Elm.Main.init({
  node: document.getElementById('root'),
  flags: { now: Date.now() },
})

// If you want your app to work offline and load faster, you can change
// unregister() to register() below. Note this comes with some pitfalls.
// Learn more about service workers: https://bit.ly/CRA-PWA
serviceWorker.unregister()
