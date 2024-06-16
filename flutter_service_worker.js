'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"canvaskit/skwasm.worker.js": "bfb704a6c714a75da9ef320991e88b03",
"canvaskit/skwasm.js": "5d4f9263ec93efeb022bb14a3881d240",
"canvaskit/canvaskit.wasm": "9251bb81ae8464c4df3b072f84aa969b",
"canvaskit/canvaskit.js.symbols": "74a84c23f5ada42fe063514c587968c6",
"canvaskit/skwasm.js.symbols": "c3c05bd50bdf59da8626bbe446ce65a3",
"canvaskit/skwasm.wasm": "4051bfc27ba29bf420d17aa0c3a98bce",
"canvaskit/canvaskit.js": "738255d00768497e86aa4ca510cce1e1",
"canvaskit/chromium/canvaskit.wasm": "399e2344480862e2dfa26f12fa5891d7",
"canvaskit/chromium/canvaskit.js.symbols": "ee7e331f7f5bbf5ec937737542112372",
"canvaskit/chromium/canvaskit.js": "901bb9e28fac643b7da75ecfd3339f3f",
"manifest.json": "eb1fe08f5deeb69b4bd87fd3cd4acf36",
"flutter_bootstrap.js": "2d805233fd4faf080a3a50c327fe91b3",
"version.json": "4d5e7df50cec948d33302829680038fc",
"index.html": "b7d0f70aeab3507ebc0476bea191e24b",
"": "b7d0f70aeab3507ebc0476bea191e24b",
"main.dart.js": "e40c616c751aa75947bb076b036f478c",
"assets/AssetManifest.json": "c238fc8e48ac4131f23b5c1fed747cf9",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "94495392187d1e926a41d1bf06061cf5",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin.json": "fee549ab951ae0dfc10bdd59281c8a4e",
"assets/user.env": "5e7513059a8beb8ef37c590e3907835b",
"assets/fonts/MaterialIcons-Regular.otf": "3b2420e8e8f200c8eadce663634a769b",
"assets/assets/apple-splash-828-1792.jpg": "7ecf9a6860e07666e0a35f3be030cf6f",
"assets/assets/apple-splash-1284-2778.jpg": "9b4b6802902c4daffb8827da6ca3e34e",
"assets/assets/apple-icon-180.png": "6f2d1b619d2cfc48e5d2cda3e55cf1fd",
"assets/assets/apple-splash-1792-828.jpg": "5660b05a2c0b4e5d5b57b496fd34cbe3",
"assets/assets/apple-splash-2224-1668.jpg": "2498bbfa1e1e3fdb7ad40bf01c999a7f",
"assets/assets/apple-splash-2532-1170.jpg": "fcaf54ab4b99bb7cca26b0f47b917ca3",
"assets/assets/animations/loading.flr": "a1a4778742df72f09bb1425a714d802f",
"assets/assets/manifest-icon-512.maskable.png": "9ec75a37f435eebd11424c58031b28a7",
"assets/assets/apple-splash-2048-2732.jpg": "b0cec26b042e34b35c133b142454768f",
"assets/assets/apple-splash-1668-2224.jpg": "6a27a94637431919c2eb140464a6fd28",
"assets/assets/apple-splash-2388-1668.jpg": "ebdffb3ec9e72f9fa936526f47f457ac",
"assets/assets/apple-splash-640-1136.jpg": "499b14f65cf0fbc2126888623ce722d4",
"assets/assets/apple-splash-2048-1536.jpg": "c9aa9ab300666ca8b33d1057d7d43c99",
"assets/assets/apple-splash-2208-1242.jpg": "28f9b67c1794668079b62ad80eacb726",
"assets/assets/apple-splash-2778-1284.jpg": "d830c6f8905c15cd5918fcca0b2259e5",
"assets/assets/apple-splash-2436-1125.jpg": "1c2401a03f72c782bf6eb9e90ec25170",
"assets/assets/apple-splash-2160-1620.jpg": "845a0aeeda6c80a2ed6a2f26cac6f315",
"assets/assets/watchlist.svg": "63aa30233194f725cf150088d6d6bb02",
"assets/assets/apple-splash-1125-2436.jpg": "90c57c39653595db9747cb5eb27d5486",
"assets/assets/google_logo.png": "b75aecaf9e70a9b1760497e33bcd6db1",
"assets/assets/apple-splash-2732-2048.jpg": "bf35e474dfb972907567eef954a9368e",
"assets/assets/apple-splash-1136-640.jpg": "73eebf820dedec668011b8608b91c4ef",
"assets/assets/apple-splash-1668-2388.jpg": "dc0967c34b5e8100c01d760e66884df6",
"assets/assets/watchlist.png": "46f8683dbbca3096acf9ad5017dfb681",
"assets/assets/apple-splash-1170-2532.jpg": "46ff2339bcf31db8a9758876bf0977bb",
"assets/assets/apple-splash-1536-2048.jpg": "6b801f8c58273e1c2f4ce579058106dd",
"assets/assets/manifest-icon-192.maskable.png": "09a8c15aaec875d241660c5dc613288f",
"assets/assets/apple-splash-1242-2208.jpg": "4f80e5622d7c38f5ec4e240ae373c3ab",
"assets/assets/apple-splash-1334-750.jpg": "58d83b717964b569bd46932d9759043f",
"assets/assets/apple-splash-750-1334.jpg": "2867532d415da6f9921f705975ddbdaa",
"assets/assets/apple-splash-1620-2160.jpg": "3f9dd1abf29fe2fa7b94a27c74c34f83",
"assets/assets/apple-splash-1242-2688.jpg": "a7a78e614c472281c8e6328a2e5f630e",
"assets/assets/apple-splash-2688-1242.jpg": "c276a58206b938757dea24208fbde3a1",
"assets/NOTICES": "f89c19b93277ecbca2b453edb89d98a8",
"assets/AssetManifest.bin": "f67a6f7ae715a8c2b03389d457e0e31c",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"flutter.js": "383e55f7f3cce5be08fcf1f3881f585c"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
