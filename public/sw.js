if(!self.define){const e=e=>{"require"!==e&&(e+=".js");let s=Promise.resolve();return n[e]||(s=new Promise((async s=>{if("document"in self){const n=document.createElement("script");n.src=e,document.head.appendChild(n),n.onload=s}else importScripts(e),s()}))),s.then((()=>{if(!n[e])throw new Error(`Module ${e} didn’t register its module`);return n[e]}))},s=(s,n)=>{Promise.all(s.map(e)).then((e=>n(1===e.length?e[0]:e)))},n={require:Promise.resolve(s)};self.define=(s,a,i)=>{n[s]||(n[s]=Promise.resolve().then((()=>{let n={};const t={uri:location.origin+s.slice(1)};return Promise.all(a.map((s=>{switch(s){case"exports":return n;case"module":return t;default:return e(s)}}))).then((e=>{const s=i(...e);return n.default||(n.default=s),n}))})))}}define("./sw.js",["./workbox-4a677df8"],(function(e){"use strict";importScripts(),self.skipWaiting(),e.clientsClaim(),e.precacheAndRoute([{url:"/_next/static/7q_cVy-PCtoEmwNefV-DF/_buildManifest.js",revision:"7q_cVy-PCtoEmwNefV-DF"},{url:"/_next/static/7q_cVy-PCtoEmwNefV-DF/_ssgManifest.js",revision:"7q_cVy-PCtoEmwNefV-DF"},{url:"/_next/static/chunks/618-ca7c9352b1aa1c75de10.js",revision:"7q_cVy-PCtoEmwNefV-DF"},{url:"/_next/static/chunks/ee9ce975-6225c1b9b33786fc2686.js",revision:"7q_cVy-PCtoEmwNefV-DF"},{url:"/_next/static/chunks/framework-895f067827ebe11ffe45.js",revision:"7q_cVy-PCtoEmwNefV-DF"},{url:"/_next/static/chunks/main-da1bc8f8d312ca485cee.js",revision:"7q_cVy-PCtoEmwNefV-DF"},{url:"/_next/static/chunks/pages/_app-ac22ff7afde3b547131a.js",revision:"7q_cVy-PCtoEmwNefV-DF"},{url:"/_next/static/chunks/pages/_error-737a04e9a0da63c9d162.js",revision:"7q_cVy-PCtoEmwNefV-DF"},{url:"/_next/static/chunks/pages/demo-19dfeb3ee8d4580d699f.js",revision:"7q_cVy-PCtoEmwNefV-DF"},{url:"/_next/static/chunks/pages/index-3b623abb7976957f9d73.js",revision:"7q_cVy-PCtoEmwNefV-DF"},{url:"/_next/static/chunks/polyfills-a40ef1678bae11e696dba45124eadd70.js",revision:"7q_cVy-PCtoEmwNefV-DF"},{url:"/_next/static/chunks/webpack-1a8a258926ecde76681b.js",revision:"7q_cVy-PCtoEmwNefV-DF"},{url:"/favicon.ico",revision:"b148a4d8217bc7a21cfe03191f3c365c"},{url:"/icons/android-chrome-192x192.png",revision:"c0b11e787b19d585bf7a282858a0417e"},{url:"/icons/android-chrome-512x512.png",revision:"a75235dcfbcffd49e0d69b1b87eecdf2"},{url:"/icons/apple-touch-icon.png",revision:"ae5a5608a3aa55d1a9cb63a89adf9a0a"},{url:"/icons/favicon-16x16.png",revision:"6fb90c01ac242d92c682e8a40209f648"},{url:"/icons/favicon-32x32.png",revision:"e7a0d6481869e8cde1d0cfc91d95bff6"},{url:"/icons/mstile-144x144.png",revision:"901b43fa3345a4a8fa46a707a4918df7"},{url:"/icons/mstile-150x150.png",revision:"b689a93e8e6cf729762110791385494f"},{url:"/icons/mstile-310x150.png",revision:"e749b1f4303cb60debfac4ac0aae84c9"},{url:"/icons/mstile-310x310.png",revision:"d1d4dec6743fa7852a7a4637b05641e9"},{url:"/icons/mstile-70x70.png",revision:"07f2e127aee0f69256221d0e6e42a8d0"},{url:"/icons/safari-pinned-tab.svg",revision:"05a33498196a28dddcb006fb2cfb2f46"},{url:"/manifest.json",revision:"b31a5720f28b2d449ab1b42e4f6df03b"},{url:"/wavr.svg",revision:"98d7f8a687ff207115f25750d56eda1b"}],{ignoreURLParametersMatching:[]}),e.cleanupOutdatedCaches(),e.registerRoute("/",new e.NetworkFirst({cacheName:"start-url",plugins:[{cacheWillUpdate:async({request:e,response:s,event:n,state:a})=>s&&"opaqueredirect"===s.type?new Response(s.body,{status:200,statusText:"OK",headers:s.headers}):s}]}),"GET"),e.registerRoute(/^https:\/\/fonts\.(?:gstatic)\.com\/.*/i,new e.CacheFirst({cacheName:"google-fonts-webfonts",plugins:[new e.ExpirationPlugin({maxEntries:4,maxAgeSeconds:31536e3})]}),"GET"),e.registerRoute(/^https:\/\/fonts\.(?:googleapis)\.com\/.*/i,new e.StaleWhileRevalidate({cacheName:"google-fonts-stylesheets",plugins:[new e.ExpirationPlugin({maxEntries:4,maxAgeSeconds:604800})]}),"GET"),e.registerRoute(/\.(?:eot|otf|ttc|ttf|woff|woff2|font.css)$/i,new e.StaleWhileRevalidate({cacheName:"static-font-assets",plugins:[new e.ExpirationPlugin({maxEntries:4,maxAgeSeconds:604800})]}),"GET"),e.registerRoute(/\.(?:jpg|jpeg|gif|png|svg|ico|webp)$/i,new e.StaleWhileRevalidate({cacheName:"static-image-assets",plugins:[new e.ExpirationPlugin({maxEntries:64,maxAgeSeconds:86400})]}),"GET"),e.registerRoute(/\/_next\/image\?url=.+$/i,new e.StaleWhileRevalidate({cacheName:"next-image",plugins:[new e.ExpirationPlugin({maxEntries:64,maxAgeSeconds:86400})]}),"GET"),e.registerRoute(/\.(?:mp3|wav|ogg)$/i,new e.CacheFirst({cacheName:"static-audio-assets",plugins:[new e.RangeRequestsPlugin,new e.ExpirationPlugin({maxEntries:32,maxAgeSeconds:86400})]}),"GET"),e.registerRoute(/\.(?:mp4)$/i,new e.CacheFirst({cacheName:"static-video-assets",plugins:[new e.RangeRequestsPlugin,new e.ExpirationPlugin({maxEntries:32,maxAgeSeconds:86400})]}),"GET"),e.registerRoute(/\.(?:js)$/i,new e.StaleWhileRevalidate({cacheName:"static-js-assets",plugins:[new e.ExpirationPlugin({maxEntries:32,maxAgeSeconds:86400})]}),"GET"),e.registerRoute(/\.(?:css|less)$/i,new e.StaleWhileRevalidate({cacheName:"static-style-assets",plugins:[new e.ExpirationPlugin({maxEntries:32,maxAgeSeconds:86400})]}),"GET"),e.registerRoute(/\/_next\/data\/.+\/.+\.json$/i,new e.StaleWhileRevalidate({cacheName:"next-data",plugins:[new e.ExpirationPlugin({maxEntries:32,maxAgeSeconds:86400})]}),"GET"),e.registerRoute(/\.(?:json|xml|csv)$/i,new e.NetworkFirst({cacheName:"static-data-assets",plugins:[new e.ExpirationPlugin({maxEntries:32,maxAgeSeconds:86400})]}),"GET"),e.registerRoute((({url:e})=>{if(!(self.origin===e.origin))return!1;const s=e.pathname;return!s.startsWith("/api/auth/")&&!!s.startsWith("/api/")}),new e.NetworkFirst({cacheName:"apis",networkTimeoutSeconds:10,plugins:[new e.ExpirationPlugin({maxEntries:16,maxAgeSeconds:86400})]}),"GET"),e.registerRoute((({url:e})=>{if(!(self.origin===e.origin))return!1;return!e.pathname.startsWith("/api/")}),new e.NetworkFirst({cacheName:"others",networkTimeoutSeconds:10,plugins:[new e.ExpirationPlugin({maxEntries:32,maxAgeSeconds:86400})]}),"GET"),e.registerRoute((({url:e})=>!(self.origin===e.origin)),new e.NetworkFirst({cacheName:"cross-origin",networkTimeoutSeconds:10,plugins:[new e.ExpirationPlugin({maxEntries:32,maxAgeSeconds:3600})]}),"GET")}));
