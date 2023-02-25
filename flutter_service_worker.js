'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "manifest.json": "eb1fe08f5deeb69b4bd87fd3cd4acf36",
"version.json": "4d5e7df50cec948d33302829680038fc",
"canvaskit/canvaskit.js": "97937cb4c2c2073c968525a3e08c86a3",
"canvaskit/canvaskit.wasm": "3de12d898ec208a5f31362cc00f09b9e",
"canvaskit/profiling/canvaskit.js": "c21852696bc1cc82e8894d851c01921a",
"canvaskit/profiling/canvaskit.wasm": "371bc4e204443b0d5e774d64a046eb99",
"flutter.js": "a85fcf6324d3c4d3ae3be1ae4931e9c5",
"assets/FontManifest.json": "87e04ddd47dc3c85e29dd1916b289700",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "6d342eb68f170c97609e9da345464e5e",
"assets/packages/flutterfire_ui/assets/countries.json": "8c937aac9f3b69162be779fbcd6199d2",
"assets/packages/flutterfire_ui/assets/fonts/SocialIcons.ttf": "a1207fae1578da27a062cb73d424aed9",
"assets/packages/flutterfire_ui/assets/icons/google.svg": "3b5ceaea5e2391782d39df225a375d5d",
"assets/packages/flutterfire_ui/assets/icons/apple_light.svg": "2508cc7c5d302fd37edff1b87fedb594",
"assets/packages/flutterfire_ui/assets/icons/facebook.svg": "5fad3daafe7c7c5163fca56662d2738a",
"assets/packages/flutterfire_ui/assets/icons/apple_dark.svg": "1b587ffd7d75c462847f8137a93f3161",
"assets/packages/flutterfire_ui/assets/icons/twitter.svg": "6086e2aad26effea1344c8e118520e32",
"assets/assets/apple-splash-1334-750.jpg": "58d83b717964b569bd46932d9759043f",
"assets/assets/watchlist.png": "46f8683dbbca3096acf9ad5017dfb681",
"assets/assets/apple-splash-2048-2732.jpg": "b0cec26b042e34b35c133b142454768f",
"assets/assets/apple-splash-2732-2048.jpg": "bf35e474dfb972907567eef954a9368e",
"assets/assets/apple-splash-1668-2224.jpg": "6a27a94637431919c2eb140464a6fd28",
"assets/assets/apple-splash-2208-1242.jpg": "28f9b67c1794668079b62ad80eacb726",
"assets/assets/apple-splash-1620-2160.jpg": "3f9dd1abf29fe2fa7b94a27c74c34f83",
"assets/assets/apple-splash-2778-1284.jpg": "d830c6f8905c15cd5918fcca0b2259e5",
"assets/assets/apple-splash-1170-2532.jpg": "46ff2339bcf31db8a9758876bf0977bb",
"assets/assets/apple-splash-2532-1170.jpg": "fcaf54ab4b99bb7cca26b0f47b917ca3",
"assets/assets/apple-splash-1668-2388.jpg": "dc0967c34b5e8100c01d760e66884df6",
"assets/assets/apple-splash-2388-1668.jpg": "ebdffb3ec9e72f9fa936526f47f457ac",
"assets/assets/manifest-icon-192.maskable.png": "09a8c15aaec875d241660c5dc613288f",
"assets/assets/google_logo.png": "b75aecaf9e70a9b1760497e33bcd6db1",
"assets/assets/apple-splash-1284-2778.jpg": "9b4b6802902c4daffb8827da6ca3e34e",
"assets/assets/apple-splash-1536-2048.jpg": "6b801f8c58273e1c2f4ce579058106dd",
"assets/assets/apple-splash-2688-1242.jpg": "c276a58206b938757dea24208fbde3a1",
"assets/assets/apple-splash-828-1792.jpg": "7ecf9a6860e07666e0a35f3be030cf6f",
"assets/assets/apple-splash-2436-1125.jpg": "1c2401a03f72c782bf6eb9e90ec25170",
"assets/assets/apple-splash-750-1334.jpg": "2867532d415da6f9921f705975ddbdaa",
"assets/assets/apple-splash-2160-1620.jpg": "845a0aeeda6c80a2ed6a2f26cac6f315",
"assets/assets/apple-icon-180.png": "6f2d1b619d2cfc48e5d2cda3e55cf1fd",
"assets/assets/manifest-icon-512.maskable.png": "9ec75a37f435eebd11424c58031b28a7",
"assets/assets/apple-splash-1136-640.jpg": "73eebf820dedec668011b8608b91c4ef",
"assets/assets/apple-splash-1242-2208.jpg": "4f80e5622d7c38f5ec4e240ae373c3ab",
"assets/assets/animations/loading.flr": "a1a4778742df72f09bb1425a714d802f",
"assets/assets/apple-splash-640-1136.jpg": "499b14f65cf0fbc2126888623ce722d4",
"assets/assets/apple-splash-1242-2688.jpg": "a7a78e614c472281c8e6328a2e5f630e",
"assets/assets/apple-splash-2048-1536.jpg": "c9aa9ab300666ca8b33d1057d7d43c99",
"assets/assets/apple-splash-1792-828.jpg": "5660b05a2c0b4e5d5b57b496fd34cbe3",
"assets/assets/apple-splash-1125-2436.jpg": "90c57c39653595db9747cb5eb27d5486",
"assets/assets/watchlist.svg": "63aa30233194f725cf150088d6d6bb02",
"assets/assets/apple-splash-2224-1668.jpg": "2498bbfa1e1e3fdb7ad40bf01c999a7f",
"assets/user.env": "e7f8d8e93b3cd8e14aeb9d8804f1fc73",
"assets/NOTICES": "1894618e6c1b1003331f6604910986c8",
"assets/fonts/MaterialIcons-Regular.otf": "e7069dfd19b331be16bed984668fe080",
"assets/AssetManifest.json": "86fa37e481773d987a01152686b0278a",
"index.html": "852f3c923fd286be97b34fbbdc3a7941",
"": "852f3c923fd286be97b34fbbdc3a7941",
"main.dart.js": "b8ef3d01a92c0e61b3f80a40809f7b2b"
};

// The application shell files that are downloaded before a service worker can
// start.
const CORE = [
  "main.dart.js",
"index.html",
"assets/AssetManifest.json",
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
