'use strict';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "/assets\AssetManifest.json": "86eb057f83fb3e94dbcb69b94390469c",
"/assets\assets\animations\loading.flr": "a1a4778742df72f09bb1425a714d802f",
"/assets\assets\animations\Win64OpenSSL-1_1_1d.exe": "9fc22b6c2c8b844a35cf26c2c4a4ebaa",
"/assets\assets\google_logo.png": "b75aecaf9e70a9b1760497e33bcd6db1",
"/assets\FontManifest.json": "01700ba55b08a6141f33e168c4a6c22f",
"/assets\fonts\MaterialIcons-Regular.ttf": "56d3ffdef7a25659eab6a68a3fbfaf16",
"/assets\LICENSE": "ca323b1fc9b87641541b1369900de723",
"/assets\packages\cupertino_icons\assets\CupertinoIcons.ttf": "9a62a954b81a1ad45a58b9bcea89b50b",
"/index.html": "e4cf76fcf6181b055962bfb498521e0c",
"/main.dart.js": "baaf7efa87b7bce1a56e9c74b85ecb0d"
};

self.addEventListener('activate', function (event) {
  event.waitUntil(
    caches.keys().then(function (cacheName) {
      return caches.delete(cacheName);
    }).then(function (_) {
      return caches.open(CACHE_NAME);
    }).then(function (cache) {
      return cache.addAll(Object.keys(RESOURCES));
    })
  );
});

self.addEventListener('fetch', function (event) {
  event.respondWith(
    caches.match(event.request)
      .then(function (response) {
        if (response) {
          return response;
        }
        return fetch(event.request, {
          credentials: 'include'
        });
      })
  );
});
