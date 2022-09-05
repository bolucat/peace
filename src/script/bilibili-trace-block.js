// ==UserScript==
// @name        Bilibili Trace Block
// @namespace   https://raw.githubusercontent.com/bolucat/peace/master/src/script/bilibili-trace-block.js
// @match       *://*.bilibili.com/*
// @exclude     *://search.bilibili.com/*
// @run-at      document-start
// @grant       unsafeWindow
// @version     0.1
// @author      Bolucat
// @description Block Bilibili Trace
// For uBlock Origin or AdBlock Plus, add this filter manually:
// ||s1.hdslb.com/bfs/static/jinkela/long/js/sentry^
// ==/UserScript==

(function() {
    'use strict';
    unsafeWindow.Sentry = {
      init: () => {},
      Integrations: { Vue: class {constructor() {}}}
    }
    var ops = unsafeWindow.history.pushState;
    var ors = unsafeWindow.history.replaceState;
    var callOriginal = (stateObj, title, url, calling) => {
        if (new URL(`https://example.com${url}`).searchParams.get('vd_source') === null) {
          calling(stateObj, title, url);
        }
    }
    unsafeWindow.history.pushState = (stateObj, title, url) => callOriginal(stateObj, title, url, ops)
    unsafeWindow.history.replaceState = (stateObj, title, url) => callOriginal(stateObj, title, url, ors)
})();
